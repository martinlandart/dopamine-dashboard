import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:provider/provider.dart';

import 'goal.dart';
import 'models/goalsModel.dart';

// class Dashboard extends StatefulWidget {
//   const Dashboard({
//     Key key,
//     @required this.goals,
//   }) : assert(goals != null);

//   final Map<String, bool> goals;

//   @override
//   _DashboardState createState() => _DashboardState();
// }

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _goals = <Goal>[];

    var listenedGoals = context.watch<GoalsModel>();

    for (var goal in listenedGoals.goals.entries) {
      _goals.add(
        Goal(
          name: goal.key,
          value: goal.value,
          onChanged: (bool completed) {
            return {listenedGoals.update(goal.key, completed)};
          },
          iconLocation: Icons.check,
          color: Colors.greenAccent,
        ),
      );
    }

    if (listenedGoals.allGoalsComplete()) {
      print('all tasks complete!!!');
      showDialog(
        context: context,
        builder: (_) => AssetGiffyDialog(
          image: Image(image: AssetImage('images/success.gif')),
          title: Text(
            'Congratulations!',
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
          ),
          description: Text(
            'You completed all of your goals for the day!',
            textAlign: TextAlign.center,
            style: TextStyle(),
          ),
          entryAnimation: EntryAnimation.LEFT,
          onOkButtonPressed: () {
            Navigator.of(context).pop();
            listenedGoals.resetAllGoalsState();
          },
          onlyOkButton: true,
        ),
      );
    }

    return Container(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) => _goals[index],
        itemCount: _goals.length,
      ),
    );
  }
}
