import '../utils/constants.dart';

class UserGoals {
  final int stepsGoal;
  final double caloriesGoal;
  final int workoutGoal; // minutes
  final double distanceGoal; // km
  final DateTime updatedAt;

  UserGoals({
    this.stepsGoal = AppConstants.defaultStepsGoal,
    this.caloriesGoal = AppConstants.defaultCaloriesGoal,
    this.workoutGoal = AppConstants.defaultWorkoutGoal,
    this.distanceGoal = AppConstants.defaultDistanceGoal,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'stepsGoal': stepsGoal,
      'caloriesGoal': caloriesGoal,
      'workoutGoal': workoutGoal,
      'distanceGoal': distanceGoal,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserGoals.fromMap(Map<String, dynamic> map) {
    return UserGoals(
      stepsGoal: map['stepsGoal'] ?? AppConstants.defaultStepsGoal,
      caloriesGoal:
          (map['caloriesGoal'] ?? AppConstants.defaultCaloriesGoal).toDouble(),
      workoutGoal: map['workoutGoal'] ?? AppConstants.defaultWorkoutGoal,
      distanceGoal:
          (map['distanceGoal'] ?? AppConstants.defaultDistanceGoal).toDouble(),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  UserGoals copyWith({
    int? stepsGoal,
    double? caloriesGoal,
    int? workoutGoal,
    double? distanceGoal,
  }) {
    return UserGoals(
      stepsGoal: stepsGoal ?? this.stepsGoal,
      caloriesGoal: caloriesGoal ?? this.caloriesGoal,
      workoutGoal: workoutGoal ?? this.workoutGoal,
      distanceGoal: distanceGoal ?? this.distanceGoal,
      updatedAt: DateTime.now(),
    );
  }
}
