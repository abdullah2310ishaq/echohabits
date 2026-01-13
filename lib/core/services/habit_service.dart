import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Central app state for habits, today's tasks, and history.
///
/// Uses Hive for persistent local storage.
class HabitService extends ChangeNotifier {
  static const String _boxName = 'habitBox';
  static const String _userHabitsKey = 'userHabits';
  static const String _historyKey = 'history';
  static const String _dailyScoreKey = 'dailyScore';
  static const String _totalScoreKey = 'totalScore';
  static const String _lastScoreResetDateKey = 'lastScoreResetDate';
  static const String _lastDefaultResetKey = 'lastDefaultReset';
  static const String _hiddenDefaultTaskIdsKey = 'hiddenDefaultTaskIds';
  static const String _habitAddTimestampsKey = 'habitAddTimestamps';

  static Box? _box;

  /// Map to track when habits were added (title -> timestamp)
  final Map<String, DateTime> _habitAddTimestamps = {};

  /// Initialize Hive box and load data
  static Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  /// Load all data from Hive
  Future<void> loadData() async {
    if (_box == null) return;

    // Load user habits
    final savedHabits = _box!.get(_userHabitsKey);
    if (savedHabits != null) {
      _userHabits.clear();
      final habitsList = savedHabits as List;
      for (var habit in habitsList) {
        final habitMap = Map<String, dynamic>.from(habit as Map);
        // Convert Color int values back to Color objects
        if (habitMap['difficultyColor'] is int) {
          habitMap['difficultyColor'] = Color(
            habitMap['difficultyColor'] as int,
          );
        }
        if (habitMap['impactColor'] is int) {
          habitMap['impactColor'] = Color(habitMap['impactColor'] as int);
        }
        _userHabits.add(habitMap);
      }
    }

    // Load history
    final savedHistory = _box!.get(_historyKey);
    if (savedHistory != null) {
      _history.clear();
      final historyList = savedHistory as List;
      for (var entry in historyList) {
        // Convert timestamp string back to DateTime
        final entryCopy = Map<String, dynamic>.from(entry as Map);
        if (entryCopy['timestamp'] is String) {
          entryCopy['timestamp'] = DateTime.parse(entryCopy['timestamp']);
        }
        _history.add(entryCopy);
      }
    }

    // Load scores
    final savedTotalScore = _box!.get(_totalScoreKey);
    // Migration: If old default value (2100) exists, reset to 0
    if (savedTotalScore == null || savedTotalScore == 2100) {
      _totalScore = 0;
      await _box!.put(_totalScoreKey, 0);
    } else {
      _totalScore = savedTotalScore as int;
    }
    _dailyScore = _box!.get(_dailyScoreKey, defaultValue: 0);

    // Load dates
    final lastResetStr = _box!.get(_lastScoreResetDateKey);
    if (lastResetStr != null) {
      _lastScoreResetDate = DateTime.parse(lastResetStr);
    }

    final lastDefaultResetStr = _box!.get(_lastDefaultResetKey);
    if (lastDefaultResetStr != null) {
      _lastDefaultReset = DateTime.parse(lastDefaultResetStr);
    }

    // Load hidden task IDs
    final hiddenIds = _box!.get(_hiddenDefaultTaskIdsKey);
    if (hiddenIds != null) {
      _hiddenDefaultTaskIds.clear();
      final idsList = hiddenIds as List;
      for (var id in idsList) {
        _hiddenDefaultTaskIds.add(id.toString());
      }
    }

    // Load habit add timestamps
    final savedTimestamps = _box!.get(_habitAddTimestampsKey);
    if (savedTimestamps != null) {
      _habitAddTimestamps.clear();
      final timestampsMap = savedTimestamps as Map;
      timestampsMap.forEach((key, value) {
        if (value is String) {
          _habitAddTimestamps[key.toString()] = DateTime.parse(value);
        }
      });
    }

    // Ensure scores are fresh (reset if needed)
    _ensureScoreFresh();
    _ensureDefaultTasksFresh();
  }

  /// Save all data to Hive
  Future<void> _saveData() async {
    if (_box == null) return;

    // Save user habits (convert Color to int for Hive)
    final habitsToSave = _userHabits.map((habit) {
      final habitCopy = Map<String, dynamic>.from(habit);
      // Convert Color objects to int (value) for Hive storage
      if (habitCopy['difficultyColor'] is Color) {
        habitCopy['difficultyColor'] =
            (habitCopy['difficultyColor'] as Color).value;
      }
      if (habitCopy['impactColor'] is Color) {
        habitCopy['impactColor'] = (habitCopy['impactColor'] as Color).value;
      }
      return habitCopy;
    }).toList();
    await _box!.put(_userHabitsKey, habitsToSave);

    // Save history (convert DateTime to String for storage)
    final historyToSave = _history.map((entry) {
      final entryCopy = Map<String, dynamic>.from(entry);
      if (entryCopy['timestamp'] is DateTime) {
        entryCopy['timestamp'] = (entryCopy['timestamp'] as DateTime)
            .toIso8601String();
      }
      return entryCopy;
    }).toList();
    await _box!.put(_historyKey, historyToSave);

    // Save scores
    await _box!.put(_totalScoreKey, _totalScore);
    await _box!.put(_dailyScoreKey, _dailyScore);

    // Save dates
    if (_lastScoreResetDate != null) {
      await _box!.put(
        _lastScoreResetDateKey,
        _lastScoreResetDate!.toIso8601String(),
      );
    }

    if (_lastDefaultReset != null) {
      await _box!.put(
        _lastDefaultResetKey,
        _lastDefaultReset!.toIso8601String(),
      );
    }

    // Save hidden task IDs
    await _box!.put(_hiddenDefaultTaskIdsKey, _hiddenDefaultTaskIds.toList());

    // Save habit add timestamps (convert DateTime to String)
    final timestampsToSave = <String, String>{};
    _habitAddTimestamps.forEach((key, value) {
      timestampsToSave[key] = value.toIso8601String();
    });
    await _box!.put(_habitAddTimestampsKey, timestampsToSave);
  }

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

  /// Daily eco score (resets at midnight)
  int _dailyScore = 0;

  /// Last date when score was reset
  DateTime? _lastScoreResetDate;

  /// Total cumulative score (all-time)
  int _totalScore = 0; // Starting score

  List<Map<String, dynamic>> get userHabits => List.unmodifiable(_userHabits);

  List<Map<String, dynamic>> get history => List.unmodifiable(_history);

  /// Get daily eco score (resets at midnight)
  int get dailyScore {
    _ensureScoreFresh();
    return _dailyScore;
  }

  /// Get total cumulative score
  int get totalScore => _totalScore;

  /// Default tasks that should be shown "Today" (icons included).
  List<Map<String, dynamic>> get todayDefaultTasks {
    _ensureDefaultTasksFresh();
    return _defaultTasks
        .where((task) => !_hiddenDefaultTaskIds.contains(task['id'] as String))
        .toList(growable: false);
  }

  /// Add a new habit coming from the Habits page.
  /// Returns: true if added successfully, false if failed (with reason in message)
  Map<String, dynamic> addHabit({
    required String title,
    required String category,
    required String difficulty,
    required Color difficultyColor,
    required String impact,
    required Color impactColor,
  }) {
    // Prevent duplicates by title (currently in list)
    if (_userHabits.any((habit) => habit['title'] == title)) {
      return {
        'success': false,
        'message': 'This habit is already added to your list',
      };
    }

    // Check 24-hour cooldown - prevent adding same habit within 24 hours
    final now = DateTime.now();
    if (_habitAddTimestamps.containsKey(title)) {
      final lastAdded = _habitAddTimestamps[title]!;
      final hoursSinceAdded = now.difference(lastAdded).inHours;

      // If added within last 24 hours, don't allow
      if (hoursSinceAdded < 24) {
        final hoursRemaining = 24 - hoursSinceAdded;
        return {
          'success': false,
          'message':
              'This habit was added recently. Please wait $hoursRemaining hours before adding again (resets at midnight)',
        };
      }
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

    // Track when this habit was added
    _habitAddTimestamps[title] = now;

    _saveData();
    notifyListeners();

    return {'success': true, 'message': '$title Added! Keep Going'};
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

    // Update score only if task is completed (not skipped)
    if (isDone) {
      _ensureScoreFresh();
      final points = _calculateTaskScore(task);
      _dailyScore += points;
      _totalScore += points;
    }

    _saveData();
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

    // Update score only if task is completed (not skipped)
    if (isDone) {
      _ensureScoreFresh();
      final points = _calculateTaskScore(habit);
      _dailyScore += points;
      _totalScore += points;
    }

    _saveData();
    notifyListeners();
  }

  /// Clear all user‑added habits.
  void clearHabits() {
    _userHabits.clear();
    _saveData();
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

  /// Internal: ensure daily score resets at midnight (00:00)
  void _ensureScoreFresh() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_lastScoreResetDate == null || _lastScoreResetDate! != today) {
      // Reset daily score at midnight (00:00)
      _dailyScore = 0;
      _lastScoreResetDate = today;

      // Clean up old habit timestamps (older than 24 hours)
      _habitAddTimestamps.removeWhere((key, value) {
        return now.difference(value).inHours >= 24;
      });

      _saveData();
    }
  }

  /// Calculate score points for a completed task
  int _calculateTaskScore(Map<String, dynamic> task) {
    // Base score: 10 points per completed task
    int baseScore = 10;

    // Bonus based on impact (if available)
    final impact = task['impact'] as String?;
    if (impact != null) {
      if (impact.contains('High Impact')) {
        baseScore += 5; // 15 total
      } else if (impact.contains('Medium Impact')) {
        baseScore += 2; // 12 total
      }
    }

    return baseScore;
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

  /// Get total number of completed actions (only 'done' status)
  int get totalActions {
    return _history.where((entry) => entry['status'] == 'done').length;
  }

  /// Get current streak (consecutive days with at least one completed task)
  int get currentStreak {
    if (_history.isEmpty) return 0;

    final completedTasks = _history
        .where((entry) => entry['status'] == 'done')
        .toList();

    if (completedTasks.isEmpty) return 0;

    // Group by date
    final Map<String, bool> daysWithTasks = {};
    for (var entry in completedTasks) {
      final timestamp = entry['timestamp'] as DateTime;
      final dateKey = '${timestamp.year}-${timestamp.month}-${timestamp.day}';
      daysWithTasks[dateKey] = true;
    }

    // Calculate streak
    final today = DateTime.now();
    int streak = 0;
    DateTime checkDate = DateTime(today.year, today.month, today.day);

    while (true) {
      final dateKey = '${checkDate.year}-${checkDate.month}-${checkDate.day}';
      if (daysWithTasks.containsKey(dateKey)) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        // If today has no tasks, check yesterday
        if (streak == 0 &&
            checkDate == DateTime(today.year, today.month, today.day)) {
          checkDate = checkDate.subtract(const Duration(days: 1));
          continue;
        }
        break;
      }
    }

    return streak;
  }

  /// Get average actions per day
  double get averageActionsPerDay {
    if (_history.isEmpty) return 0.0;

    final completedTasks = _history
        .where((entry) => entry['status'] == 'done')
        .toList();

    if (completedTasks.isEmpty) return 0.0;

    // Get date range
    final dates = completedTasks
        .map((entry) {
          final timestamp = entry['timestamp'] as DateTime;
          return DateTime(timestamp.year, timestamp.month, timestamp.day);
        })
        .toSet()
        .toList();

    if (dates.isEmpty) return 0.0;

    dates.sort();
    final firstDate = dates.first;
    final lastDate = dates.last;
    final daysDiff = lastDate.difference(firstDate).inDays + 1;

    if (daysDiff == 0) return completedTasks.length.toDouble();

    return completedTasks.length / daysDiff;
  }

  /// Get weekly score data for graph (last 7 days)
  /// Returns list of daily scores for the past week
  List<double> get weeklyScoreData {
    final now = DateTime.now();
    final List<double> weeklyScores = [];

    // Get last 7 days
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateKey = DateTime(date.year, date.month, date.day);

      // Calculate score for this day
      double dayScore = 0.0;
      for (var entry in _history) {
        if (entry['status'] != 'done') continue;

        final timestamp = entry['timestamp'] as DateTime;
        final entryDate = DateTime(
          timestamp.year,
          timestamp.month,
          timestamp.day,
        );

        if (entryDate == dateKey) {
          // Calculate score for this task
          int points = 10; // base score

          // Check if we can determine impact from task data
          // For now, use base score, can be enhanced later
          dayScore += points;
        }
      }

      // Normalize to a scale (e.g., divide by 10 for better visualization)
      weeklyScores.add(dayScore / 10.0);
    }

    return weeklyScores;
  }
}
