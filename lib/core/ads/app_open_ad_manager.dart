import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habit_tracker/core/ads/admob_ids.dart';
import 'package:habit_tracker/core/navigation/app_navigator.dart';
import 'package:habit_tracker/core/services/profile_service.dart';
import 'package:habit_tracker/core/services/remote_config_service.dart';

class AppOpenAdManager with WidgetsBindingObserver {
  AppOpenAdManager._();

  static final AppOpenAdManager instance = AppOpenAdManager._();

  static const Duration _maxCacheAge = Duration(hours: 4);

  AppOpenAd? _appOpenAd;
  DateTime? _loadTime;
  bool _isShowingAd = false;
  bool _isLoadingAd = false;
  bool _suppressNextResumeAd = false;
  bool _sawPause = false;
  bool _isListening = false;

  static void suppressNextResumeOnce() {
    instance._suppressNextResumeAd = true;
  }

  void startListening() {
    if (_isListening) return;
    WidgetsBinding.instance.addObserver(this);
    _isListening = true;
  }

  void stopListening() {
    if (!_isListening) return;
    WidgetsBinding.instance.removeObserver(this);
    _isListening = false;
  }

  void bootstrapCacheAfterSplash() {
    if (!ProfileService.isEligibleForAds()) {
      return;
    }

    if (!RemoteConfigService.cacheAppOpenAd) {
      return;
    }

    loadAd();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startListening();
    });
  }

  Future<void> loadAd() async {
    if (!ProfileService.isEligibleForAds()) {
      return;
    }

    if (_isLoadingAd || isAdAvailable) {
      return;
    }

    _isLoadingAd = true;
    if (kDebugMode) {
      debugPrint('[AppOpenAd] loading... unitId=${AdIds.testAppOpenId}');
    }

    await AppOpenAd.load(
      adUnitId: AdIds.testAppOpenId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd?.dispose();
          _appOpenAd = ad;
          _loadTime = DateTime.now();
          _isLoadingAd = false;
          if (kDebugMode) {
            debugPrint('[AppOpenAd] loaded');
          }
        },
        onAdFailedToLoad: (error) {
          _isLoadingAd = false;
          _appOpenAd = null;
          if (kDebugMode) {
            debugPrint('[AppOpenAd] failedToLoad: $error');
          }
        },
      ),
    );
  }

  bool get isAdAvailable {
    final loadedAt = _loadTime;
    if (_appOpenAd == null || loadedAt == null) {
      return false;
    }
    return DateTime.now().difference(loadedAt) < _maxCacheAge;
  }

  /// Shows a splash app open ad, then bootstraps cached resume ads if enabled.
  Future<void> showSplashAppOpenAd(
    BuildContext context, {
    bool showLoadingDialog = true,
  }) async {
    if (!ProfileService.isEligibleForAds()) {
      return;
    }

    final completer = Completer<void>();

    void finish() {
      bootstrapCacheAfterSplash();
      if (!completer.isCompleted) {
        completer.complete();
      }
    }

    if (!context.mounted) {
      finish();
      return completer.future;
    }

    if (showLoadingDialog) {
      _showLoadingDialog(context);
    }

    await AppOpenAd.load(
      adUnitId: AdIds.testAppOpenId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          if (showLoadingDialog && context.mounted) {
            _hideLoadingDialog(context);
          }

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              _isShowingAd = true;
              if (kDebugMode) {
                debugPrint('[AppOpenAd] splash showed');
              }
            },
            onAdDismissedFullScreenContent: (ad) {
              _isShowingAd = false;
              ad.dispose();
              if (kDebugMode) {
                debugPrint('[AppOpenAd] splash dismissed');
              }
              finish();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              _isShowingAd = false;
              ad.dispose();
              if (kDebugMode) {
                debugPrint('[AppOpenAd] splash failedToShow: $error');
              }
              finish();
            },
          );

          ad.show();
        },
        onAdFailedToLoad: (error) {
          if (showLoadingDialog && context.mounted) {
            _hideLoadingDialog(context);
          }
          if (kDebugMode) {
            debugPrint('[AppOpenAd] splash failedToLoad: $error');
          }
          finish();
        },
      ),
    );

    return completer.future;
  }

  Future<void> showAdIfAvailable() async {
    if (!ProfileService.isEligibleForAds()) {
      return;
    }

    if (!RemoteConfigService.cacheAppOpenAd) {
      return;
    }

    if (_isShowingAd) {
      return;
    }

    if (!isAdAvailable) {
      await loadAd();
      return;
    }

    final ad = _appOpenAd;
    if (ad == null) {
      await loadAd();
      return;
    }

    final context = AppNavigator.navigatorKey.currentContext;
    if (context != null && context.mounted) {
      _showLoadingDialog(context);
      await Future<void>.delayed(const Duration(seconds: 2));
      if (context.mounted) {
        _hideLoadingDialog(context);
      }
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        if (kDebugMode) {
          debugPrint('[AppOpenAd] showed');
        }
      },
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAd = false;
        _appOpenAd = null;
        ad.dispose();
        loadAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAd = false;
        _appOpenAd = null;
        ad.dispose();
        if (kDebugMode) {
          debugPrint('[AppOpenAd] failedToShow: $error');
        }
        loadAd();
      },
    );

    _appOpenAd = null;
    ad.show();
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 36.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 18.w,
                    height: 18.w,
                    child: CircularProgressIndicator(strokeWidth: 2.w),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Loading ad…',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _hideLoadingDialog(BuildContext context) {
    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) {
      navigator.pop();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _sawPause = true;
      return;
    }

    if (state != AppLifecycleState.resumed) {
      return;
    }

    if (!_sawPause) {
      return;
    }
    _sawPause = false;

    if (_suppressNextResumeAd) {
      _suppressNextResumeAd = false;
      return;
    }

    if (!ProfileService.isEligibleForAds()) {
      return;
    }

    if (!RemoteConfigService.cacheAppOpenAd) {
      return;
    }

    showAdIfAvailable();
  }
}
