import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fl_chart/fl_chart.dart';
import '../history/history.dart';
import '../settings/settings.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
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
                          child: ClipOval(
                            child: Image.asset(
                              'assets/profile.png',
                              fit: BoxFit.cover,
                              width: 66,
                              height: 66,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Name and Subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Liza',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Making the world greener',
                              style: TextStyle(
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
                        const Text(
                          'ECO EXPLORER',
                          style: TextStyle(
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
                  _buildGreenScoreCard(),
                  const SizedBox(height: 16),

                  // Quick Stats Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          svgAsset: 'assets/eco.svg',
                          iconColor: Colors.orange,
                          value: '4.2',
                          label: 'Avg Actions/Day',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          svgAsset: 'assets/flame.svg',
                          iconColor: Colors.orange,
                          value: '18',
                          label: 'Day Streak',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Badges Section
                  const Text(
                    'Badges',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildBadgeCard(
                          imageAsset: 'assets/firststep.png',
                          label: 'First Step',
                        ),
                        const SizedBox(width: 12),
                        _buildBadgeCard(
                          icon: Icons.directions_bike,
                          iconColor: Colors.blue,
                          label: 'Cyclist',
                        ),
                        const SizedBox(width: 12),
                        _buildBadgeCard(
                          icon: Icons.water_drop,
                          iconColor: Colors.blue,
                          label: 'Water Saver',
                        ),
                        const SizedBox(width: 12),
                        _buildBadgeCard(
                          icon: Icons.bolt,
                          iconColor: Colors.amber,
                          label: 'Energy Pr',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // History Section
                  const Text(
                    'History',
                    style: TextStyle(
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
                      child: const Text(
                        'View History',
                        style: TextStyle(
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
  }

  Widget _buildGreenScoreCard() {
    // Sample data for the chart (Mon-Sun)
    final List<FlSpot> spots = [
      const FlSpot(0, 1.5), // Mon
      const FlSpot(1, 2.0), // Tue
      const FlSpot(2, 2.5), // Wed (current day)
      const FlSpot(3, 2.8), // Thu (projected)
      const FlSpot(4, 3.0), // Fri (projected)
      const FlSpot(5, 3.2), // Sat (projected)
      const FlSpot(6, 3.5), // Sun (projected)
    ];

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
              const Text(
                'Green Score',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Text(
                '2100',
                style: TextStyle(
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
                        const days = [
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                          'Sun',
                        ];
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              days[value.toInt()],
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
                lineBarsData: [
                  // Past data (solid line with area)
                  LineChartBarData(
                    spots: spots.sublist(0, 3), // Mon-Wed
                    isCurved: true,
                    color: const Color(0xFF2E7D32),
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF2E7D32).withOpacity(0.2),
                    ),
                  ),
                  // Future data (dashed line)
                  LineChartBarData(
                    spots: spots.sublist(2), // Wed-Sun
                    isCurved: true,
                    color: const Color(0xFF2E7D32),
                    barWidth: 3,
                    dashArray: [5, 5],
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        if (index == 0) {
                          // Highlight current day (Wed)
                          return FlDotCirclePainter(
                            radius: 5,
                            color: Colors.white,
                            strokeWidth: 3,
                            strokeColor: const Color(0xFF2E7D32),
                          );
                        }
                        return FlDotCirclePainter(
                          radius: 0,
                          color: Colors.transparent,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 4,
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
      padding: const EdgeInsets.all(16),
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
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                svgAsset,
                width: 28,
                height: 28,
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
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
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
      width: 100,
      padding: const EdgeInsets.all(16),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imageAsset != null)
            Image.asset(imageAsset, width: 40, height: 40, fit: BoxFit.contain)
          else if (svgAsset != null)
            SvgPicture.asset(
              svgAsset,
              width: 40,
              height: 40,
              colorFilter: iconColor != null
                  ? ColorFilter.mode(iconColor, BlendMode.srcIn)
                  : null,
            )
          else if (icon != null && iconColor != null)
            Icon(icon, color: iconColor, size: 40),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
