import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:habit_tracker/l10n/app_localizations.dart';

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

  /// Get daily eco score (resets at midnight, capped at 100)
  int get dailyScore {
    _ensureScoreFresh();
    return _dailyScore.clamp(0, 100);
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
    required BuildContext context,
  }) {
    final l10n = AppLocalizations.of(context)!;

    // Prevent duplicates by title (currently in list)
    if (_userHabits.any((habit) => habit['title'] == title)) {
      return {'success': false, 'message': l10n.thisHabitIsAlreadyAdded};
    }

    // Check midnight cooldown - prevent adding same habit twice in the same day
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_habitAddTimestamps.containsKey(title)) {
      final lastAdded = _habitAddTimestamps[title]!;
      final lastAddedDate = DateTime(
        lastAdded.year,
        lastAdded.month,
        lastAdded.day,
      );

      // If added today (same day), don't allow (resets at midnight)
      if (lastAddedDate == today) {
        return {'success': false, 'message': l10n.thisHabitIsAlreadyAdded};
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

    return {'success': true, 'message': l10n.habitAddedKeepGoing(title)};
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
      // Cap daily score at 100, but still add to total
      final newDailyScore = _dailyScore + points;
      _dailyScore = newDailyScore.clamp(0, 100);
      _totalScore += points; // Total score continues to accumulate
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
      // Cap daily score at 100, but still add to total
      final newDailyScore = _dailyScore + points;
      _dailyScore = newDailyScore.clamp(0, 100);
      _totalScore += points; // Total score continues to accumulate
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

  /// Reset all progress: scores, history, habits, and related data
  Future<void> resetAllProgress() async {
    // Reset scores
    _dailyScore = 0;
    _totalScore = 0;
    
    // Clear history
    _history.clear();
    
    // Clear user habits
    _userHabits.clear();
    
    // Clear habit add timestamps
    _habitAddTimestamps.clear();
    
    // Clear hidden default task IDs
    _hiddenDefaultTaskIds.clear();
    
    // Reset dates
    _lastScoreResetDate = null;
    _lastDefaultReset = null;
    
    // Save all changes to Hive
    if (_box != null) {
      await _box!.put(_dailyScoreKey, 0);
      await _box!.put(_totalScoreKey, 0);
      await _box!.put(_historyKey, []);
      await _box!.put(_userHabitsKey, []);
      await _box!.put(_habitAddTimestampsKey, {});
      await _box!.put(_hiddenDefaultTaskIdsKey, []);
      await _box!.delete(_lastScoreResetDateKey);
      await _box!.delete(_lastDefaultResetKey);
    }
    
    notifyListeners();
  }

  /// Internal: ensure default tasks reset at midnight (00:00)
  void _ensureDefaultTasksFresh() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_lastDefaultReset == null) {
      // First time - set to today
      _lastDefaultReset = now;
      _saveData();
    } else {
      final lastResetDate = DateTime(
        _lastDefaultReset!.year,
        _lastDefaultReset!.month,
        _lastDefaultReset!.day,
      );
      // Reset if it's a new day (midnight passed)
      if (lastResetDate != today) {
        _hiddenDefaultTaskIds.clear();
        _lastDefaultReset = now;
        _saveData();
      }
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

      // Clean up habit timestamps from previous days (reset at midnight)
      _habitAddTimestamps.removeWhere((key, value) {
        final valueDate = DateTime(value.year, value.month, value.day);
        return valueDate != today; // Remove if not from today
      });

      _saveData();
    }
  }

  /// Calculate score points for a completed task
  /// Total unique tasks: 45 unique habits + 3 defaults = 48 tasks
  /// To reach 100 points: 100 / 48 ≈ 2.083 points per task
  /// Strategy: Give 2 points to 44 tasks and 3 points to 4 tasks = 44*2 + 4*3 = 88 + 12 = 100
  int _calculateTaskScore(Map<String, dynamic> task) {
    // Count how many tasks have been completed today (before this one)
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final completedToday = _history.where((entry) {
      if (entry['status'] != 'done') return false;
      final timestamp = entry['timestamp'] as DateTime;
      return timestamp.isAfter(todayStart) || timestamp.isAtSameMomentAs(todayStart);
    }).length;
    
    // Give 3 points to the first 4 completed tasks, 2 points to the rest
    // This ensures we reach exactly 100 when all 48 tasks are completed:
    // 4 tasks * 3 points + 44 tasks * 2 points = 12 + 88 = 100
    // Note: completedToday includes the current task since history is added before score calculation
    if (completedToday <= 4) {
      return 3;
    } else {
      return 2;
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
