import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habit_tracker/core/ads/admob_ids.dart';
import 'package:habit_tracker/core/theme/app_colors.dart';

class NativeSmallAdView extends StatefulWidget {
  const NativeSmallAdView({super.key});

  @override
  State<NativeSmallAdView> createState() => _NativeSmallAdViewState();
}

class _NativeSmallAdViewState extends State<NativeSmallAdView> {
  NativeAd? _nativeAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  Future<void> _loadAd() async {
    final ad = NativeAd(
      adUnitId: AdIds.testNativeId,
      factoryId: 'listTile',
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          if (!mounted) return;
          setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (!mounted) return;
          setState(() => _isLoaded = false);
          debugPrint('[NativeSmallAd] failedToLoad: ${error.message}');
        },
      ),
      request: const AdRequest(),
    );

    _nativeAd = ad;
    await ad.load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _nativeAd;

    return Container(
      width: double.infinity,
      height: 140.h,
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.background.withValues(alpha: 0.07),
            blurRadius: 22.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: _isLoaded && ad != null
          ? AdWidget(ad: ad)
          : Center(
              child: SizedBox(
                width: 22.w,
                height: 22.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                  color: AppColors.primaryGreen,
                ),
              ),
            ),
    );
  }
}
