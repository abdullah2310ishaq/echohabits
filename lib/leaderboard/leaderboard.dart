import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample leaderboard data
    final List<Map<String, dynamic>> rankings = [
      {
        'name': 'Sarah Chen',
        'rankTitle': 'Eco Warrior',
        'score': 2450,
        'isCurrentUser': false,
        'avatar': 'assets/profile.png',
      },
      {
        'name': 'Mikes Ross',
        'rankTitle': 'Nature Guardian',
        'score': 2320,
        'isCurrentUser': false,
        'avatar': 'assets/profile.png',
      },
      {
        'name': 'Liza',
        'rankTitle': 'Eco Explorer',
        'score': 2100,
        'isCurrentUser': true,
        'avatar': 'assets/profile.png',
      },
      {
        'name': 'Alex T',
        'rankTitle': 'Green Starter',
        'score': 1950,
        'isCurrentUser': false,
        'avatar': 'assets/profile.png',
      },
      {
        'name': 'Emma Wilson',
        'rankTitle': 'Green Starter',
        'score': 1800,
        'isCurrentUser': false,
        'avatar': 'assets/profile.png',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            // Header Section
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F8F5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    'Leaderboard',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Subtitle
                  const Text(
                    'Your eco habits, your rank',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
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
                        const Expanded(
                          child: Text(
                            'Better habits lead to better badges and greater progress.',
                            style: TextStyle(
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
                  const Text(
                    'Current eco habit rankings',
                    style: TextStyle(
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
  }

  Widget _buildRankingCard({
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
                  isCurrentUser ? '$name (You)' : name,
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
