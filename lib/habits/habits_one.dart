import 'package:flutter/material.dart';
import '../core/widgets/add_habit_dialog.dart';
import '../core/widgets/eco_toast.dart';

class HabitsOne extends StatefulWidget {
  const HabitsOne({super.key});

  @override
  State<HabitsOne> createState() => _HabitsOneState();
}

class _HabitsOneState extends State<HabitsOne> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Transport',
    'Food',
    'Home',
    'Water',
    'Shopping',
    'Waste',
    'Digital',
    'Fitness',
    'Mindfulness',
    'Savings',
  ];

  final List<Map<String, dynamic>> _allHabits = [
    // Transport habits
    {
      'title': 'Cycle to work',
      'category': 'Transport',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'title': 'Use public transport',
      'category': 'Transport',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'title': 'Carpool with colleagues',
      'category': 'Transport',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'Medium Impact',
      'impactColor': Colors.orange,
    },
    {
      'title': 'Walk short distances',
      'category': 'Transport',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'Low Impact',
      'impactColor': Colors.black54,
    },
    {
      'title': 'Maintain bike regularly',
      'category': 'Transport',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    // Food habits
    {
      'title': 'Buy bulk food',
      'category': 'Food',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'title': 'Compost kitchen waste',
      'category': 'Food',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'title': 'Plant a mini garden',
      'category': 'Food',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'Medium Impact',
      'impactColor': Colors.orange,
    },
    {
      'title': 'Reduce packaged food',
      'category': 'Food',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'Low Impact',
      'impactColor': Colors.black54,
    },
    {
      'title': 'Choose seasonal fruits',
      'category': 'Food',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    // Home habits
    {
      'title': 'Cold water wash',
      'category': 'Home',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'title': 'Switch off unused lights',
      'category': 'Home',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'title': 'Use energy-efficient bulbs',
      'category': 'Home',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'Medium Impact',
      'impactColor': Colors.orange,
    },
    {
      'title': 'Air dry clothes',
      'category': 'Home',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'Low Impact',
      'impactColor': Colors.black54,
    },
    {
      'title': 'Use natural ventilation',
      'category': 'Home',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    // Water habits
    {
      'title': 'Shorter showers',
      'category': 'Water',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'title': 'Fix water leaks',
      'category': 'Water',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'title': 'Collect rainwater for plants',
      'category': 'Water',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'Medium Impact',
      'impactColor': Colors.orange,
    },
    {
      'title': 'Reuse RO water',
      'category': 'Water',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'Low Impact',
      'impactColor': Colors.black54,
    },
    {
      'title': 'Turn off tap while brushing',
      'category': 'Water',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    // Shopping habits
    {
      'title': 'Carry reusable bags',
      'category': 'Shopping',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'title': 'Buy recycled products',
      'category': 'Shopping',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'title': 'Avoid fast fashion',
      'category': 'Shopping',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'Medium Impact',
      'impactColor': Colors.orange,
    },
    {
      'title': 'Choose eco-friendly brands',
      'category': 'Shopping',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'Low Impact',
      'impactColor': Colors.black54,
    },
    {
      'title': 'Support local business',
      'category': 'Shopping',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    // Waste habits
    {
      'title': 'Carry reusable bags',
      'category': 'Waste',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'title': 'Buy recycled products',
      'category': 'Waste',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'title': 'Avoid fast fashion',
      'category': 'Waste',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'Medium Impact',
      'impactColor': Colors.orange,
    },
    {
      'title': 'Choose eco-friendly brands',
      'category': 'Waste',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'Low Impact',
      'impactColor': Colors.black54,
    },
    {
      'title': 'Support local business',
      'category': 'Waste',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    // Digital habits
    {
      'title': 'Reduce screen time',
      'category': 'Digital',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'title': 'Unsubscribe unwanted mails',
      'category': 'Digital',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'title': 'Cloud backup cleanup',
      'category': 'Digital',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'Medium Impact',
      'impactColor': Colors.orange,
    },
    {
      'title': 'Turn off auto-play',
      'category': 'Digital',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'Low Impact',
      'impactColor': Colors.black54,
    },
    {
      'title': 'Digital mindful breaks',
      'category': 'Digital',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    // Fitness habits
    {
      'title': 'Morning walk',
      'category': 'Fitness',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'title': 'Practice yoga',
      'category': 'Fitness',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'title': 'Healthy sleep routine',
      'category': 'Fitness',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'Medium Impact',
      'impactColor': Colors.orange,
    },
    {
      'title': 'Drink 2L water',
      'category': 'Fitness',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'Low Impact',
      'impactColor': Colors.black54,
    },
    {
      'title': 'Avoid junk snacks',
      'category': 'Fitness',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    // Mindfulness habits
    {
      'title': 'Meditation 5 min/day',
      'category': 'Mindfulness',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'title': 'Practice gratitude journaling',
      'category': 'Mindfulness',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'title': 'Breathing exercise',
      'category': 'Mindfulness',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'Medium Impact',
      'impactColor': Colors.orange,
    },
    {
      'title': 'Spend time in nature',
      'category': 'Mindfulness',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'Low Impact',
      'impactColor': Colors.black54,
    },
    {
      'title': 'Limit negative news',
      'category': 'Mindfulness',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    // Savings habits
    {
      'title': 'Track expenses',
      'category': 'Savings',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'title': 'Monthly savings goal',
      'category': 'Savings',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'title': 'Avoid impulse buying',
      'category': 'Savings',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'Medium Impact',
      'impactColor': Colors.orange,
    },
    {
      'title': 'Invest in SIP',
      'category': 'Savings',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'Low Impact',
      'impactColor': Colors.black54,
    },
    {
      'title': 'Use cash-back responsibly',
      'category': 'Savings',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
  ];

  List<Map<String, dynamic>> get _filteredHabits {
    if (_selectedCategory == 'All') {
      return _allHabits;
    }
    return _allHabits
        .where((habit) => habit['category'] == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Header & Filter Section
          Container(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
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
                  'Habit Library',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 8),
                // Subtitle
                const Text(
                  'Pick one habit to begin your eco journey.',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 20),
                // Filter Bar
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = _selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          backgroundColor: Colors.grey[200],
                          selectedColor: const Color(0xFF2E7D32),
                          showCheckmark: false,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Main List View
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              children: [
                const Text(
                  'Pick a Habit to Add',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                ..._filteredHabits.map(
                  (habit) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildHabitCard(
                      title: habit['title'] as String,
                      difficulty: habit['difficulty'] as String,
                      difficultyColor: habit['difficultyColor'] as Color,
                      impact: habit['impact'] as String,
                      impactColor: habit['impactColor'] as Color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitCard({
    required String title,
    required String difficulty,
    required Color difficultyColor,
    required String impact,
    required Color impactColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(22),
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
      child: Row(
        children: [
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 14),
                // Metadata Row
                Row(
                  children: [
                    // Difficulty Dot
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: difficultyColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Difficulty Text
                    Text(
                      difficulty,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Impact Label
                    Text(
                      impact,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: impactColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Add Button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.black87, size: 24),
              onPressed: () {
                AddHabitDialog.show(
                  context,
                  habitTitle: title,
                  difficulty: difficulty,
                  difficultyColor: difficultyColor,
                  impact: impact,
                  impactColor: impactColor,
                  onAdd: () {
                    // TODO: Handle add habit - add to user's habits list
                    EcoToast.show(
                      context,
                      message: '$title Habit Added! Keep Going',
                      isSuccess: true,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
