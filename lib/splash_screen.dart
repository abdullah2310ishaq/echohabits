import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/l10n/app_localizations.dart';
import 'package:habit_tracker/core/ads/app_open_ad_manager.dart';
import 'package:habit_tracker/core/ads/interstitial_ad_manager.dart';
import 'package:habit_tracker/core/services/profile_service.dart';
import 'package:habit_tracker/core/services/remote_config_service.dart';
import '../core/services/locale_service.dart';
import '../onboarding/onboarding.dart';
import '../profile_first.dart';
import '../home/home_shell.dart';
import '../settings/first_time_language_selection.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const Duration _minimumSplashDuration = Duration(seconds: 4);
  late final AnimationController _controller;
  late final Animation<double> _textOpacity;
  late final Animation<Offset> _textSlide;
  bool _showAdNotice = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _textOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
    );

    _textSlide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _controller.forward();
    _startSplashFlow();
  }

  Future<void> _startSplashFlow() async {
    await Future.delayed(_minimumSplashDuration);
    if (!mounted) return;

    await RemoteConfigService.refresh();
    if (!mounted) return;

    if (!ProfileService.isEligibleForAds()) {
      _navigateToNextScreen();
      return;
    }

    final showInter = RemoteConfigService.splashInterAd;
    final showAppOpen = RemoteConfigService.splashAppOpenAd;

    if (!showInter && !showAppOpen) {
      AppOpenAdManager.instance.bootstrapCacheAfterSplash();
      _navigateToNextScreen();
      return;
    }

    if (mounted) {
      setState(() => _showAdNotice = true);
    }

    // If both are true, interstitial takes priority (not both).
    if (showInter) {
      await InterstitialAdManager.show(
        context: context,
        showLoadingDialog: false,
      );
      if (!mounted) return;
      AppOpenAdManager.instance.bootstrapCacheAfterSplash();
      _navigateToNextScreen();
      return;
    }

    if (showAppOpen) {
      await AppOpenAdManager.instance.showSplashAppOpenAd(
        context,
        showLoadingDialog: false,
      );
      if (!mounted) return;
    }

    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    if (!mounted) return;

    final localeService = Provider.of<LocaleService>(context, listen: false);
    final isLanguageSelected = localeService.isLanguageSelected();
    final isProfileSetup = ProfileService.isProfileSetupComplete();
    final isOnboardingComplete = ProfileService.isOnboardingComplete();

    Widget nextScreen;
    if (!isLanguageSelected) {
      nextScreen = const FirstTimeLanguageSelectionScreen();
    } else if (!isOnboardingComplete) {
      nextScreen = const OnboardingScreen();
    } else if (isProfileSetup) {
      nextScreen = const HomeShell();
    } else {
      nextScreen = const ProfileFirst();
    }

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (context) => nextScreen));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 16.h),
                    Opacity(
                      opacity: _textOpacity.value,
                      child: SlideTransition(
                        position: _textSlide,
                        child: _buildTitle(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(bottom: 18.h),
                child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.w,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF327032),
                        ),
                      ),
                    ),
                    if (_showAdNotice) ...[
                      SizedBox(height: 12.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Text(
                          AppLocalizations.of(context)!.splashAdNotice,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Eco Habit',
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        color: const Color(0xFF327032),
        fontWeight: FontWeight.w700,
        letterSpacing: 1.sp,
        fontSize: 29.sp,
      ),
    );
  }
}
