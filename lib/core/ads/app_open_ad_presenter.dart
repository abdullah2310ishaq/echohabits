import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracker/core/ads/app_open_ad_manager.dart';
import 'package:habit_tracker/core/navigation/app_navigator.dart';

class AppOpenAdPresenter {
  static Future<bool> showFromSplash({
    Duration maxWait = const Duration(seconds: 6),
    Duration pollInterval = const Duration(milliseconds: 250),
    Duration minDialogDuration = const Duration(seconds: 2),
  }) async {
    final context = AppNavigator.navigatorKey.currentContext;
    if (context == null) {
      return AppOpenAdManager.showIfAvailable();
    }

    final navigator = Navigator.of(context, rootNavigator: true);
    final startedAt = DateTime.now();

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
                      'Ad is loading…',
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

    Duration waited = Duration.zero;
    while (waited < maxWait) {
      if (AppOpenAdManager.isAdAvailable()) {
        final elapsed = DateTime.now().difference(startedAt);
        if (elapsed < minDialogDuration) {
          await Future<void>.delayed(minDialogDuration - elapsed);
        }

        if (navigator.canPop()) {
          navigator.pop();
        }

        return AppOpenAdManager.showIfAvailable();
      }

      AppOpenAdManager.loadAdIfNeeded();
      await Future<void>.delayed(pollInterval);
      waited += pollInterval;
    }

    final elapsed = DateTime.now().difference(startedAt);
    if (elapsed < minDialogDuration) {
      await Future<void>.delayed(minDialogDuration - elapsed);
    }

    if (navigator.canPop()) {
      navigator.pop();
    }

    return false;
  }
}

