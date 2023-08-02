import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staff_cleaner/models/staff_model.dart';

class StaffService {
  final CollectionReference staffRefrence =
      FirebaseFirestore.instance.collection('staff');

  Stream<List<StaffModel>> watch() {
    Stream<QuerySnapshot> stream = staffRefrence.snapshots();

    return stream.map(
      (event) =>
          event.docs.map((e) => StaffModel.fromDocumentSnapshot(e)).toList(),
    );
  }
}
