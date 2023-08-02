import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staff_cleaner/models/schedule_model.dart';

class ScheduleService {
  final CollectionReference scheduleRefrence =
      FirebaseFirestore.instance.collection('schedule');

  Stream<List<ScheduleModel>> watch() {
    Stream<QuerySnapshot> stream = scheduleRefrence.snapshots();

    return stream.map(
      (event) =>
          event.docs.map((e) => ScheduleModel.fromDocumentSnapshot(e)).toList(),
    );
  }

  Future update({
    required ScheduleModel schedule,
  }) async {
    await scheduleRefrence.doc(schedule.id!).set(schedule.toMap());
  }

  Future delete({required String id}) async {
    await scheduleRefrence.doc(id).delete();
  }
}
