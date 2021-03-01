import 'dart:async';
import 'package:dopamine_dashboard/models/goal.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class GoalDatabase {
  final Future<Database> database = getDatabasesPath().then((String path) {
    return openDatabase(
      join(path, 'goal_database.db'),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE goals(name TEXT PRIMARY KEY, isComplete INTEGER)");
      },
      version: 1,
    );
  });

  Future<void> insertGoal(Goal goal) async {
    final Database db = await database;

    await db.insert(
      'goals',
      goal.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Goal>> goals() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('goals');

    return List.generate(maps.length, (i) {
      return Goal(
        name: maps[i]['name'],
        isComplete: maps[i]['isComplete'] > 0,
      );
    });
  }

  Future<void> updateGoal(Goal goal) async {
    final db = await database;

    await db.update(
      'goals',
      goal.toMap(),
      where: "name = ?",
      whereArgs: [goal.name],
    );
  }

  Future<void> resetAllGoals() async {
    final db = await database;

    await db.execute('UPDATE goals SET isComplete = 0');
  }

  Future<void> deleteGoal(String name) async {
    final db = await database;

    await db.delete(
      'goals',
      where: "name = ?",
      whereArgs: [name],
    );
  }
}
