import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EcoToast {
  static OverlayEntry? _currentOverlayEntry;

  static void show(
    BuildContext context, {
    required String message,
    bool isSuccess = true,
    Duration duration = const Duration(seconds: 2),
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
      builder: (context) => _EcoToastWidget(
        message: message,
        tone: isSuccess ? _EcoToastTone.success : _EcoToastTone.error,
      ),
    );

    _currentOverlayEntry = overlayEntry;
    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
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

enum _EcoToastTone { success, error, info }

class _EcoToastWidget extends StatelessWidget {
  final String message;
  final _EcoToastTone tone;

  const _EcoToastWidget({required this.message, required this.tone});

  IconData get _icon => switch (tone) {
    _EcoToastTone.success => Icons.check_circle_rounded,
    _EcoToastTone.error => Icons.error_rounded,
    _EcoToastTone.info => Icons.info_rounded,
  };

  Color _containerColor(ThemeData theme) {
    return switch (tone) {
      _EcoToastTone.success => const Color(0xFF0F3D24),
      _EcoToastTone.error => const Color(0xFF3D1717),
      _EcoToastTone.info => const Color(0xFF102A43),
    };
  }

  Color _accentColor(ThemeData theme) {
    return switch (tone) {
      _EcoToastTone.success => const Color(0xFF2E7D32),
      _EcoToastTone.error => const Color(0xFFC62828),
      _EcoToastTone.info => const Color(0xFF1565C0),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  constraints: BoxConstraints(maxWidth: 1.sw - 32.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: _containerColor(theme),
                    borderRadius: BorderRadius.circular(8.r),
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
                      Container(
                        width: 28.w,
                        height: 28.w,
                        decoration: BoxDecoration(
                          color: _accentColor(theme).withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          _icon,
                          size: 18.sp,
                          color: _accentColor(theme),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Flexible(
                        child: Text(
                          message,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.25,
                          ),
                          textAlign: TextAlign.left,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
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
