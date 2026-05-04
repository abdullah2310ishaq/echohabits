import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracker/core/ads/interstitial_ad_manager.dart';
import 'package:habit_tracker/core/navigation/app_navigator.dart';

class InterstitialAdPresenter {
  static Future<bool> showWithLoadingDialogIfPossible() async {
    final context = AppNavigator.navigatorKey.currentContext;
    if (context == null) {
      // Fall back to a direct show if we don't have a context yet.
      return InterstitialAdManager.showIfAvailable();
    }

    final navigator = Navigator.of(context, rootNavigator: true);

    // Show a minimal blocking dialog first (required by product).
    unawaited(
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
                      'Showing ad…',
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
      ),
    );

    await Future<void>.delayed(const Duration(seconds: 3));

    // Close the dialog before presenting the full-screen ad.
    if (navigator.canPop()) {
      navigator.pop();
    }

    return InterstitialAdManager.showIfAvailable();
  }
}
