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

  // Define a function that inserts dogs into the database
  Future<void> insertGoal(Goal goal) async {
    // Get a reference to the database.
    final Database db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'goals',
      goal.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Goal>> goals() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('goals');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Goal(
        name: maps[i]['name'],
        isComplete: maps[i]['isComplete'] > 0,
      );
    });
  }

  Future<void> updateGoal(Goal goal) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.
    await db.update(
      'goals',
      goal.toMap(),
      where: "name = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [goal.name],
    );
  }

  Future<void> resetAllGoals() async {
    final db = await database;

    await db.execute('UPDATE goals SET isComplete = 0');
  }

  Future<void> deleteGoal(String name) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'goals',
      // Use a `where` clause to delete a specific dog.
      where: "name = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [name],
    );
  }
}
