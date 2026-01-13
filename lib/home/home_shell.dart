import 'package:flutter/material.dart';
import 'home_one.dart';
import '../habits/habits_one.dart';
import '../leaderboard/leaderboard.dart';
import '../profile/profile.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeOne(),
    const HabitsOne(),
    const Leaderboard(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2E7D32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(icon: Icons.home, label: 'Home', index: 0),
                _buildNavItem(icon: Icons.list, label: 'Habits', index: 1),
                _buildNavItem(
                  icon: Icons.emoji_events,
                  label: 'Leaderboard',
                  index: 2,
                ),
                _buildNavItem(icon: Icons.person, label: 'Profile', index: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          const SizedBox(height: 4),
          if (isActive)
            Container(
              width: 20,
              height: 2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(1),
              ),
            )
          else
            const SizedBox(height: 2),
        ],
      ),
    );
  }
}
