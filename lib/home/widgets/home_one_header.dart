import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// NOTE: Ads are temporarily disabled.
//
// Original ad-related import preserved for later re-enable:
// import 'package:habit_tracker/core/ads/app_open_ad_manager.dart';
//
// NOTE: "pro" Lottie json is removed/disabled for now.
// Original import preserved for later re-enable:
// import 'package:lottie/lottie.dart';
import 'package:habit_tracker/core/services/habit_service.dart';
import 'package:habit_tracker/core/services/profile_service.dart';
import 'package:habit_tracker/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class HomeOneHeader extends StatelessWidget {
  const HomeOneHeader({
    super.key,
    required this.profileService,
    required this.buildProfileImage,
  });

  final ProfileService profileService;
  final Widget Function(ProfileService profileService) buildProfileImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor: const Color(0xFF2E7D32),
                child: CircleAvatar(
                  radius: 22.r,
                  backgroundColor: Colors.white,
                  child: ClipOval(child: buildProfileImage(profileService)),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${ProfileService.getGreetingWithContext(context)},',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '${AppLocalizations.of(context)!.hi} ${profileService.getUserName()} 👋',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 19.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              // NOTE: "PRO" entry temporarily disabled.
              //
              // Original paywall entry preserved for later re-enable:
              /*
              import 'package:habit_tracker/paywall.dart';
              
              Consumer<HabitService>(
                builder: (context, habitService, child) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(16.r),
                    onTap: () {
                      AppOpenAdManager.suppressNextResumeOnce();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const Paywall()),
                      );
                    },
                    child: Container(
                      width: 72.w,
                      height: 65.h,
                      alignment: Alignment.center,
                      child: Lottie.asset(
                        'assets/pro_animation.json',
                        repeat: true,
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              ),
              */
            ],
          ),
          SizedBox(height: 16.h),
          Consumer<HabitService>(
            builder: (context, service, child) {
              final dailyScore = service.dailyScore.clamp(0, 100);
              const maxDailyScore = 100;
              final progress = (dailyScore / maxDailyScore).clamp(0.0, 1.0);

              String nextLevel;
              final l10n = AppLocalizations.of(context)!;
              if (service.totalScore < 1000) {
                nextLevel = l10n.ecoBuilder;
              } else if (service.totalScore < 2500) {
                nextLevel = l10n.ecoChampion;
              } else if (service.totalScore < 5000) {
                nextLevel = l10n.ecoWarrior;
              } else if (service.totalScore < 8000) {
                nextLevel = l10n.ecoGuardian;
              } else if (service.totalScore < 12000) {
                nextLevel = l10n.planetHero;
              } else {
                nextLevel = l10n.planetHero;
              }

              return Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F8F5),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.dailyEcoScore,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: dailyScore.toString(),
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2E7D32),
                                ),
                              ),
                              TextSpan(
                                text: ' / $maxDailyScore',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8.h,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF2E7D32),
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        AppLocalizations.of(context)!.nextLevel(nextLevel),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
