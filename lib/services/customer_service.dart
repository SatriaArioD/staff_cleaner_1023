import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staff_cleaner/models/customer_model.dart';

class CustomerService {
  final CollectionReference customerRefrence =
      FirebaseFirestore.instance.collection('customer');

  Stream<List<CustomerModel>> watch() {
    Stream<QuerySnapshot> stream = customerRefrence.snapshots();

    return stream.map(
      (event) =>
          event.docs.map((e) => CustomerModel.fromDocumentSnapshot(e)).toList(),
    );
  }

  Future update({
    required CustomerModel customer,
  }) async {
    await customerRefrence.doc(customer.id!).set(customer.toMap());
  }
}
