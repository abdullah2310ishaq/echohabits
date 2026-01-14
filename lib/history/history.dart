import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../core/services/habit_service.dart';
import '../l10n/app_localizations.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  String _selectedFilter = 'Weekly';

  @override
  Widget build(BuildContext context) {
    final habitService = Provider.of<HabitService>(context);
    // Filter to show only completed tasks (status == 'done')
    final history = habitService.history
        .where((item) => item['status'] == 'done')
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87, size: 22.sp),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppLocalizations.of(context)!.history,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            // Filter Bar
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  _buildFilterButton(context, 'Weekly'),
                  SizedBox(width: 10.w),
                  _buildFilterButton(context, 'Monthly'),
                  SizedBox(width: 10.w),
                  _buildFilterButton(context, 'All Time'),
                ],
              ),
            ),
            // History List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  top: 0,
                  bottom: 24
                      .h, // Extra bottom padding to prevent cards from being hidden
                ),
                physics: const BouncingScrollPhysics(),
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final item = history[index];
                  final String title = item['title'] as String;
                  final DateTime timestamp = item['timestamp'] as DateTime;

                  // Format date as "Wednesday, January 14" (day name + month name + day)
                  final dateFormatter = DateFormat('EEEE, MMMM d');
                  final String dateLabel = dateFormatter.format(timestamp);

                  return Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: _buildHistoryCard(
                      habit: title,
                      date: dateLabel,
                      isDone: true, // Only showing completed items
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context, String label) {
    final isSelected = _selectedFilter == label;
    // TODO: Add weekly, monthly, allTime to localization files
    // For now using English strings - intl will format dates based on locale

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilter = label;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[200],
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryCard({
    required String habit,
    required String date,
    required bool isDone,
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
      child: Row(
        children: [
          // Checkmark Icon
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              color: const Color(0xFF2E7D32),
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          // Habit Description and Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  date,
                  style: TextStyle(fontSize: 12.sp, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
