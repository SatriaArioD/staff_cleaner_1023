import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:staff_cleaner/models/address_model.dart';
import 'package:staff_cleaner/models/customer_model.dart';
import 'package:staff_cleaner/models/staff_model.dart';

class ScheduleModel extends Equatable {
  final String? id;
  final CustomerModel? customer;
  final AddressModel? address;
  final String? serviceDate;
  final String? serviceTime;
  final List<Map<dynamic, dynamic>>? items;
  final List<StaffModel>? staffs;
  final bool? isFinish;

  const ScheduleModel({
    this.id,
    this.customer,
    this.address,
    this.serviceDate,
    this.serviceTime,
    this.items,
    this.staffs,
    this.isFinish,
  });

  ScheduleModel copyWith({
    String? serviceDate,
    String? serviceTime,
    List<Map<dynamic, dynamic>>? items,
    List<StaffModel>? staffs,
    bool? isFinish,
  }) {
    return ScheduleModel(
      id: id,
      customer: customer,
      address: address,
      serviceDate: serviceDate ?? this.serviceDate,
      serviceTime: serviceTime ?? this.serviceTime,
      items: items ?? this.items,
      staffs: staffs ?? this.staffs,
      isFinish: isFinish ?? this.isFinish,
    );
  }

  factory ScheduleModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return ScheduleModel.fromMap(data);
  }

  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    return ScheduleModel(
      id: map['id'],
      customer: map['customer'] != null
          ? CustomerModel.fromMap(map['customer'])
          : null,
      address:
          map['address'] != null ? AddressModel.fromMap(map['address']) : null,
      serviceDate: map['serviceDate'],
      serviceTime: map['serviceTime'],
      items: map['items'] != null
          ? (map['items'] as List).map((e) => e as Map).toList()
          : null,
      staffs: map['staffs'] != null
          ? (map['staffs'] as List).map((e) => StaffModel.fromMap(e)).toList()
          : null,
      isFinish: map['isFinish'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer': customer?.toMap(),
      'address': address?.toMap(),
      'serviceDate': serviceDate,
      'serviceTime': serviceTime,
      'items': items,
      'staffs': staffs?.map((e) => e.toMap()).toList(),
      'isFinish': isFinish,
    };
  }

  @override
  List<Object?> get props => [
        customer,
        address,
        serviceDate,
        serviceTime,
        items,
        staffs,
        isFinish,
      ];
}
