import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/core/ads/app_open_ad_manager.dart';
import 'package:habit_tracker/core/theme/app_colors.dart';
import 'package:habit_tracker/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/core/billing/billing_service.dart';

class Paywall extends StatefulWidget {
  const Paywall({super.key});

  @override
  State<Paywall> createState() => _PaywallState();
}

class _PaywallState extends State<Paywall> {
  int _selectedPlanIndex = 1; // 0 = Weekly, 1 = Lifetime
  bool _didPrecache = false;
  bool _showCloseButton = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _showCloseButton = true);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didPrecache) return;
    _didPrecache = true;

    // Warm up heavy assets so opening this screen doesn't stutter.
    precacheImage(const AssetImage('assets/paywall.png'), context);

    // Precache SVGs (first decode can be expensive on some devices).
    // flutter_svg 2.x uses the `svg` cache + asset loaders.
    Future.microtask(() async {
      await _warmUpSvg('assets/svgonee.svg');
      await _warmUpSvg('assets/svgtwo.svg');
      await _warmUpSvg('assets/svgthree.svg');
    });
  }

  Future<void> _warmUpSvg(String assetPath) async {
    final loader = SvgAssetLoader(assetPath);
    await svg.cache.putIfAbsent(
      loader.cacheKey(null),
      () => loader.loadBytes(null),
    );
  }

  @override
  Widget build(BuildContext context) {
    final billing = context.watch<BillingService>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with PNG Leaf
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/paywall.png',
                    width: 120.w,
                    height: 120.w,
                    fit: BoxFit.contain,
                  ),
                  IgnorePointer(
                    ignoring: !_showCloseButton,
                    child: AnimatedOpacity(
                      opacity: _showCloseButton ? 1 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: Icon(
                          Icons.close,
                          size: 28.w,
                          color: AppColors.textPrimary,
                        ),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(
                          minWidth: 40.w,
                          minHeight: 40.w,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Center(
                child: Text(
                  l10n.paywallEcoHabitTitle,
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              SizedBox(height: 20.h),
              // Feature list using SVGs
              _FeatureTile(
                svgAsset: 'assets/svgonee.svg',
                text: l10n.paywallUnlimitedHabitTracking,
              ),
              SizedBox(height: 12.h),
              _FeatureTile(
                svgAsset: 'assets/svgtwo.svg',
                text: l10n.paywallLeaderboardAccess,
              ),
              SizedBox(height: 12.h),
              _FeatureTile(
                svgAsset: 'assets/svgthree.svg',
                text: l10n.paywallAdvancedProgressAnalytics,
              ),
              SizedBox(height: 25.h),
              // Pricing Cards
              _PlanCard(
                title: l10n.paywallWeeklyPlan,
                subtitle: billing.weeklyPriceLabel(),
                isSelected: _selectedPlanIndex == 0,
                isBestValue: false,
                onTap: () => setState(() => _selectedPlanIndex = 0),
              ),
              SizedBox(height: 15.h),
              _PlanCard(
                title: l10n.paywallLifetimeAccess,
                subtitle: billing.lifetimePriceLabel(),
                isSelected: _selectedPlanIndex == 1,
                isBestValue: true,
                onTap: () => setState(() => _selectedPlanIndex = 1),
              ),
              SizedBox(height: 30.h),
              // Main Action Button
              SizedBox(
                width: double.infinity,
                height: 65.h,
                child: ElevatedButton(
                  onPressed: billing.purchaseInProgress
                      ? null
                      : () async {
                          AppOpenAdManager.suppressNextResumeOnce();
                          final isWeekly = _selectedPlanIndex == 0;
                          await billing.buySelected(weekly: isWeekly);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: AppColors.textOnDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: billing.purchaseInProgress
                      ? SizedBox(
                          width: 22.w,
                          height: 22.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5.w,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          l10n.paywallGoPremium,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 10.h),
              if (billing.errorMessage != null)
                Padding(
                  padding: EdgeInsets.only(top: 6.h),
                  child: Text(
                    billing.errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              TextButton(
                onPressed: billing.purchaseInProgress
                    ? null
                    : () async {
                        AppOpenAdManager.suppressNextResumeOnce();
                        await billing.restorePurchases();
                      },
                child: Text(
                  l10n.paywallRestorePurchases,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Extra space for very small screens / gesture bar.
              SizedBox(height: 14.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({required this.svgAsset, required this.text});
  final String svgAsset;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(6.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: const BoxDecoration(
              color: AppColors.lightGreenTint,
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(10.w),
            child: SvgPicture.asset(
              svgAsset,
              colorFilter: const ColorFilter.mode(
                AppColors.primaryGreen,
                BlendMode.srcIn,
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // ✅ FIX HERE
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.isBestValue,
    required this.onTap,
  });

  final String title, subtitle;
  final bool isSelected, isBestValue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = isSelected;
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.deepGreen : AppColors.surface,
              borderRadius: BorderRadius.circular(32.r),
              border: Border.all(
                color: !isDark ? Colors.transparent : Colors.transparent,
                width: 2.w,
              ),
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 10.r,
                    offset: Offset(0, 4.h),
                  ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.textOnDark
                            : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark
                            ? Colors.white70
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                _buildRadioDot(),
              ],
            ),
          ),
          if (isBestValue)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12.r),
                    topRight: Radius.circular(16.r),
                  ),
                ),
                child: Text(
                  l10n.paywallBestValue,
                  style: TextStyle(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRadioDot() {
    final isDark = isSelected;
    final color = isDark
        ? Colors.white
        : AppColors.textSecondary.withValues(alpha: 0.35);
    return Container(
      width: 22.w,
      height: 22.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2.w),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 10.w,
                height: 10.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            )
          : null,
    );
  }
}
