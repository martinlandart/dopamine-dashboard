import 'package:dopamine_dashboard/goal_list_item.dart';
import 'package:dopamine_dashboard/models/goals_model.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _goals = <GoalListItem>[];

    var listenedGoals = context.watch<GoalsModel>();

    for (var goal in listenedGoals.goals.entries) {
      _goals.add(
        GoalListItem(
          name: goal.key,
          value: goal.value,
          onChanged: (bool completed) async {
            return await listenedGoals.update(goal.key, completed);
          },
          iconLocation: Icons.check,
          color: Colors.greenAccent,
        ),
      );
    }

    if (listenedGoals.allGoalsComplete()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showAllGoalsCompletedDialog(context, listenedGoals);
      });
    }

    return Container(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) => Dismissible(
          key: UniqueKey(),
          child: _goals[index],
          onDismissed: (direction) async {
            // var name = _goals[index].name;
            // _goals.removeAt(index);
            await listenedGoals.remove(_goals[index].name);
          },
          background: Container(color: Colors.red),
        ),
        itemCount: _goals.length,
      ),
    );
  }

  Future showAllGoalsCompletedDialog(
      BuildContext context, GoalsModel listenedGoals) {
    return showDialog(
      context: context,
      builder: (_) => AssetGiffyDialog(
        image: Image(image: AssetImage('images/success_pr_optimized.gif')),
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
}
