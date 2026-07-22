import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habit_tracker/core/ads/admob_ids.dart';
import 'package:habit_tracker/core/theme/app_colors.dart';

class AdaptiveBannerAdView extends StatefulWidget {
  const AdaptiveBannerAdView({super.key});

  @override
  State<AdaptiveBannerAdView> createState() => _AdaptiveBannerAdViewState();
}

class _AdaptiveBannerAdViewState extends State<AdaptiveBannerAdView> {
  BannerAd? _bannerAd;
  AdSize? _adSize;
  bool _isLoaded = false;
  bool _loadFailed = false;
  bool _isLoading = false;
  int? _loadedWidth;

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  Future<void> _loadBanner(int width) async {
    if (!mounted || width <= 0) return;
    if (_isLoading || _loadedWidth == width) return;

    _isLoading = true;

    await _bannerAd?.dispose();
    _bannerAd = null;

    if (mounted) {
      setState(() {
        _isLoaded = false;
        _loadFailed = false;
        _adSize = null;
      });
    }

    final adSize =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);

    if (!mounted) {
      _isLoading = false;
      return;
    }

    if (adSize == null) {
      setState(() {
        _loadFailed = true;
        _isLoading = false;
      });
      debugPrint('[BannerAd] Unable to get adaptive banner size.');
      return;
    }

    if (mounted) {
      setState(() => _adSize = adSize);
    }

    final bannerAd = BannerAd(
      adUnitId: AdIds.testBannerId,
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) return;
          setState(() {
            _bannerAd = ad as BannerAd;
            _adSize = ad.size;
            _isLoaded = true;
            _loadFailed = false;
            _loadedWidth = width;
            _isLoading = false;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (!mounted) return;
          setState(() {
            _bannerAd = null;
            _isLoaded = false;
            _loadFailed = true;
            _loadedWidth = width;
            _isLoading = false;
          });
          debugPrint('[BannerAd] failedToLoad: ${error.message}');
        },
      ),
    );

    _bannerAd = bannerAd;
    await bannerAd.load();
  }

  void _scheduleLoad(int width) {
    if (width <= 0 || _isLoading || _loadedWidth == width) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadBanner(width);
      }
    });
  }

  Widget _buildAdSlot() {
    final ad = _bannerAd;
    final size = (_isLoaded && ad != null) ? ad.size : _adSize;

    if (_loadFailed || size == null) {
      return const SizedBox.shrink();
    }

    final adWidth = size.width.toDouble();
    final adHeight = size.height.toDouble();

    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: adWidth,
        height: adHeight,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite && constraints.maxWidth > 0
            ? constraints.maxWidth.truncate()
            : MediaQuery.sizeOf(context).width.truncate();

        _scheduleLoad(width);

        return SizedBox(
          width: double.infinity,
          child: _buildAdSlot(),
        );
      },
    );
  }
}
