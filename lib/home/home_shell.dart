import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/l10n/app_localizations.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:habit_tracker/core/ads/admob_ids.dart';
import 'package:habit_tracker/core/services/ad_visibility_service.dart';
import 'package:habit_tracker/core/services/habit_service.dart';
import 'package:habit_tracker/core/widgets/native_ad_tile.dart';
import 'home_one.dart';
import '../habits/habits_one.dart';
import '../leaderboard/leaderboard.dart';
import '../profile/profile.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late int _currentIndex;
  int _screenAnimToken = 0;

  final List<Widget> _screens = [
    const HomeOne(),
    const HabitsOne(),
    const Leaderboard(),
    const Profile(),
  ];

  @override
  void initState() {
    super.initState();
    final maxIndex = _screens.length - 1;
    _currentIndex = widget.initialIndex.clamp(0, maxIndex);
  }

  Future<bool?> _showExitDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.r),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    AppLocalizations.of(context)!.exit,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  // Message
                  Text(
                    AppLocalizations.of(context)!.areYouSureYouWantToExit,
                    style: TextStyle(fontSize: 16.sp, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h),
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black54,
                            side: BorderSide(color: Colors.grey[300]!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.cancel,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                            exit(0);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            elevation: 0,
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.exit,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        final shouldExit = await _showExitDialog(context);
        if (shouldExit == true && context.mounted) {
          exit(0);
        }
      },

      child: Scaffold(
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 520),
          reverseDuration: Duration.zero,
          switchInCurve: Curves.easeInCirc,
          switchOutCurve: Curves.easeInCubic,
          layoutBuilder: (currentChild, previousChildren) {
            // Show only the new child; drop the old one immediately.
            return currentChild ?? const SizedBox.shrink();
          },
          transitionBuilder: (child, animation) {
            final currentKey = ValueKey<String>(
              'home_${_currentIndex}_$_screenAnimToken',
            );
            final isIncoming = child.key == currentKey;

            return FadeTransition(
              opacity: isIncoming
                  ? animation
                  : const AlwaysStoppedAnimation<double>(0),
              child: SlideTransition(
                position: animation.drive(
                  Tween<Offset>(
                    begin: const Offset(0.14, 0.0),
                    end: Offset.zero,
                  ).chain(CurveTween(curve: Curves.easeOutCubic)),
                ),
                child: child,
              ),
            );
          },
          child: KeyedSubtree(
            key: ValueKey<String>('home_${_currentIndex}_$_screenAnimToken'),
            child: _screens[_currentIndex],
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<HabitService>(
              builder: (context, habitService, child) {
                final shouldShow =
                    _currentIndex == 0 &&
                    AdVisibilityService.shouldShowHomeShellNativeAd(
                      completedActionsToday: habitService.completedActionsToday,
                    );

                if (!shouldShow) return const SizedBox.shrink();

                return SafeArea(
                  top: false,
                  child: NativeAdTile(
                    adUnitId: AdMobIds.nativeMediumUnitId,
                    factoryId: 'listTileLanguage',
                    height: 150.h,
                    margin: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 8.h),
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10.r,
                    offset: Offset(0, -2.h),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.only(top: 12.h, bottom: 8.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildNavItem(
                          label: AppLocalizations.of(context)!.home,
                          index: 0,
                          svgAsset: 'assets/home.svg',
                        ),
                      ),
                      Expanded(
                        child: _buildNavItem(
                          icon: Icons.list,
                          label: AppLocalizations.of(context)!.habitLibrary,
                          index: 1,
                        ),
                      ),
                      Expanded(
                        child: _buildNavItem(
                          label: AppLocalizations.of(context)!.leaderboard,
                          index: 2,
                          svgAsset: 'assets/leader.svg',
                        ),
                      ),
                      Expanded(
                        child: _buildNavItem(
                          label: AppLocalizations.of(context)!.setUpYourProfile,
                          index: 3,
                          svgAsset: 'assets/profile.svg',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    IconData? icon,
    String? svgAsset,
    required String label,
    required int index,
  }) {
    final isActive = _currentIndex == index;
    final iconSize = index == 0 ? 24.w : 20.w;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (_currentIndex == index) return;
          setState(() {
            _currentIndex = index;
            _screenAnimToken++;
          });
        },
        borderRadius: BorderRadius.circular(12.r),
        splashColor: Colors.white.withOpacity(0.1),
        highlightColor: Colors.white.withOpacity(0.05),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                scale: isActive ? 1.12 : 1.0,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutBack,
                child: svgAsset != null
                    ? SvgPicture.asset(
                        svgAsset,
                        width: iconSize,
                        height: iconSize,
                        colorFilter: ColorFilter.mode(
                          Colors.white.withOpacity(isActive ? 1.0 : 0.8),
                          BlendMode.srcIn,
                        ),
                      )
                    : Icon(
                        icon,
                        color: Colors.white.withOpacity(isActive ? 1.0 : 0.8),
                        size: iconSize,
                      ),
              ),
              SizedBox(height: 4.h),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                style: TextStyle(
                  color: Colors.white.withOpacity(isActive ? 1.0 : 0.8),
                  fontSize: 12.sp,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 4.h),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                // Avoid "back" curves here: they overshoot < 0 and can create negative widths.
                curve: Curves.easeOutCubic,
                width: isActive ? 20.w : 0.0,
                height: 2.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(1.r),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
