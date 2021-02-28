class Goal {
  final String name;
  final bool isComplete;

  Goal({this.name, this.isComplete});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isComplete': isComplete,
    };
  }
}
