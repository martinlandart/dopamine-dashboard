import 'package:dopamine_dashboard/dashboard.dart';
import 'package:dopamine_dashboard/models/goalsModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GoalsModel(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final goals = Provider.of<GoalsModel>(context, listen: false);

    goals.initForTesting();

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
  final _formKey = GlobalKey<FormState>();
  final newGoalController = TextEditingController();

  void _saveItem() {
    if (_formKey.currentState.validate()) {
      context.read<GoalsModel>().add(newGoalController.text);
    }
    _formKey.currentState.reset();
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Goal name can not be empty';
                  }
                  if (context.read<GoalsModel>().names.contains(value)) {
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
        child: Dashboard(),
      ),
      persistentFooterButtons: [
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton(
              onPressed: () {
                var goals = context.read<GoalsModel>();
                goals.resetAllGoalsState();
              },
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
