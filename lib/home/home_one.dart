import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/l10n/app_localizations.dart';
import 'dart:io';
import '../core/widgets/eco_toast.dart';
import '../core/services/habit_service.dart';
import '../core/services/profile_service.dart';

class HomeOne extends StatelessWidget {
  const HomeOne({super.key});

  String _localizeTag(AppLocalizations l10n, String tag) {
    switch (tag) {
      case 'Transport':
        return l10n.transport;
      case 'Waste':
        return l10n.waste;
      case 'High Impact':
        return l10n.highImpact;
      case 'Medium Impact':
        return l10n.mediumImpact;
      case 'Low Impact':
        return l10n.lowImpact;
      case 'Daily':
        return l10n.dailyTag;
      case 'Afforestation':
        return l10n.afforestationTag;
      case 'Planting':
        return l10n.plantingTag;
      default:
        // Fallback: keep the original tag if we don't have a localization key yet
        return tag;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40.h),
            // Header Section with User Info
            Container(
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
                  // User Info Row
                  Row(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 24.r,
                        backgroundColor: const Color(0xFF2E7D32),
                        child: CircleAvatar(
                          radius: 22.r,
                          backgroundColor: Colors.white,
                          child: ClipOval(child: _buildProfileImage()),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      // Greeting + Hi/Name on 2 lines (more readable)
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
                              '${AppLocalizations.of(context)!.hi} ${ProfileService.getUserName()} 👋',
                              maxLines: 1,
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
                      // ECO EXPLORER Badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: const Color(0xFF2E7D32),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/eco.svg',
                              width: 14.w,
                              height: 14.h,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF2E7D32),
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              AppLocalizations.of(context)!.ecoExplorer,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2E7D32),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Daily Eco Score Card
                  Consumer<HabitService>(
                    builder: (context, service, child) {
                      final dailyScore = service.dailyScore.clamp(
                        0,
                        100,
                      ); // Cap at 100
                      final maxDailyScore = 100; // Max score per day
                      final progress = (dailyScore / maxDailyScore).clamp(
                        0.0,
                        1.0,
                      );

                      // Determine next level based on total score
                      String nextLevel;
                      final l10n = AppLocalizations.of(context)!;
                      if (service.totalScore < 2000) {
                        nextLevel = l10n.ecoExplorerRank;
                      } else if (service.totalScore < 3000) {
                        nextLevel = l10n.ecoWarrior;
                      } else if (service.totalScore < 5000) {
                        nextLevel = l10n.natureGuardian;
                      } else {
                        nextLevel = l10n.ecoMaster;
                      }

                      return Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F8F5),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Column(
                          children: [
                            // Title Row
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
                            // Progress Bar
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
                            // Next Level Text
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                AppLocalizations.of(
                                  context,
                                )!.nextLevel(nextLevel),
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
            ),

            // Today's Eco Tasks Section
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.todaysEcoTasks,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // All tasks (habit-based + default)
                  Consumer<HabitService>(
                    builder: (context, service, child) {
                      final l10n = AppLocalizations.of(context)!;
                      final habitTasks = service.userHabits;
                      final defaultTasks = service.todayDefaultTasks;
                      final hasAnyTasks =
                          habitTasks.isNotEmpty || defaultTasks.isNotEmpty;

                      if (!hasAnyTasks) {
                        // Empty state
                        return _buildEmptyState(context);
                      }

                      return Column(
                        children: [
                          // Habit-based tasks from Habits page (no icons)
                          ...habitTasks.map((habit) {
                            final tags = [
                              habit['category'] as String,
                              habit['impact'] as String,
                            ];
                            final String title = habit['title'] as String;

                            return Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: _buildTaskCard(
                                context: context,
                                title: title,
                                tags: tags,
                                taskName: title,
                                showIcon: false,
                                onSkip: () {
                                  service.completeHabitTask(
                                    title,
                                    isDone: false,
                                  );
                                  EcoToast.show(
                                    context,
                                    message: AppLocalizations.of(
                                      context,
                                    )!.skippedYourStreakNeedsConsistency,
                                    isSuccess: false,
                                  );
                                },
                                onDone: () {
                                  service.completeHabitTask(
                                    title,
                                    isDone: true,
                                  );
                                  EcoToast.show(
                                    context,
                                    message: AppLocalizations.of(
                                      context,
                                    )!.taskDoneStreakStrong(title),
                                    isSuccess: true,
                                  );
                                },
                              ),
                            );
                          }),

                          // Default Echo tasks (with icons)
                          ...defaultTasks.map((task) {
                            final String id = task['id'] as String;
                            final String title = task['title'] as String;
                            final List<String> tags = (task['tags']
                                    as List<dynamic>)
                                .cast<String>()
                                .map((t) => _localizeTag(l10n, t))
                                .toList();
                            final IconData icon =
                                task['icon'] as IconData? ?? Icons.check;
                            final bool useSvg =
                                task['useSvg'] as bool? ?? false;
                            final String? svgAsset =
                                task['svgAsset'] as String?;
                            final String taskName =
                                task['taskName'] as String? ?? title;

                            // Localize default task titles based on id
                            String localizedTitle;
                            switch (id) {
                              case 'default_walk_bike_1':
                                localizedTitle = l10n.defaultWalkBikeTitle;
                                break;
                              case 'default_coffee_cup':
                                localizedTitle = l10n.defaultCoffeeCupTitle;
                                break;
                              case 'default_afforestation':
                                localizedTitle =
                                    l10n.defaultAfforestationTitle;
                                break;
                              default:
                                localizedTitle = title;
                            }

                            return Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: _buildTaskCard(
                                context: context,
                                icon: icon,
                                title: localizedTitle,
                                tags: tags,
                                useSvg: useSvg,
                                svgAsset: svgAsset,
                                taskName: taskName,
                                showIcon: true,
                                onSkip: () {
                                  service.completeDefaultTask(
                                    id,
                                    isDone: false,
                                  );
                                  EcoToast.show(
                                    context,
                                    message: AppLocalizations.of(
                                      context,
                                    )!.skippedYourStreakNeedsConsistency,
                                    isSuccess: false,
                                  );
                                },
                                onDone: () {
                                  service.completeDefaultTask(id, isDone: true);
                                  EcoToast.show(
                                    context,
                                    message: AppLocalizations.of(
                                      context,
                                    )!.taskDone(taskName),
                                    isSuccess: true,
                                  );
                                },
                              ),
                            );
                          }),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard({
    required BuildContext context,
    IconData? icon,
    required String title,
    required List<String> tags,
    bool useSvg = false,
    String? svgAsset,
    required String taskName,
    bool showIcon = true,
    VoidCallback? onSkip,
    VoidCallback? onDone,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icon Box (only show if showIcon is true)
              if (showIcon) ...[
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: useSvg && svgAsset != null
                      ? Center(
                          child: SvgPicture.asset(
                            svgAsset,
                            width: 20.w,
                            height: 20.h,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF2E7D32),
                              BlendMode.srcIn,
                            ),
                          ),
                        )
                      : Icon(icon, color: const Color(0xFF2E7D32), size: 20.sp),
                ),
                SizedBox(width: 10.w),
              ],
              // Task Description
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          // Tags Row
          Center(
            child: Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              alignment: WrapAlignment.center,
              children: tags.map((tag) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(fontSize: 12.sp, color: Colors.black54),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 16.h),
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onSkip,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black54,
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.skip,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: onDone,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    elevation: 0,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.done,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Text(
          AppLocalizations.of(context)!.noMoreTasksForTheDay,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    final imagePath = ProfileService.getProfileImagePath();
    if (imagePath != null && File(imagePath).existsSync()) {
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        width: 44.w,
        height: 44.h,
      );
    }
    return Image.asset(
      'assets/profile.png',
      fit: BoxFit.cover,
      width: 44.w,
      height: 44.h,
    );
  }
}
