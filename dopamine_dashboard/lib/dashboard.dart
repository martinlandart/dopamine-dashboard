import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

import 'goal.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    Key key,
    @required this.goals,
  }) : assert(goals != null);

  final Map<String, bool> goals;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Set<String> _completedGoals = Set<String>();

  @override
  void didUpdateWidget(covariant oldWidget) {
    super.didUpdateWidget(oldWidget);
    _completedGoals = Set<String>();
  }

  @override
  void initState() {
    super.initState();
    _completedGoals = Set<String>();
  }

  void _onGoalCompleted(bool selected, String name) {
    if (selected == true) {
      setState(() {
        _completedGoals.add(name);
      });
    } else {
      setState(() {
        _completedGoals.remove(name);
      });
    }

    if (_completedGoals.length == widget.goals.length) {
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
                  setState(() {
                    _completedGoals = Set<String>();
                  });
                },
                onlyOkButton: true,
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final goals = <Goal>[];

    for (var item in widget.goals.entries) {
      goals.add(
        Goal(
          name: item.key,
          value: _completedGoals.contains(item.key),
          onChanged: (bool completed) {
            return {_onGoalCompleted(completed, item.key)};
          },
          iconLocation: Icons.check,
          color: Colors.greenAccent,
        ),
      );
    }

    return Container(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) => goals[index],
        itemCount: goals.length,
      ),
    );
  }
}
