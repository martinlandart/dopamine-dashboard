import 'package:dopamine_dashboard/goal_list_item.dart';
import 'package:dopamine_dashboard/models/goals_model.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:provider/provider.dart';

class _ListItem extends StatelessWidget {
  final String goalName;
  final int index;

  _ListItem({@required this.index, Key key, @required this.goalName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isComplete =
        context.select<GoalsModel, bool>((goals) => goals.goals[goalName]);

    return GoalListItem(
      name: goalName,
      value: isComplete,
      onChanged: (val) async =>
          await context.read<GoalsModel>().update(goalName, val),
      iconLocation: Icons.check,
      color: Colors.greenAccent,
    );
  }
}

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var goals =
        context.select<GoalsModel, List<String>>((goals) => goals.names);

    if (goals.isEmpty) return Container();

    if (context.select<GoalsModel, bool>((goals) => goals.allGoalsComplete())) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showAllGoalsCompletedDialog(context);
      });
    }

    return Container(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) => Dismissible(
          key: UniqueKey(),
          child: _ListItem(
            index: index,
            goalName: goals[index],
          ),
          onDismissed: (direction) async {
            // var name = _goals[index].name;
            // _goals.removeAt(index);
            context.read<GoalsModel>().remove(goals[index]);
          },
          background: Container(color: Colors.red),
        ),
        itemCount: goals.length,
      ),
    );
  }

  Future showAllGoalsCompletedDialog(BuildContext context) {
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
          context.read<GoalsModel>().resetAllGoalsState();
        },
        onlyOkButton: true,
      ),
    );
  }
}
