import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/habit_service.dart';

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
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'History',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filter Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildFilterButton('Weekly'),
                const SizedBox(width: 12),
                _buildFilterButton('Monthly'),
                const SizedBox(width: 12),
                _buildFilterButton('All Time'),
              ],
            ),
          ),
          // History List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                final String title = item['title'] as String;
                final String status = item['status'] as String;
                final bool isDefault = item['isDefault'] as bool? ?? false;
                final DateTime timestamp = item['timestamp'] as DateTime;

                final String dateLabel =
                    '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')}';
                final String subtitle =
                    '${isDefault ? 'Default task' : 'Habit'} • ${status == 'done' ? 'Completed' : 'Skipped'} • $dateLabel';

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildHistoryCard(
                    habit: title,
                    date: subtitle,
                    isDone: status == 'done',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label) {
    final isSelected = _selectedFilter == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilter = label;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF2E7D32)
                : Colors.grey[200],
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
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
          // Checkmark Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDone
                  ? const Color(0xFFE8F5E9)
                  : const Color(0xFFFFEBEE),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDone ? Icons.check : Icons.close,
              color: isDone ? const Color(0xFF2E7D32) : Colors.redAccent,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          // Habit Description and Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 14,
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
}
