import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/l10n/app_localizations.dart';
import 'dart:io';
import '../history/history.dart';
import '../settings/settings.dart';
import '../core/services/profile_service.dart';
import '../core/services/habit_service.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitService>(
      builder: (context, habitService, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40.h),
                // Header Section
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
                      // Top Row: Avatar, Name, Settings
                      Row(
                        children: [
                          // Avatar with green border
                          CircleAvatar(
                            radius: 28.r,
                            backgroundColor: const Color(0xFF2E7D32),
                            child: CircleAvatar(
                              radius: 26.r,
                              backgroundColor: Colors.white,
                              child: ClipOval(child: _buildProfileImage()),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          // Name and Subtitle
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ProfileService.getUserName(),
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2E7D32),
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.makingTheWorldGreener,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Settings Icon
                          IconButton(
                            icon: Icon(
                              Icons.settings,
                              color: Colors.black87,
                              size: 20.sp,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const SettingsScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      // ECO EXPLORER Badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(18.r),
                          border: Border.all(
                            color: const Color(0xFF2E7D32),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.emoji_events,
                              color: Colors.amber,
                              size: 16.sp,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              AppLocalizations.of(context)!.ecoExplorer,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2E7D32),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Content
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Green Score Chart Card
                      _buildGreenScoreCard(context, habitService),
                      SizedBox(height: 12.h),

                      // Quick Stats Cards
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              svgAsset: 'assets/eco.svg',
                              iconColor: Colors.orange,
                              value: habitService.averageActionsPerDay
                                  .toStringAsFixed(1),
                              label: AppLocalizations.of(
                                context,
                              )!.avgActionsPerDay,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: _buildStatCard(
                              svgAsset: 'assets/flame.svg',
                              iconColor: Colors.orange,
                              value: habitService.currentStreak.toString(),
                              label: AppLocalizations.of(context)!.dayStreak,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // Badges Section
                      Text(
                        AppLocalizations.of(context)!.badges,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      SizedBox(
                        height: 90.h,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildBadgeCard(
                              imageAsset: 'assets/firststep.png',
                              label: AppLocalizations.of(context)!.firstStep,
                            ),
                            SizedBox(width: 10.w),
                            _buildBadgeCard(
                              icon: Icons.directions_bike,
                              iconColor: Colors.blue,
                              label: AppLocalizations.of(context)!.cyclist,
                            ),
                            SizedBox(width: 10.w),
                            _buildBadgeCard(
                              icon: Icons.water_drop,
                              iconColor: Colors.blue,
                              label: AppLocalizations.of(context)!.waterSaver,
                            ),
                            SizedBox(width: 10.w),
                            _buildBadgeCard(
                              icon: Icons.bolt,
                              iconColor: Colors.amber,
                              label: AppLocalizations.of(context)!.energyPr,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // History Section
                      Text(
                        AppLocalizations.of(context)!.history,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const History(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF2E7D32),
                            side: const BorderSide(
                              color: Color(0xFF2E7D32),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.viewHistory,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGreenScoreCard(BuildContext context, HabitService habitService) {
    // Get real weekly score data
    final weeklyScores = habitService.weeklyScoreData;

    // Create spots for the chart (last 7 days)
    final List<FlSpot> spots = [];
    for (int i = 0; i < weeklyScores.length; i++) {
      spots.add(FlSpot(i.toDouble(), weeklyScores[i]));
    }

    // If no data, show zeros
    if (spots.isEmpty) {
      for (int i = 0; i < 7; i++) {
        spots.add(FlSpot(i.toDouble(), 0));
      }
    }

    return Container(
      padding: EdgeInsets.all(16.w),
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
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.greenScore,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                habitService.totalScore.toString(),
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Chart
          SizedBox(
            height: 140.h,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        // Get day names for last 7 days
                        final now = DateTime.now();
                        final l10n = AppLocalizations.of(context)!;
                        final dayNames = [
                          l10n.monday,
                          l10n.tuesday,
                          l10n.wednesday,
                          l10n.thursday,
                          l10n.friday,
                          l10n.saturday,
                          l10n.sunday,
                        ];
                        final dayIndex =
                            (now.weekday - 1 + value.toInt() - 6) % 7;
                        if (value.toInt() >= 0 && value.toInt() < 7) {
                          return Padding(
                            padding: EdgeInsets.only(top: 6.h),
                            child: Text(
                              dayNames[dayIndex],
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.black54,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 26.h,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minY: 0,
                maxY: weeklyScores.isEmpty
                    ? 10
                    : (weeklyScores.reduce((a, b) => a > b ? a : b) * 1.2)
                          .clamp(1.0, double.infinity),
                lineBarsData: [
                  // Real data line
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: const Color(0xFF2E7D32),
                    barWidth: 2.5,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        // Highlight today (last day)
                        if (index == spots.length - 1) {
                          return FlDotCirclePainter(
                            radius: 4.r,
                            color: Colors.white,
                            strokeWidth: 2.r,
                            strokeColor: const Color(0xFF2E7D32),
                          );
                        }
                        return FlDotCirclePainter(
                          radius: 2.5.r,
                          color: const Color(0xFF2E7D32),
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF2E7D32).withOpacity(0.2),
                    ),
                  ),
                ],
                minX: 0,
                maxX: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String svgAsset,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Container(
      height: 82.h, // Fixed height for both cards
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon on the left
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                svgAsset,
                width: 20.w,
                height: 20.h,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          // Value and label on the right
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeCard({
    IconData? icon,
    String? svgAsset,
    String? imageAsset,
    Color? iconColor,
    required String label,
  }) {
    return Container(
      width: 74.w,
      height: 60.h,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imageAsset != null)
            Image.asset(
              imageAsset,
              width: 28.w,
              height: 28.h,
              fit: BoxFit.contain,
            )
          else if (svgAsset != null)
            SvgPicture.asset(
              svgAsset,
              width: 28.w,
              height: 28.h,
              colorFilter: iconColor != null
                  ? ColorFilter.mode(iconColor, BlendMode.srcIn)
                  : null,
            )
          else if (icon != null && iconColor != null)
            Icon(icon, color: iconColor, size: 28.sp),
          SizedBox(height: 6.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    final imagePath = ProfileService.getProfileImagePath();
    if (imagePath != null && File(imagePath).existsSync()) {
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        width: 52.w,
        height: 52.h,
      );
    }
    return Image.asset(
      'assets/profile.png',
      fit: BoxFit.cover,
      width: 52.w,
      height: 52.h,
    );
  }
}
