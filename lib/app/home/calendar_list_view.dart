import 'package:andrea_project/app/constants/constants.dart';
import 'package:flutter/material.dart';

//TODO  Need to pass the event day to the training screen so I can get the right reps and sets

class CalendarListView extends StatelessWidget {
  final dynamic event;
  CalendarListView(this.event);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: kAppBarColor,
          child: Text(event),
        ),
        Container(
          child: Text(event),
          color: Colors.grey,
        ),
      ],
    );
  }
}
