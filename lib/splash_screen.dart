import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/core/ads/app_open_ad_manager.dart';
import 'package:habit_tracker/core/ads/interstitial_ad_manager.dart';
import 'package:habit_tracker/core/services/remote_config_service.dart';
import '../core/services/profile_service.dart';
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
  late final AnimationController _controller;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _textOpacity;
  late final Animation<Offset> _textSlide;
  bool _navStarted = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _logoOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
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

    // Start animation.
    _controller.forward();

    // Keep splash visible for now (10 seconds), then continue flow.
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted || _navStarted) return;
      _navStarted = true;
      _maybeShowAdThenNavigate();
    });
  }

  Future<void> _maybeShowAdThenNavigate() async {
    if (!mounted) return;

    // Keep it best-effort and non-blocking. We already initialized RC in `main`,
    // but this helps when the splash is the first screen after cold start.
    await RemoteConfigService.refresh();
    if (!mounted) return;

    if (RemoteConfigService.showSplashAds) {
      // Priority: App Open > Interstitial
      final appOpenShown = await AppOpenAdManager.showIfAvailable();
      if (!mounted) return;

      if (!appOpenShown) {
        await InterstitialAdManager.showIfAvailable();
        if (!mounted) return;
      }
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
      // First time - show language selection
      nextScreen = const FirstTimeLanguageSelectionScreen();
    } else if (!isOnboardingComplete) {
      // Language selected but onboarding not completed
      nextScreen = const OnboardingScreen();
    } else if (isProfileSetup) {
      // Language selected + onboarding complete + profile setup - go to home
      nextScreen = const HomeShell();
    } else {
      // Language selected + onboarding complete but profile not setup - go to profile setup
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
                    // Logo that fades in first
                    SizedBox(height: 16.h),
                    // Text appears slightly after logo (fade + slide)
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
            bottom: 18.h,
            child: Center(
              child: SizedBox(
                width: 28.w,
                height: 28.w,
                child: CircularProgressIndicator(
                  strokeWidth: 3.w,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF327032),
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
      'ECO HABIT TRACKER',
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        color: const Color(0xFF327032),
        fontWeight: FontWeight.w700,
        letterSpacing: 1.sp,
        fontSize: 29.sp,
      ),
    );
  }
}
