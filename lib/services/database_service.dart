import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/fitness_activity.dart';
import '../models/user_goals.dart';
import '../utils/constants.dart';

class DatabaseService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), AppConstants.databaseName);

    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );
  }

  static Future<void> _createDatabase(Database db, int version) async {
    // Create fitness_activities table
    await db.execute('''
      CREATE TABLE ${AppConstants.activitiesTable} (
        id TEXT PRIMARY KEY,
        date TEXT NOT NULL,
        steps INTEGER DEFAULT 0,
        caloriesBurned REAL DEFAULT 0.0,
        workoutDuration INTEGER DEFAULT 0,
        exerciseType TEXT DEFAULT 'Walking',
        distanceKm REAL DEFAULT 0.0,
        notes TEXT DEFAULT '',
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // Create user_goals table
    await db.execute('''
      CREATE TABLE ${AppConstants.goalsTable} (
        id INTEGER PRIMARY KEY,
        stepsGoal INTEGER DEFAULT ${AppConstants.defaultStepsGoal},
        caloriesGoal REAL DEFAULT ${AppConstants.defaultCaloriesGoal},
        workoutGoal INTEGER DEFAULT ${AppConstants.defaultWorkoutGoal},
        distanceGoal REAL DEFAULT ${AppConstants.defaultDistanceGoal},
        updatedAt TEXT NOT NULL
      )
    ''');

    // Insert default goals
    await db.insert(AppConstants.goalsTable, UserGoals().toMap());

    // Create indexes for better performance
    await db.execute(
        'CREATE INDEX idx_date ON ${AppConstants.activitiesTable}(date)');
    await db.execute(
        'CREATE INDEX idx_exercise_type ON ${AppConstants.activitiesTable}(exerciseType)');
  }

  static Future<void> _upgradeDatabase(
      Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < 2) {
      // Add new columns or tables for version 2
    }
  }

  // CRUD Operations for Fitness Activities

  static Future<String> insertActivity(FitnessActivity activity) async {
    final db = await database;
    await db.insert(
      AppConstants.activitiesTable,
      activity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return activity.id;
  }

  static Future<List<FitnessActivity>> getAllActivities() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.activitiesTable,
      orderBy: 'date DESC, createdAt DESC',
    );

    return List.generate(maps.length, (i) {
      return FitnessActivity.fromMap(maps[i]);
    });
  }

  static Future<List<FitnessActivity>> getActivitiesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.activitiesTable,
      where: 'date BETWEEN ? AND ?',
      whereArgs: [
        startDate.toIso8601String().split('T')[0],
        endDate.toIso8601String().split('T')[0],
      ],
      orderBy: 'date DESC, createdAt DESC',
    );

    return List.generate(maps.length, (i) {
      return FitnessActivity.fromMap(maps[i]);
    });
  }

  static Future<List<FitnessActivity>> getActivitiesByDate(
      DateTime date) async {
    final db = await database;
    final dateString = date.toIso8601String().split('T')[0];

    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.activitiesTable,
      where: 'date = ?',
      whereArgs: [dateString],
      orderBy: 'createdAt DESC',
    );

    return List.generate(maps.length, (i) {
      return FitnessActivity.fromMap(maps[i]);
    });
  }

  static Future<FitnessActivity?> getActivityById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.activitiesTable,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return FitnessActivity.fromMap(maps.first);
    }
    return null;
  }

  static Future<void> updateActivity(FitnessActivity activity) async {
    final db = await database;
    await db.update(
      AppConstants.activitiesTable,
      activity.toMap(),
      where: 'id = ?',
      whereArgs: [activity.id],
    );
  }

  static Future<void> deleteActivity(String id) async {
    final db = await database;
    await db.delete(
      AppConstants.activitiesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteAllActivities() async {
    final db = await database;
    await db.delete(AppConstants.activitiesTable);
  }

  // User Goals Operations

  static Future<UserGoals> getUserGoals() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.goalsTable,
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return UserGoals.fromMap(maps.first);
    } else {
      // Create default goals if none exist
      final defaultGoals = UserGoals();
      await updateUserGoals(defaultGoals);
      return defaultGoals;
    }
  }

  static Future<void> updateUserGoals(UserGoals goals) async {
    final db = await database;
    await db.update(
      AppConstants.goalsTable,
      goals.toMap(),
      where: 'id = 1',
    );
  }

  // Statistics and Analytics

  static Future<Map<String, dynamic>> getDatabaseStats() async {
    final db = await database;

    final activitiesCount = await db.rawQuery(
        'SELECT COUNT(*) as count FROM ${AppConstants.activitiesTable}');
    final totalCount = activitiesCount.first['count'] as int;

    final sizeResult = await db.rawQuery('PRAGMA page_count');
    final pageCount = sizeResult.first['page_count'] as int;

    final pageSizeResult = await db.rawQuery('PRAGMA page_size');
    final pageSize = pageSizeResult.first['page_size'] as int;

    final databaseSizeBytes = pageCount * pageSize;
    final databaseSizeKB = (databaseSizeBytes / 1024).round();

    return {
      'totalActivities': totalCount,
      'databaseSizeKB': databaseSizeKB,
      'databasePages': pageCount,
    };
  }

  static Future<Map<String, int>> getExerciseTypeStats() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT exerciseType, COUNT(*) as count 
      FROM ${AppConstants.activitiesTable} 
      GROUP BY exerciseType 
      ORDER BY count DESC
    ''');

    Map<String, int> stats = {};
    for (var row in result) {
      stats[row['exerciseType']] = row['count'];
    }
    return stats;
  }
}
