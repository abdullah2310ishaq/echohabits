import 'package:flutter/material.dart';

/// Central app state for habits, today's tasks, and history.
///
/// Uses in‑memory storage only (no persistence yet).
class HabitService extends ChangeNotifier {
  /// User‑added habits (from Habits page) that should appear on Home.
  final List<Map<String, dynamic>> _userHabits = [];

  /// Predefined default Echo tasks shown on Home.
  ///
  /// These always have icons and are meant to reappear every 24 hours.
  final List<Map<String, dynamic>> _defaultTasks = [
    {
      'id': 'default_walk_bike_1',
      'title': 'Walked/ Biked instead of driving',
      'tags': ['Transport', 'High Impact'],
      'icon': Icons.directions_bike,
      'useSvg': false,
      'svgAsset': null,
      'taskName': 'Walked/ Biked',
    },
    {
      'id': 'default_coffee_cup',
      'title': 'Used a reusable coffee cup',
      'tags': ['Waste', 'Daily'],
      'icon': Icons.local_cafe,
      'useSvg': true,
      'svgAsset': 'assets/chae.svg',
      'taskName': 'Coffee Cup',
    },
    {
      'id': 'default_afforestation',
      'title': 'Afforestation/ Plant a tree for better environment',
      'tags': ['Afforestation', 'Planting'],
      'icon': Icons.park,
      'useSvg': true,
      'svgAsset': 'assets/tree.svg',
      'taskName': 'Afforestation',
    },
  ];

  /// IDs of default tasks that have been completed or skipped
  /// within the current 24‑hour window.
  final Set<String> _hiddenDefaultTaskIds = {};

  /// History entries for all tasks (default + habit‑based).
  ///
  /// Each entry has:
  /// - title (String)
  /// - category (String?)
  /// - isDefault (bool)
  /// - status ('done' | 'skipped')
  /// - timestamp (DateTime)
  final List<Map<String, dynamic>> _history = [];

  DateTime? _lastDefaultReset;

  List<Map<String, dynamic>> get userHabits => List.unmodifiable(_userHabits);

  List<Map<String, dynamic>> get history => List.unmodifiable(_history);

  /// Default tasks that should be shown "Today" (icons included).
  List<Map<String, dynamic>> get todayDefaultTasks {
    _ensureDefaultTasksFresh();
    return _defaultTasks
        .where((task) => !_hiddenDefaultTaskIds.contains(task['id'] as String))
        .toList(growable: false);
  }

  /// Add a new habit coming from the Habits page.
  void addHabit({
    required String title,
    required String category,
    required String difficulty,
    required Color difficultyColor,
    required String impact,
    required Color impactColor,
  }) {
    // Prevent duplicates by title.
    if (_userHabits.any((habit) => habit['title'] == title)) {
      return;
    }

    _userHabits.add({
      'title': title,
      'category': category,
      'difficulty': difficulty,
      'difficultyColor': difficultyColor,
      'impact': impact,
      'impactColor': impactColor,
      'addedFromHabitsPage': true,
    });

    notifyListeners();
  }

  /// Mark a default Echo task as done or skipped.
  ///
  /// - Removes it from today's list (by hiding its ID)
  /// - Adds an entry into History
  /// - It will reappear after 24 hours (in‑memory)
  void completeDefaultTask(String id, {required bool isDone}) {
    final task = _defaultTasks.firstWhere(
      (t) => t['id'] == id,
      orElse: () => <String, dynamic>{},
    );
    if (task.isEmpty) {
      return;
    }

    _ensureDefaultTasksFresh();
    _hiddenDefaultTaskIds.add(id);

    _addHistoryEntry(
      title: task['title'] as String,
      category: (task['tags'] as List).isNotEmpty
          ? task['tags'].first as String
          : null,
      isDefault: true,
      isDone: isDone,
    );

    notifyListeners();
  }

  /// Mark a habit‑based task as done or skipped.
  ///
  /// - Removes it from today's habit tasks
  /// - Adds an entry into History
  void completeHabitTask(String title, {required bool isDone}) {
    final index = _userHabits.indexWhere(
      (habit) => habit['title'] == title.trim(),
    );
    if (index == -1) {
      return;
    }

    final habit = _userHabits[index];
    _userHabits.removeAt(index);

    _addHistoryEntry(
      title: habit['title'] as String,
      category: habit['category'] as String?,
      isDefault: false,
      isDone: isDone,
    );

    notifyListeners();
  }

  /// Clear all user‑added habits.
  void clearHabits() {
    _userHabits.clear();
    notifyListeners();
  }

  /// Internal: ensure default tasks reset approximately every 24 hours.
  void _ensureDefaultTasksFresh() {
    final now = DateTime.now();
    if (_lastDefaultReset == null ||
        now.difference(_lastDefaultReset!).inHours >= 24) {
      _hiddenDefaultTaskIds.clear();
      _lastDefaultReset = now;
    }
  }

  void _addHistoryEntry({
    required String title,
    required bool isDefault,
    required bool isDone,
    String? category,
  }) {
    _history.insert(0, {
      'title': title,
      'category': category,
      'isDefault': isDefault,
      'status': isDone ? 'done' : 'skipped',
      'timestamp': DateTime.now(),
    });
  }
}
