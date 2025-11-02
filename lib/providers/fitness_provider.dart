import 'package:flutter/material.dart';
import '../models/fitness_activity.dart';
import '../models/daily_summary.dart';
import '../models/user_goals.dart';
import '../services/database_service.dart';
import '../utils/helpers.dart';

class FitnessProvider with ChangeNotifier {
  List<FitnessActivity> _activities = [];
  UserGoals _userGoals = UserGoals();
  bool _isLoading = false;
  String? _error;

  // Getters
  List<FitnessActivity> get activities => _activities;
  UserGoals get userGoals => _userGoals;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get today's activities
  List<FitnessActivity> get todayActivities {
    final today = DateTime.now();
    return _activities.where((activity) {
      return AppHelpers.isSameDay(activity.date, today);
    }).toList();
  }

  // Get today's summary
  DailySummary get todaySummary {
    return _calculateDailySummary(DateTime.now());
  }

  // Get weekly summary
  List<DailySummary> get weeklySummary {
    final now = DateTime.now();
    final weekDays = AppHelpers.getWeekDays(now);

    return weekDays.map((day) => _calculateDailySummary(day)).toList();
  }

  // Calculate daily summary for a specific date
  DailySummary _calculateDailySummary(DateTime date) {
    final dayActivities = _activities.where((activity) {
      return AppHelpers.isSameDay(activity.date, date);
    }).toList();

    final exerciseTypeCount = <String, int>{};
    for (var activity in dayActivities) {
      exerciseTypeCount[activity.exerciseType] =
          (exerciseTypeCount[activity.exerciseType] ?? 0) + 1;
    }

    return DailySummary(
      date: date,
      totalSteps:
          dayActivities.fold(0, (sum, activity) => sum + activity.steps),
      totalCalories: dayActivities.fold(
          0.0, (sum, activity) => sum + activity.caloriesBurned),
      totalWorkoutMinutes: dayActivities.fold(
          0, (sum, activity) => sum + activity.workoutDuration),
      totalDistance:
          dayActivities.fold(0.0, (sum, activity) => sum + activity.distanceKm),
      activitiesCount: dayActivities.length,
      exerciseTypeCount: exerciseTypeCount,
    );
  }

  // Load all data
  Future<void> loadData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Load activities and goals concurrently
      final futures = await Future.wait([
        DatabaseService.getAllActivities(),
        DatabaseService.getUserGoals(),
      ]);

      _activities = futures[0] as List<FitnessActivity>;
      _userGoals = futures[1] as UserGoals;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Activities CRUD operations
  Future<void> addActivity(FitnessActivity activity) async {
    try {
      await DatabaseService.insertActivity(activity);
      _activities.insert(0, activity);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      debugPrint('Error adding activity: $e');
      notifyListeners();
    }
  }

  Future<void> updateActivity(FitnessActivity activity) async {
    try {
      await DatabaseService.updateActivity(activity);
      final index = _activities.indexWhere((a) => a.id == activity.id);
      if (index != -1) {
        _activities[index] = activity;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('Error updating activity: $e');
      notifyListeners();
    }
  }

  Future<void> deleteActivity(String activityId) async {
    try {
      await DatabaseService.deleteActivity(activityId);
      _activities.removeWhere((activity) => activity.id == activityId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      debugPrint('Error deleting activity: $e');
      notifyListeners();
    }
  }

  // Goals operations
  Future<void> updateGoals(UserGoals newGoals) async {
    try {
      await DatabaseService.updateUserGoals(newGoals);
      _userGoals = newGoals;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      debugPrint('Error updating goals: $e');
      notifyListeners();
    }
  }

  // Utility methods
  Future<List<FitnessActivity>> getActivitiesForDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      return await DatabaseService.getActivitiesByDateRange(startDate, endDate);
    } catch (e) {
      debugPrint('Error getting activities for date range: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> getDatabaseStats() async {
    try {
      return await DatabaseService.getDatabaseStats();
    } catch (e) {
      debugPrint('Error getting database stats: $e');
      return {'totalActivities': 0, 'databaseSizeKB': 0};
    }
  }

  Future<Map<String, int>> getExerciseTypeStats() async {
    try {
      return await DatabaseService.getExerciseTypeStats();
    } catch (e) {
      debugPrint('Error getting exercise type stats: $e');
      return {};
    }
  }

  Future<void> clearAllData() async {
    try {
      await DatabaseService.deleteAllActivities();
      _activities.clear();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      debugPrint('Error clearing data: $e');
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
