import 'dart:collection';

import 'package:flutter/material.dart';

class GoalsModel extends ChangeNotifier {
  final Map<String, bool> _goals = Map<String, bool>();

  UnmodifiableListView<String> get names => UnmodifiableListView(_goals.keys);

  UnmodifiableMapView<String, bool> get goals => UnmodifiableMapView(_goals);

  void initForTesting() {
    _goals.addAll({
      'Wake up early': false,
      'Walk dog': false,
      'Practice guitar': false,
      'Meditate for 10 minutes': false,
      'Spend time with family': false,
      'Read for 30 minutes': false,
    });
  }

  void resetAllGoalsState() {
    for (var goal in _goals.entries) {
      _goals[goal.key] = false;
    }
    notifyListeners();
  }

  bool allGoalsComplete() {
    for (var complete in _goals.values) {
      if (complete == false) return false;
    }
    return true;
  }

  void add(String goal) {
    _goals[goal] = false;
    notifyListeners();
  }

  void update(String goal, bool isCompleted) {
    _goals[goal] = isCompleted;
    notifyListeners();
  }

  void remove(String goal) {
    _goals.remove(goal);
    notifyListeners();
  }
}
