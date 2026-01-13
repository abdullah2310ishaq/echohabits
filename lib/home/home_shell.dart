import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
            padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  label: 'Home',
                  index: 0,
                  svgAsset: 'assets/home.svg',
                ),
                _buildNavItem(icon: Icons.list, label: 'Habits', index: 1),
                _buildNavItem(
                  label: 'Leaderboard',
                  index: 2,
                  svgAsset: 'assets/leader.svg',
                ),
                _buildNavItem(
                  label: 'Profile',
                  index: 3,
                  svgAsset: 'assets/profile.svg',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    IconData? icon,
    String? svgAsset,
    required String label,
    required int index,
  }) {
    final isActive = _currentIndex == index;
    final iconSize = index == 0 ? 24.0 : 20.0;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (svgAsset != null)
            SvgPicture.asset(
              svgAsset,
              width: iconSize,
              height: iconSize,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            )
          else if (icon != null)
            Icon(icon, color: Colors.white, size: iconSize),
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
