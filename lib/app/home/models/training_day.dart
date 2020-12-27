import 'package:flutter/material.dart';

class TrainingDay {
  TrainingDay(
      {@required this.name,
      @required this.day,
      @required this.trainingTimes,
      @required this.complete});

  final String name;
  final String day;
  final List trainingTimes;
  final bool complete;

  Map<String, dynamic> toMap() {
    return {'name': name, 'day': day, 'trainingTimes': trainingTimes};
  }

  factory TrainingDay.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final String day = data['day'];
    final List trainingTimes = data['trainingTimes'];
    final bool complete = data['complete'];

    return TrainingDay(
      name: name,
      day: day,
      trainingTimes: trainingTimes,
      complete: complete,
    );
  }
}
