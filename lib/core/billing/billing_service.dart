import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:habit_tracker/core/services/profile_service.dart';

/// Handles store availability, product fetching, purchases, restores, and
/// persisting the "Pro" entitlement locally.
///
/// Note: Without a backend, purchases are trusted locally. For production apps
/// that need robust anti-fraud, add server-side receipt validation.
class BillingService extends ChangeNotifier {
  BillingService({
    required this.weeklyProductId,
    required this.lifetimeProductId,
  });

  final String weeklyProductId;
  final String lifetimeProductId;

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;

  bool _initialized = false;
  bool _storeAvailable = false;
  bool _isLoadingProducts = false;
  bool _purchaseInProgress = false;
  String? _errorMessage;

  final Map<String, ProductDetails> _products = {};

  bool get storeAvailable => _storeAvailable;
  bool get isLoadingProducts => _isLoadingProducts;
  bool get purchaseInProgress => _purchaseInProgress;
  String? get errorMessage => _errorMessage;

  ProductDetails? get weeklyProduct => _products[weeklyProductId];
  ProductDetails? get lifetimeProduct => _products[lifetimeProductId];

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    _log('init() start');

    _purchaseSub = _iap.purchaseStream.listen(
      _onPurchaseUpdates,
      onError: (Object e, StackTrace st) {
        _log('purchaseStream error: $e');
        _setError('Purchase stream error: $e');
      },
    );

    _storeAvailable = await _iap.isAvailable();
    _log('storeAvailable=$_storeAvailable');
    notifyListeners();

    if (!_storeAvailable) {
      _setError('Store is not available.');
      return;
    }

    await fetchProducts();
    await restorePurchases(); // Keep entitlement fresh on cold start.
  }

  Future<void> fetchProducts() async {
    if (!_storeAvailable) return;
    if (_isLoadingProducts) return;

    _isLoadingProducts = true;
    _errorMessage = null;
    notifyListeners();

    final ids = <String>{weeklyProductId, lifetimeProductId};
    _log('queryProductDetails ids=$ids');

    final response = await _iap.queryProductDetails(ids);
    if (response.error != null) {
      _log('queryProductDetails error=${response.error}');
      _setError('Failed to load products: ${response.error}');
      _isLoadingProducts = false;
      notifyListeners();
      return;
    }

    if (response.notFoundIDs.isNotEmpty) {
      _log('notFoundIDs=${response.notFoundIDs}');
      _setError('Products not found: ${response.notFoundIDs.join(", ")}');
    }

    _products
      ..clear()
      ..addEntries(response.productDetails.map((p) => MapEntry(p.id, p)));

    _log(
      'products loaded: ${_products.keys.join(", ")}',
    );

    _isLoadingProducts = false;
    notifyListeners();
  }

  String weeklyPriceLabel() {
    final p = weeklyProduct;
    if (p == null) return '...';
    // Trial is configured in Play Console / App Store Connect.
    // We show the configured marketing text here.
    return '${p.price} / week • 3-day free trial';
  }

  String lifetimePriceLabel() {
    final p = lifetimeProduct;
    if (p == null) return '...';
    return '${p.price} one-time payment';
  }

  Future<void> buySelected({required bool weekly}) async {
    if (!_storeAvailable) {
      _setError('Store not available.');
      return;
    }

    _errorMessage = null;
    notifyListeners();

    final product = weekly ? weeklyProduct : lifetimeProduct;
    if (product == null) {
      _setError('Product not loaded yet.');
      return;
    }

    _purchaseInProgress = true;
    notifyListeners();

    _log('buySelected weekly=$weekly productId=${product.id}');

    try {
      final param = PurchaseParam(productDetails: product);
      await _iap.buyNonConsumable(purchaseParam: param);
    } catch (e) {
      _log('buySelected exception: $e');
      _setError('Purchase failed: $e');
      _purchaseInProgress = false;
      notifyListeners();
    }
  }

  /// Restore purchases and re-apply entitlement.
  Future<void> restorePurchases() async {
    if (!_storeAvailable) return;
    _log('restorePurchases()');
    try {
      await _iap.restorePurchases();
    } catch (e) {
      _log('restorePurchases exception: $e');
      _setError('Restore failed: $e');
      notifyListeners();
    }
  }

  // Note: Offer/base-plan selection for subscriptions is configured in the
  // store console. For now, we rely on the default offer selected by the store.

  Future<void> _onPurchaseUpdates(List<PurchaseDetails> purchases) async {
    if (purchases.isEmpty) return;
    _log('purchase updates count=${purchases.length}');

    for (final p in purchases) {
      _log('purchase status=${p.status} id=${p.productID}');

      if (p.status == PurchaseStatus.error) {
        _setError('Purchase error: ${p.error}');
        continue;
      }

      if (p.status == PurchaseStatus.canceled) {
        _setError('Purchase canceled.');
        continue;
      }

      final isEntitled = p.productID == weeklyProductId ||
          p.productID == lifetimeProductId;

      if (isEntitled &&
          (p.status == PurchaseStatus.purchased ||
              p.status == PurchaseStatus.restored)) {
        _log('entitlement granted for ${p.productID}');
        await ProfileService.setProUser(true);
      }

      if (p.pendingCompletePurchase) {
        _log('completePurchase for ${p.productID}');
        await _iap.completePurchase(p);
      }
    }

    _purchaseInProgress = false;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _log('ERROR: $message');
  }

  void _log(String message) {
    // ignore: avoid_print
    debugPrint('[BillingService] $message');
  }

  @override
  void dispose() {
    _purchaseSub?.cancel();
    _purchaseSub = null;
    super.dispose();
  }
}

