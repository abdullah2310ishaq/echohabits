import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habit_tracker/core/ads/admob_ids.dart';
import 'package:habit_tracker/core/navigation/app_navigator.dart';

class InterstitialAdManager {
  InterstitialAdManager._();

  static bool _isShowingAd = false;

  static void _showLoading(BuildContext context) {
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

  static void _hideLoading(BuildContext context) {
    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) {
      navigator.pop();
    }
  }

  /// Loads and shows an interstitial ad.
  /// Completes after the ad is dismissed or if load/show fails.
  static Future<void> show({
    String? adUnitId,
    BuildContext? context,
    bool showLoadingDialog = true,
    VoidCallback? onComplete,
  }) async {
    if (_isShowingAd) {
      onComplete?.call();
      return;
    }

    final unitId = adUnitId ?? AdIds.testInterId;
    final dialogContext =
        context ?? AppNavigator.navigatorKey.currentContext;
    final completer = Completer<void>();

    void complete() {
      onComplete?.call();
      if (!completer.isCompleted) {
        completer.complete();
      }
    }

    if (showLoadingDialog &&
        dialogContext != null &&
        dialogContext.mounted) {
      _showLoading(dialogContext);
    }

    await InterstitialAd.load(
      adUnitId: unitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          if (showLoadingDialog &&
              dialogContext != null &&
              dialogContext.mounted) {
            _hideLoading(dialogContext);
          }

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              _isShowingAd = true;
              if (kDebugMode) {
                debugPrint('[InterstitialAd] showed');
              }
            },
            onAdDismissedFullScreenContent: (ad) {
              _isShowingAd = false;
              ad.dispose();
              if (kDebugMode) {
                debugPrint('[InterstitialAd] dismissed');
              }
              complete();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              _isShowingAd = false;
              ad.dispose();
              if (kDebugMode) {
                debugPrint('[InterstitialAd] failedToShow: $error');
              }
              complete();
            },
          );

          ad.show();
        },
        onAdFailedToLoad: (error) {
          if (showLoadingDialog &&
              dialogContext != null &&
              dialogContext.mounted) {
            _hideLoading(dialogContext);
          }
          if (kDebugMode) {
            debugPrint('[InterstitialAd] failedToLoad: $error');
          }
          complete();
        },
      ),
    );

    return completer.future;
  }
}
