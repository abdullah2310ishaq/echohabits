import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../core/services/profile_service.dart';
import '../core/services/locale_service.dart';
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

    _controller.forward().then((_) {
      _navigateToNextScreen();
    });
  }

  void _navigateToNextScreen() {
    if (!mounted) return;

    final localeService = Provider.of<LocaleService>(context, listen: false);
    final isLanguageSelected = localeService.isLanguageSelected();
    final isProfileSetup = ProfileService.isProfileSetupComplete();

    Widget nextScreen;
    if (!isLanguageSelected) {
      // First time - show language selection
      nextScreen = const FirstTimeLanguageSelectionScreen();
    } else if (isProfileSetup) {
      // Language selected and profile setup - go to home
      nextScreen = const HomeShell();
    } else {
      // Language selected but profile not setup - go to profile setup
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
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo that fades in first
                Opacity(opacity: _logoOpacity.value, child: _buildLogo()),
                SizedBox(height: 16.h),
                // Text appears slightly after logo
                Opacity(opacity: _textOpacity.value, child: _buildTitle()),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/logo.png',
      width: 96.w,
      height: 96.h,
      fit: BoxFit.contain,
    );
  }

  Widget _buildTitle() {
    return Text(
      'ECO HABIT TRACKER',
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        color: const Color(0xFF327032),
        fontWeight: FontWeight.w700,
        letterSpacing: 1.sp,
        fontSize: 26.sp,
      ),
    );
  }
}
