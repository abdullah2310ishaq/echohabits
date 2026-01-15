import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/l10n/app_localizations.dart';
import '../core/services/habit_service.dart';
import '../core/services/profile_service.dart';

class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});

  Widget _buildProfileImage({
    required bool isCurrentUser,
    required String avatar,
    required ProfileService profileService,
  }) {
    if (isCurrentUser) {
      final imagePath = profileService.getProfileImagePath();
      if (imagePath != null && File(imagePath).existsSync()) {
        return Image.file(
          File(imagePath),
          fit: BoxFit.cover,
        );
      }
    }
    return Image.asset(
      avatar,
      fit: BoxFit.cover,
    );
  }

  String _getRankTitle(BuildContext context, int score) {
    final l10n = AppLocalizations.of(context)!;
    if (score < 2000) {
      return l10n.greenStarter;
    } else if (score < 3000) {
      return l10n.ecoExplorerRank;
    } else if (score < 5000) {
      return l10n.ecoWarrior;
    } else if (score < 10000) {
      return l10n.natureGuardian;
    } else {
      return l10n.ecoMaster;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<HabitService, ProfileService>(
      builder: (context, service, profileService, child) {
        final currentUserScore = service.totalScore;
        final currentUserRankTitle = _getRankTitle(context, currentUserScore);

        // Sample leaderboard data (dummy users)
        final List<Map<String, dynamic>> rankings = [
          {
            'name': 'Sarah Chen',
            'rankTitle': _getRankTitle(context, 2450),
            'score': 2450,
            'isCurrentUser': false,
            'avatar': 'assets/profile.png',
          },
          {
            'name': 'Mikes Ross',
            'rankTitle': _getRankTitle(context, 2320),
            'score': 2320,
            'isCurrentUser': false,
            'avatar': 'assets/profile.png',
          },
          {
            'name': profileService.getUserName(),
            'rankTitle': currentUserRankTitle,
            'score': currentUserScore,
            'isCurrentUser': true,
            'avatar': 'assets/profile.png',
          },
          {
            'name': 'Alex T',
            'rankTitle': _getRankTitle(context, 1950),
            'score': 1950,
            'isCurrentUser': false,
            'avatar': 'assets/profile.png',
          },
          {
            'name': 'Emma Wilson',
            'rankTitle': _getRankTitle(context, 1800),
            'score': 1800,
            'isCurrentUser': false,
            'avatar': 'assets/profile.png',
          },
        ];

        // Sort by score (descending)
        rankings.sort(
          (a, b) => (b['score'] as int).compareTo(a['score'] as int),
        );

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        AppLocalizations.of(context)!.leaderboard,
                        style: TextStyle(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2E7D32),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      // Subtitle
                      Text(
                        AppLocalizations.of(context)!.yourEcoHabitsYourRank,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      // Motivational Banner
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Row(
                          children: [
                            // Leaderboard Icon
                            Container(
                              width: 40.w,
                              height: 40.h,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/leader.png',
                                  width: 32.w,
                                  height: 32.h,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            // Motivational Text
                            Expanded(
                              child: Text(
                                AppLocalizations.of(
                                  context,
                                )!.betterHabitsLeadToBetterBadges,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Rankings Section
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Title
                      Text(
                        AppLocalizations.of(context)!.currentEcoHabitRankings,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      // Rankings List
                      ...rankings.map(
                        (user) => Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: _buildRankingCard(
                            context: context,
                            name: user['name'] as String,
                            rankTitle: user['rankTitle'] as String,
                            score: user['score'] as int,
                            isCurrentUser: user['isCurrentUser'] as bool,
                            avatar: user['avatar'] as String,
                            profileService: profileService,
                          ),
                        ),
                      ),
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

  Widget _buildRankingCard({
    required BuildContext context,
    required String name,
    required String rankTitle,
    required int score,
    required bool isCurrentUser,
    required String avatar,
    required ProfileService profileService,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: isCurrentUser
            ? Border.all(color: const Color(0xFF2E7D32), width: 2)
            : null,
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
          // Avatar
          CircleAvatar(
            radius: 24.r,
            backgroundColor: Colors.grey[200],
            child: ClipOval(
              child: SizedBox(
                width: 48.w,
                height: 48.h,
                child: _buildProfileImage(
                  isCurrentUser: isCurrentUser,
                  avatar: avatar,
                  profileService: profileService,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Name and Rank Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCurrentUser
                      ? '$name (${AppLocalizations.of(context)!.you})'
                      : name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  rankTitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          // Score
          Text(
            score.toString(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2E7D32),
            ),
          ),
        ],
      ),
    );
  }
}
