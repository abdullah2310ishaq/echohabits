import 'package:flutter/material.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  String _selectedFilter = 'Weekly';

  // Hardcoded history data
  final List<Map<String, dynamic>> _historyItems = [
    {
      'habit': 'Biked or walked instead of driving',
      'date': 'Thursday, Jan 01',
    },
    {
      'habit': 'Brought a reusable shopping bag',
      'date': 'Wednesday, Dec 31',
    },
    {
      'habit': 'Took a 5-minute shower',
      'date': 'Monday, Dec 29',
    },
    {
      'habit': 'Used a reusable water bottle',
      'date': 'Monday, Dec 29',
    },
    {
      'habit': 'Biked or walked instead of driving',
      'date': 'Sunday, Dec 28',
    },
    {
      'habit': 'Brought a reusable shopping bag',
      'date': 'Sunday, Dec 28',
    },
    {
      'habit': 'Brought a reusable shopping bag',
      'date': 'Sunday, Dec 28',
    },
    {
      'habit': 'Biked or walked instead of driving',
      'date': 'Saturday, Dec 27',
    },
    {
      'habit': 'Used a reusable coffee cup',
      'date': 'Saturday, Dec 27',
    },
    {
      'habit': 'Switched off unused lights',
      'date': 'Friday, Dec 26',
    },
    {
      'habit': 'Composted kitchen waste',
      'date': 'Friday, Dec 26',
    },
    {
      'habit': 'Walked short distances',
      'date': 'Thursday, Dec 25',
    },
  ];

  @override
  Widget build(BuildContext context) {
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
              itemCount: _historyItems.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildHistoryCard(
                    habit: _historyItems[index]['habit'] as String,
                    date: _historyItems[index]['date'] as String,
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
              color: const Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Color(0xFF2E7D32),
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
