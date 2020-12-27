import 'package:andrea_project/services/api_path.dart';
import 'package:flutter/foundation.dart';
import 'package:andrea_project/app/home/models/training_day.dart';

import 'firestore_service.dart';

abstract class Database {
  Future<void> createTrainingDay(TrainingDay trainingday);
  //Stream<List<TrainingDay>> trainingdaysStream();
  Stream<List<TrainingDay>> trainingDaysStream();

  List<TrainingDay> createTrainingDayList();
  void createTrainingPlan(List<TrainingDay> trainingDays);
  Future<bool> hasPlan();
}

String get documentIdFromCurrentDate => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;
  final _service = FirestoreService.instance;

//TODO fix this hasPlan garbage
  Future<bool> hasPlan() async {
    final path = APIPath.trainingdays(uid);
    final snapshot = 10;
    // await FirebaseFirestore.instance.collection(path).snapshots().length;
    return snapshot > 0 ? true : false;
  }

  Future<void> createTrainingDay(TrainingDay trainingday) => _service.setData(
        data: trainingday.toMap(),
        path: APIPath.trainingday(uid, trainingday.day),
      );

  // Stream<List<TrainingDay>> trainingdaysStream() {
  //   final path = APIPath.trainingdays(uid);
  //   final reference = FirebaseFirestore.instance.collection(path);
  //   final snapshots = reference.snapshots();
  //   return snapshots.map((snapshot) => snapshot.docs.map((snapshot) {
  //         final data = snapshot.data();
  //         return data != null
  //             ? TrainingDay(
  //                 name: data['name'],
  //                 day: data['day'],
  //                 trainingTimes: data['trainingTimes'],
  //                 complete: data['complete'])
  //             : null;
  //       }).toList());
  // }

  Stream<List<TrainingDay>> trainingDaysStream() => _service.trainingDaysStream(
      path: APIPath.trainingdays(uid),
      builder: (data, documentId) => TrainingDay.fromMap(data, documentId));

  List<TrainingDay> createTrainingDayList() {
    List<String> planDays = [];
    List<TrainingDay> trainingDayList = [];
    for (int i in _trainingDays) {
      planDays.add((DateTime.now().add(Duration(days: i)).toIso8601String()));
    }
    print(planDays);
    for (String day in planDays) {
      trainingDayList.add(TrainingDay(
          name: 'TestBatch', day: day, trainingTimes: [1, 2], complete: false));
    }
    print('here is the training day list $trainingDayList');
    print(' here is the plan day list $planDays');
    return trainingDayList;
  }

  void createTrainingPlan(List<TrainingDay> trainingDays) {
    for (TrainingDay trainingDay in trainingDays)
      _service.setData(
        data: trainingDay.toMap(),
        path: APIPath.trainingday(uid, trainingDay.day),
      );
  }

  List _trainingDays = [
    0,
    2,
    3,
    5,
    7,
    9,
    10,
    12,
    14,
    16,
    17,
    19,
    21,
    23,
    24,
    26,
    28,
    30,
    31,
    33,
    35,
    37,
    38,
    40,
    42
  ];
}
