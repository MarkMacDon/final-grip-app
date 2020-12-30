import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  //* This private constructor allows firestore service to only be accessible by a singleton object
  //* This is because multiple classes will communicate with FirestoreService but
  //* I dont want multiple instances of FirestoreService
  //* This ensuers only one instance of FirestoreService can be created
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData({String path, Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(data);
  }

  Future<void> deleteTrainingPlan({@required String path}) async {
    final reference = FirebaseFirestore.instance.collection(path);
    reference.get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }

  Stream<List<T>> trainingDaysStream<T>(
      {@required
          String path,
      @required
          T Function(Map<String, dynamic> data, String documentId) builder}) {
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map(
          (snapshot) => builder(snapshot.data(), snapshot.id),
        )
        .toList());
  }
}
