import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracker/l10n/app_localizations.dart';
import '../profile_first.dart';
import '../home/home_shell.dart';
import '../core/services/profile_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  final List<OnboardingPageData> _pages = [
    const OnboardingPageData(
      titleKey: 'onboardingTitle1',
      descriptionKey: 'onboardingDescription1',
      imageAsset: 'assets/onb1.png',
    ),
    const OnboardingPageData(
      titleKey: 'onboardingTitle2',
      descriptionKey: 'onboardingDescription2',
      imageAsset: 'assets/onb2.png',
    ),
    const OnboardingPageData(
      titleKey: 'onboardingTitle3',
      descriptionKey: 'onboardingDescription3',
      imageAsset: 'assets/onb3.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted || !_pageController.hasClients) return;
      final nextPageIndex = (_currentPage + 1) % _pages.length;
      _pageController.animateToPage(
        nextPageIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _completeOnboarding() {
    if (!mounted) return;
    ProfileService.setOnboardingComplete(true).then((_) {
      if (!mounted) return;
      final isProfileSetup = ProfileService.isProfileSetupComplete();
      final Widget nextScreen = isProfileSetup
          ? const HomeShell()
          : const ProfileFirst();
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => nextScreen));
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(context, _pages[index], index);
                },
              ),
            ),
            SizedBox(height: 28.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (dotIndex) => _buildPageIndicator(dotIndex == _currentPage),
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 0.4.sw,
                    child: TextButton(
                      onPressed: _skipOnboarding,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[600],
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          l10n.skip,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 12.h,
                      ),
                      minimumSize: Size(120.w, 48.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _currentPage == _pages.length - 1
                          ? l10n.continueButton
                          : l10n.next,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(
    BuildContext context,
    OnboardingPageData pageData,
    int index,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final title = _getLocalizedString(l10n, pageData.titleKey);
    final description = _getLocalizedString(l10n, pageData.descriptionKey);

    return Column(
      children: [
        const SizedBox.shrink(),
        // Top illustration area with onboarding images
        SizedBox(
          height: 0.4.sh,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: _buildOnboardingIllustration(pageData, index),
              ),
            ],
          ),
        ),
        SizedBox(height: 180.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF040404),
              height: 1.2,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              color: const Color(0xFF0C0C0C),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOnboardingIllustration(OnboardingPageData pageData, int index) {
    final blurAsset = switch (index) {
      0 => 'assets/b1blur.png',
      1 => 'assets/b2blur.png',
      2 => 'assets/b3blur.png',
      _ => null,
    };

    if (blurAsset == null) {
      return Image.asset(pageData.imageAsset, fit: BoxFit.contain);
    }

    final imageSize = 0.62.sw;
    final yOffset = (imageSize / 2 - 35.h).clamp(0.0, double.infinity);
    final backgroundColor = Colors.white;

    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: Image.asset(
            blurAsset,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
        ..._buildBlurFadeOverlays(
          index: index,
          backgroundColor: backgroundColor,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Transform.translate(
            offset: Offset(0, yOffset),
            child: Image.asset(
              pageData.imageAsset,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildBlurFadeOverlays({
    required int index,
    required Color backgroundColor,
  }) {
    // Page 1: bottom fade only
    if (index == 0) {
      return [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  backgroundColor.withValues(alpha: 0.0),
                  backgroundColor.withValues(alpha: 0.0),
                  backgroundColor.withValues(alpha: 0.9),
                  backgroundColor,
                ],
                stops: const [0.0, 0.55, 0.85, 1.0],
              ),
            ),
          ),
        ),
      ];
    }

    // Page 2 & 3: bottom fade only (keep full-width background visible)
    return [
      Positioned.fill(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                backgroundColor.withValues(alpha: 0.0),
                backgroundColor.withValues(alpha: 0.0),
                backgroundColor.withValues(alpha: 0.7),
                backgroundColor,
              ],
              stops: const [0.0, 0.55, 0.85, 1.0],
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildPageIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      width: isActive ? 24.w : 8.w,
      height: 8.h,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2E7D32) : Colors.grey[300],
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }

  String _getLocalizedString(AppLocalizations l10n, String key) {
    switch (key) {
      case 'onboardingTitle1':
        return l10n.onboardingTitle1;
      case 'onboardingDescription1':
        return l10n.onboardingDescription1;
      case 'onboardingTitle2':
        return l10n.onboardingTitle2;
      case 'onboardingDescription2':
        return l10n.onboardingDescription2;
      case 'onboardingTitle3':
        return l10n.onboardingTitle3;
      case 'onboardingDescription3':
        return l10n.onboardingDescription3;
      default:
        return '';
    }
  }
}

class OnboardingPageData {
  final String titleKey;
  final String descriptionKey;
  final String imageAsset;

  const OnboardingPageData({
    required this.titleKey,
    required this.descriptionKey,
    required this.imageAsset,
  });
}
