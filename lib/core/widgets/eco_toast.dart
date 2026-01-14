import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EcoToast {
  static OverlayEntry? _currentOverlayEntry;

  static void show(
    BuildContext context, {
    required String message,
    bool isSuccess = true,
  }) {
    // Remove previous toast if exists (prevent stacking)
    if (_currentOverlayEntry != null) {
      try {
        if (_currentOverlayEntry!.mounted) {
          _currentOverlayEntry!.remove();
        }
      } catch (e) {
        // Ignore errors if overlay is already removed
      }
      _currentOverlayEntry = null;
    }

    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) =>
          _EcoToastWidget(message: message, isSuccess: isSuccess),
    );

    _currentOverlayEntry = overlayEntry;
    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      try {
        if (overlayEntry.mounted) {
          overlayEntry.remove();
        }
        if (_currentOverlayEntry == overlayEntry) {
          _currentOverlayEntry = null;
        }
      } catch (e) {
        // Ignore errors if overlay is already removed
        _currentOverlayEntry = null;
      }
    });
  }
}

class _EcoToastWidget extends StatelessWidget {
  final String message;
  final bool isSuccess;

  const _EcoToastWidget({required this.message, required this.isSuccess});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 90.h, // higher position above navbar
          left: 0,
          right: 0,
          child: SafeArea(
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 1.sw - 32.w,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSuccess
                        ? const Color(0xFF2E7D32)
                        : Colors.orange[700],
                    borderRadius: BorderRadius.circular(18.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: Offset(0, 2.h),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          message,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isSuccess) ...[
                        SizedBox(width: 6.w),
                        Text('🔥', style: TextStyle(fontSize: 16.sp)),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
