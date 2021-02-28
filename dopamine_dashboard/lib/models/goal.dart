import 'package:flutter/material.dart';

class Goal {
  final String name;
  final bool isComplete;

  Goal({@required this.name, this.isComplete = false}) : assert(name != null);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isComplete': isComplete,
    };
  }

  @override
  String toString() {
    return 'Goal{name: $name, isComplete: $isComplete}';
  }
}
