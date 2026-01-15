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
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
            // Skip button
            Padding(
              padding: EdgeInsets.only(top: 16.h, right: 20.w),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _skipOnboarding,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[600],
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                  ),
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

            // PageView for onboarding content
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

            // Bottom section with dots and button
            _buildBottomSection(context),
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Top illustration area with onboarding images
          Expanded(
            flex: 2,
            child: Center(
              child: SizedBox(
                width: 260.w,
                height: 260.h,
                child: Image.asset(pageData.imageAsset, fit: BoxFit.contain),
              ),
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pageData = _pages[_currentPage];
    final title = _getLocalizedString(l10n, pageData.titleKey);
    final description = _getLocalizedString(l10n, pageData.descriptionKey);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r),
          topRight: Radius.circular(32.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, -2.h),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title & description as part of one bottom sheet
          Align(
            alignment: Alignment.center,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.2,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Align(
            alignment: Alignment.center,
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: 28.h),

          // Page indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pages.length,
              (index) => _buildPageIndicator(index == _currentPage),
            ),
          ),
          SizedBox(height: 24.h),

          // Next button
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                minimumSize: Size(120.w, 48.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Text(
                _currentPage == _pages.length - 1
                    ? l10n.continueButton
                    : l10n.next,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
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
