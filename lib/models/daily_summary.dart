class DailySummary {
  final DateTime date;
  final int totalSteps;
  final double totalCalories;
  final int totalWorkoutMinutes;
  final double totalDistance;
  final int activitiesCount;
  final Map<String, int> exerciseTypeCount;

  DailySummary({
    required this.date,
    this.totalSteps = 0,
    this.totalCalories = 0.0,
    this.totalWorkoutMinutes = 0,
    this.totalDistance = 0.0,
    this.activitiesCount = 0,
    this.exerciseTypeCount = const {},
  });

  // Calculate progress percentage for different metrics
  double getStepsProgress(int goal) =>
      goal > 0 ? (totalSteps / goal).clamp(0.0, 1.0) : 0.0;
  double getCaloriesProgress(double goal) =>
      goal > 0 ? (totalCalories / goal).clamp(0.0, 1.0) : 0.0;
  double getWorkoutProgress(int goal) =>
      goal > 0 ? (totalWorkoutMinutes / goal).clamp(0.0, 1.0) : 0.0;
  double getDistanceProgress(double goal) =>
      goal > 0 ? (totalDistance / goal).clamp(0.0, 1.0) : 0.0;

  @override
  String toString() {
    return 'DailySummary{date: $date, steps: $totalSteps, calories: $totalCalories, workout: $totalWorkoutMinutes, distance: $totalDistance}';
  }
}
