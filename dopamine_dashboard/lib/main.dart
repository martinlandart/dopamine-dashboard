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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _dashboard,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resetDashboard,
        tooltip: 'Restart',
        child: Icon(Icons.loop_sharp),
      ),
    );
  }
}

class DummyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MyHomePage();
}
