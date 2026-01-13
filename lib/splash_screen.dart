import 'package:flutter/material.dart';
import '../core/services/profile_service.dart';
import '../profile_first.dart';
import '../home/home_shell.dart';

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

    final isProfileSetup = ProfileService.isProfileSetupComplete();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) =>
            isProfileSetup ? const HomeShell() : const ProfileFirst(),
      ),
    );
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
                const SizedBox(height: 20),
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
      width: 96,
      height: 96,
      fit: BoxFit.contain,
    );
  }

  Widget _buildTitle() {
    return Text(
      'ECO HABIT TRACKER',
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        color: Color(0xFF327032),
        fontWeight: FontWeight.w700,
        letterSpacing: 1.3,
        fontSize: 33,
      ),
    );
  }
}
