class AppConstants {
  // App Info
  static const String appName = 'Fitness Tracker App';
  static const String appVersion = '1.0.0';

  // Database
  static const String databaseName = 'fitness_tracker_app.db';
  static const int databaseVersion = 1;
  static const String activitiesTable = 'fitness_activities';
  static const String goalsTable = 'user_goals';

  // Default Goals
  static const int defaultStepsGoal = 10000;
  static const double defaultCaloriesGoal = 2000.0;
  static const int defaultWorkoutGoal = 60; // minutes
  static const double defaultDistanceGoal = 5.0; // km

  // Exercise Types
  static const List<String> exerciseTypes = [
    'Walking',
    'Running',
    'Cycling',
    'Swimming',
    'Gym Workout',
    'Yoga',
    'Dancing',
    'Football',
    'Basketball',
    'Tennis',
    'Hiking',
    'Boxing',
    'Rowing',
    'Climbing',
    'Other',
  ];

  // Colors
  static const Map<String, int> exerciseColors = {
    'Walking': 0xFF4CAF50,
    'Running': 0xFFE53935,
    'Cycling': 0xFF2196F3,
    'Swimming': 0xFF00BCD4,
    'Gym Workout': 0xFFFF9800,
    'Yoga': 0xFF9C27B0,
    'Dancing': 0xFFE91E63,
    'Football': 0xFF8BC34A,
    'Basketball': 0xFFFF5722,
    'Tennis': 0xFF009688,
    'Hiking': 0xFF795548,
    'Boxing': 0xFF607D8B,
    'Rowing': 0xFF3F51B5,
    'Climbing': 0xFF9E9E9E,
    'Other': 0xFF757575,
  };
}
