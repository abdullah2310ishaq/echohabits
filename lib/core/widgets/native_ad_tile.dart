import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeAdTile extends StatefulWidget {
  const NativeAdTile({
    required this.adUnitId,
    required this.factoryId,
    required this.height,
    super.key,
    this.enabled = true,
    this.margin,
  });

  final String adUnitId;
  final String factoryId;
  final double height;
  final bool enabled;
  final EdgeInsetsGeometry? margin;

  @override
  State<NativeAdTile> createState() => _NativeAdTileState();
}

class _NativeAdTileState extends State<NativeAdTile> {
  NativeAd? _nativeAd;
  bool _isLoaded = false;
  Brightness? _lastBrightness;

  @override
  void initState() {
    super.initState();
    _loadAdIfNeeded();
  }

  @override
  void didUpdateWidget(covariant NativeAdTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    final hasPlacementChanged = oldWidget.adUnitId != widget.adUnitId ||
        oldWidget.factoryId != widget.factoryId ||
        oldWidget.enabled != widget.enabled;
    if (hasPlacementChanged) {
      _disposeAd();
      _loadAdIfNeeded();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final brightness = Theme.of(context).brightness;
    if (_lastBrightness != null && _lastBrightness != brightness) {
      _disposeAd();
      _loadAdIfNeeded();
    }
    _lastBrightness = brightness;
  }

  void _loadAdIfNeeded() {
    if (!widget.enabled) {
      return;
    }

    final ad = NativeAd(
      adUnitId: widget.adUnitId,
      request: const AdRequest(),
      factoryId: widget.factoryId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (!mounted) return;
          setState(() => _isLoaded = false);
        },
      ),
    );

    _nativeAd = ad;
    ad.load();
  }

  void _disposeAd() {
    _nativeAd?.dispose();
    _nativeAd = null;
    _isLoaded = false;
  }

  @override
  void dispose() {
    _disposeAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: widget.margin,
      height: widget.height,
      width: double.infinity,
      child: _isLoaded && _nativeAd != null
          ? AdWidget(ad: _nativeAd!)
          : _NativeAdPlaceholder(height: widget.height),
    );
  }
}

class _NativeAdPlaceholder extends StatelessWidget {
  const _NativeAdPlaceholder({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F4),
        borderRadius: BorderRadius.circular(12.r),
      ),
    );
  }
}
