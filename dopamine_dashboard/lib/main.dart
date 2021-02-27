import 'package:dopamine_dashboard/dashboard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Dopamine Dashboard'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, bool> _goals;
  Dashboard _dashboard;
  final _formKey = GlobalKey<FormState>();
  final newGoalController = TextEditingController();

  @override
  initState() {
    super.initState();
    _goals = {
      'Wake up early': false,
      'Walk dog': false,
      'Practice guitar': false,
      'Meditate for 10 minutes': false,
      'Spend time with family': false,
      'Read for 30 minutes': false,
    };
    _dashboard = Dashboard(key: UniqueKey(), goals: _goals);
  }

  void _resetDashboard() {
    setState(() {
      _dashboard = Dashboard(key: UniqueKey(), goals: _goals);
    });
  }

  void _saveItem() {
    if (_formKey.currentState.validate()) {
      print(newGoalController.text);
    }
  }

  void _addItemPrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("New daily goal"),
          content: Form(
            key: _formKey,
            child: TextFormField(
                validator: (value) {
                  if (_goals.containsKey(value)) {
                    return 'Goal already exists';
                  }
                  return null;
                },
                controller: newGoalController),
          ),
          actions: [
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              onPressed: _saveItem,
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _dashboard,
      ),
      persistentFooterButtons: [
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton(
              onPressed: _resetDashboard,
              child: Row(
                children: [
                  Text('Reset'),
                  Icon(Icons.loop_sharp),
                ],
              ),
            ),
            FlatButton(
              minWidth: 100,
              onPressed: _addItemPrompt,
              child: Row(
                children: [
                  Text('Add'),
                  Icon(
                    Icons.add,
                  )
                ],
              ),
              color: Theme.of(context).accentColor,
            ),
          ],
        )
      ],
    );
  }
}

class DummyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MyHomePage();
}
