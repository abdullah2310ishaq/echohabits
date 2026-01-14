import 'package:flutter/material.dart';
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
                const SizedBox(height: 25),
                // Header Section
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Top Row: Avatar, Name, Settings
                      Row(
                        children: [
                          // Avatar with green border
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: const Color(0xFF2E7D32),
                            child: CircleAvatar(
                              radius: 33,
                              backgroundColor: Colors.white,
                              child: ClipOval(child: _buildProfileImage()),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Name and Subtitle
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ProfileService.getUserName(),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2E7D32),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.makingTheWorldGreener,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Settings Icon
                          IconButton(
                            icon: const Icon(
                              Icons.settings,
                              color: Colors.black87,
                              size: 24,
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
                      const SizedBox(height: 16),
                      // ECO EXPLORER Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xFF2E7D32),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.emoji_events,
                              color: Colors.amber,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.ecoExplorer,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
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
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Green Score Chart Card
                      _buildGreenScoreCard(context, habitService),
                      const SizedBox(height: 16),

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
                          const SizedBox(width: 12),
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
                      const SizedBox(height: 24),

                      // Badges Section
                      Text(
                        AppLocalizations.of(context)!.badges,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildBadgeCard(
                              imageAsset: 'assets/firststep.png',
                              label: AppLocalizations.of(context)!.firstStep,
                            ),
                            const SizedBox(width: 12),
                            _buildBadgeCard(
                              icon: Icons.directions_bike,
                              iconColor: Colors.blue,
                              label: AppLocalizations.of(context)!.cyclist,
                            ),
                            const SizedBox(width: 12),
                            _buildBadgeCard(
                              icon: Icons.water_drop,
                              iconColor: Colors.blue,
                              label: AppLocalizations.of(context)!.waterSaver,
                            ),
                            const SizedBox(width: 12),
                            _buildBadgeCard(
                              icon: Icons.bolt,
                              iconColor: Colors.amber,
                              label: AppLocalizations.of(context)!.energyPr,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // History Section
                      Text(
                        AppLocalizations.of(context)!.history,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
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
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.viewHistory,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                habitService.totalScore.toString(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Chart
          SizedBox(
            height: 150,
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
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              dayNames[dayIndex],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 30,
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
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        // Highlight today (last day)
                        if (index == spots.length - 1) {
                          return FlDotCirclePainter(
                            radius: 5,
                            color: Colors.white,
                            strokeWidth: 3,
                            strokeColor: const Color(0xFF2E7D32),
                          );
                        }
                        return FlDotCirclePainter(
                          radius: 3,
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
      height: 90, // Fixed height for both cards
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon on the left
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                svgAsset,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Value and label on the right
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
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
      width: 80,
      height: 60,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imageAsset != null)
            Image.asset(imageAsset, width: 32, height: 32, fit: BoxFit.contain)
          else if (svgAsset != null)
            SvgPicture.asset(
              svgAsset,
              width: 32,
              height: 32,
              colorFilter: iconColor != null
                  ? ColorFilter.mode(iconColor, BlendMode.srcIn)
                  : null,
            )
          else if (icon != null && iconColor != null)
            Icon(icon, color: iconColor, size: 32),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
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
        width: 66,
        height: 66,
      );
    }
    return Image.asset(
      'assets/profile.png',
      fit: BoxFit.cover,
      width: 66,
      height: 66,
    );
  }
}
