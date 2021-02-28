import 'dart:collection';
import 'package:dopamine_dashboard/data/goal_database.dart';
import 'package:dopamine_dashboard/models/goal.dart';
import 'package:flutter/material.dart';

class GoalsModel extends ChangeNotifier {
  final Map<String, bool> _goals = Map<String, bool>();
  static final GoalDatabase database = GoalDatabase();

  UnmodifiableListView<String> get names => UnmodifiableListView(_goals.keys);

  UnmodifiableMapView<String, bool> get goals => UnmodifiableMapView(_goals);

  void readFromDatabase() {
    database.goals().then((List<Goal> goals) {
      var dbEntries =
          goals.map((goal) => MapEntry(goal.name, goal.isComplete)).toList();

      var dbGoalNames = goals.map((goal) => goal.name).toList();

      _goals.removeWhere((name, _) => !dbGoalNames.contains(name));
      _goals.addEntries(dbEntries);
      notifyListeners();
    });
  }

  Future<void> resetAllGoalsState() async {
    await database.resetAllGoals();
    readFromDatabase();
  }

  bool allGoalsComplete() {
    if (_goals.isEmpty) return false;

    for (var complete in _goals.values) {
      if (complete == false) return false;
    }
    return true;
  }

  Future<void> add(String goal) async {
    // _goals[goal] = false;
    await database.insertGoal(Goal(name: goal));
    readFromDatabase();
  }

  Future<void> update(String name, bool isCompleted) async {
    await database.updateGoal(Goal(name: name, isComplete: isCompleted));
    readFromDatabase();
  }

  Future<void> remove(String goal) async {
    await database.deleteGoal(goal);
    readFromDatabase();
  }
}
