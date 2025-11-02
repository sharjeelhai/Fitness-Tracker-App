import 'package:uuid/uuid.dart';

class FitnessActivity {
  final String id;
  final DateTime date;
  final int steps;
  final double caloriesBurned;
  final int workoutDuration; // in minutes
  final String exerciseType;
  final double distanceKm;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  FitnessActivity({
    String? id,
    required this.date,
    this.steps = 0,
    this.caloriesBurned = 0.0,
    this.workoutDuration = 0,
    this.exerciseType = 'Walking',
    this.distanceKm = 0.0,
    this.notes = '',
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String().split('T')[0], // Store as YYYY-MM-DD
      'steps': steps,
      'caloriesBurned': caloriesBurned,
      'workoutDuration': workoutDuration,
      'exerciseType': exerciseType,
      'distanceKm': distanceKm,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from Map (SQLite)
  factory FitnessActivity.fromMap(Map<String, dynamic> map) {
    return FitnessActivity(
      id: map['id'],
      date: DateTime.parse(map['date']),
      steps: map['steps'] ?? 0,
      caloriesBurned: (map['caloriesBurned'] ?? 0.0).toDouble(),
      workoutDuration: map['workoutDuration'] ?? 0,
      exerciseType: map['exerciseType'] ?? 'Walking',
      distanceKm: (map['distanceKm'] ?? 0.0).toDouble(),
      notes: map['notes'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  FitnessActivity copyWith({
    String? id,
    DateTime? date,
    int? steps,
    double? caloriesBurned,
    int? workoutDuration,
    String? exerciseType,
    double? distanceKm,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FitnessActivity(
      id: id ?? this.id,
      date: date ?? this.date,
      steps: steps ?? this.steps,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      workoutDuration: workoutDuration ?? this.workoutDuration,
      exerciseType: exerciseType ?? this.exerciseType,
      distanceKm: distanceKm ?? this.distanceKm,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'FitnessActivity{id: $id, date: $date, exerciseType: $exerciseType, steps: $steps, calories: $caloriesBurned}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FitnessActivity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
