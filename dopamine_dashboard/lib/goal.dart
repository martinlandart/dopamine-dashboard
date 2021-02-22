import 'package:flutter/material.dart';

class Goal extends StatelessWidget {
  final String name;
  final IconData iconLocation;
  final Color color;
  final bool value;
  final ValueChanged<bool> onChanged;

  const Goal({
    Key key,
    @required this.name,
    @required this.onChanged,
    @required this.value,
    this.iconLocation,
    this.color,
  })  : assert(name != null),
        assert(onChanged != null);

  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: CheckboxListTile(
          value: value,
          title: Text(name),
          activeColor: Colors.black,
          checkColor: Colors.white,
          secondary: Icon(Icons.insert_emoticon),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
