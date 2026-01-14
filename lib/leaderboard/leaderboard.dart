import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/l10n/app_localizations.dart';
import '../core/services/habit_service.dart';
import '../core/services/profile_service.dart';

class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});

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
    return Consumer<HabitService>(
      builder: (context, service, child) {
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
            'name': ProfileService.getUserName(),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        AppLocalizations.of(context)!.leaderboard,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Subtitle
                      Text(
                        AppLocalizations.of(context)!.yourEcoHabitsYourRank,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Motivational Banner
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            // Leaderboard Icon
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              child: Center(
                                child: Image.asset(
                                  'assets/leader.png',
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Motivational Text
                            Expanded(
                              child: Text(
                                AppLocalizations.of(
                                  context,
                                )!.betterHabitsLeadToBetterBadges,
                                style: const TextStyle(
                                  fontSize: 16,
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
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Title
                      Text(
                        AppLocalizations.of(context)!.currentEcoHabitRankings,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Rankings List
                      ...rankings.map(
                        (user) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildRankingCard(
                            context: context,
                            name: user['name'] as String,
                            rankTitle: user['rankTitle'] as String,
                            score: user['score'] as int,
                            isCurrentUser: user['isCurrentUser'] as bool,
                            avatar: user['avatar'] as String,
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
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isCurrentUser
            ? Border.all(color: const Color(0xFF2E7D32), width: 2)
            : null,
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
          // Avatar
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.grey[200],
            child: ClipOval(
              child: Image.asset(
                avatar,
                fit: BoxFit.cover,
                width: 56,
                height: 56,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Name and Rank Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCurrentUser
                      ? '${name} (${AppLocalizations.of(context)!.you})'
                      : name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  rankTitle,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
          // Score
          Text(
            score.toString(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
        ],
      ),
    );
  }
}
