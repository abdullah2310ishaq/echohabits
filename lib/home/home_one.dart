import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../core/widgets/eco_toast.dart';
import '../core/services/habit_service.dart';
import '../core/services/profile_service.dart';

class HomeOne extends StatelessWidget {
  const HomeOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 25),
            // Header Section with User Info
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
                  // User Info Row
                  Row(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color(0xFF2E7D32),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.white,
                          child: ClipOval(child: _buildProfileImage()),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Greeting Text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${ProfileService.getGreeting()},',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Hi ${ProfileService.getUserName()} 👋',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // ECO EXPLORER Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(20),
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
                              width: 16,
                              height: 16,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF2E7D32),
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'ECO EXPLORER',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Daily Eco Score Card
                  Consumer<HabitService>(
                    builder: (context, service, child) {
                      final dailyScore = service.dailyScore;
                      final maxDailyScore = 100; // Max score per day
                      final progress = (dailyScore / maxDailyScore).clamp(
                        0.0,
                        1.0,
                      );

                      // Determine next level based on total score
                      String nextLevel = 'Eco Warrior';
                      if (service.totalScore < 2000) {
                        nextLevel = 'Eco Explorer';
                      } else if (service.totalScore < 3000) {
                        nextLevel = 'Eco Warrior';
                      } else if (service.totalScore < 5000) {
                        nextLevel = 'Nature Guardian';
                      } else {
                        nextLevel = 'Eco Master';
                      }

                      return Container(
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F8F5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            // Title Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Daily Eco Score',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: dailyScore.toString(),
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2E7D32),
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' / $maxDailyScore',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Progress Bar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 10,
                                backgroundColor: Colors.grey[300],
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF2E7D32),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Next Level Text
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Next Level: $nextLevel',
                                style: const TextStyle(
                                  fontSize: 14,
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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Today's Eco Tasks",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // All tasks (habit-based + default)
                  Consumer<HabitService>(
                    builder: (context, service, child) {
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
                              padding: const EdgeInsets.only(bottom: 12),
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
                                    message:
                                        'Skipped! Your streak needs consistency',
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
                                    message: '$title Done! Streak Strong',
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
                            final List<String> tags =
                                (task['tags'] as List<dynamic>)
                                    .cast<String>()
                                    .toList();
                            final IconData icon =
                                task['icon'] as IconData? ?? Icons.check;
                            final bool useSvg =
                                task['useSvg'] as bool? ?? false;
                            final String? svgAsset =
                                task['svgAsset'] as String?;
                            final String taskName =
                                task['taskName'] as String? ?? title;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildTaskCard(
                                context: context,
                                icon: icon,
                                title: title,
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
                                    message:
                                        'Skipped! Your streak needs consistency',
                                    isSuccess: false,
                                  );
                                },
                                onDone: () {
                                  service.completeDefaultTask(id, isDone: true);
                                  EcoToast.show(
                                    context,
                                    message: '$taskName Done',
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
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
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
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: useSvg && svgAsset != null
                      ? Center(
                          child: SvgPicture.asset(
                            svgAsset,
                            width: 24,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF2E7D32),
                              BlendMode.srcIn,
                            ),
                          ),
                        )
                      : Icon(icon, color: const Color(0xFF2E7D32), size: 24),
                ),
                const SizedBox(width: 12),
              ],
              // Task Description
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Tags Row
          Center(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 22),
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
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Skip',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 19),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onDone,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 19),
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
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: const Text(
          'No more tasks for the day',
          style: TextStyle(
            fontSize: 18,
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
        width: 56,
        height: 56,
      );
    }
    return Image.asset(
      'assets/profile.png',
      fit: BoxFit.cover,
      width: 56,
      height: 56,
    );
  }
}
