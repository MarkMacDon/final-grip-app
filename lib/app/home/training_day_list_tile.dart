import 'package:flutter/material.dart';

class TrainingDayListTile extends StatelessWidget {
  const TrainingDayListTile(
      {@required this.title,
      @required this.complete,
      @required this.day,
      @required this.onPressed});

  final String title;
  final bool complete;
  final String day;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Text(day),
      trailing: Checkbox(value: complete, onChanged: (_) {}),
      onTap: onPressed,
    );
  }
}
