import 'package:fitness_tracker_app/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class AppHelpers {
  // Date Formatting
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatDateShort(DateTime date) {
    return DateFormat('dd/MM').format(date);
  }

  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  static String formatDuration(int minutes) {
    if (minutes < 60) {
      return '${minutes}m';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      return remainingMinutes > 0
          ? '${hours}h ${remainingMinutes}m'
          : '${hours}h';
    }
  }

  // Number Formatting
  static String formatNumber(double number, {int decimals = 1}) {
    return number.toStringAsFixed(decimals);
  }

  static String formatCalories(double calories) {
    if (calories < 1000) {
      return '${calories.toInt()}';
    } else {
      return '${(calories / 1000).toStringAsFixed(1)}k';
    }
  }

  // Validation
  static bool isValidNumber(String value) {
    return double.tryParse(value) != null;
  }

  // Colors
  static Color getExerciseColor(String exerciseType) {
    final colorValue = AppConstants.exerciseColors[exerciseType] ?? 0xFF757575;
    return Color(colorValue);
  }

  // Progress Calculation
  static double calculateProgress(double current, double target) {
    if (target <= 0) return 0.0;
    return (current / target).clamp(0.0, 1.0);
  }

  // Date Helpers
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  static List<DateTime> getWeekDays(DateTime date) {
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }
}
