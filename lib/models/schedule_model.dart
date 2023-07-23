import 'package:equatable/equatable.dart';
import 'package:staff_cleaner/models/address_model.dart';
import 'package:staff_cleaner/models/customer_model.dart';
import 'package:staff_cleaner/models/staff_model.dart';

class ScheduleModel extends Equatable {
  final CustomerModel? customer;
  final AddressModel? address;
  final String? serviceDate;
  final String? serviceTime;
  final List<Map<dynamic, dynamic>>? items;
  final List<StaffModel>? staffs;

  const ScheduleModel({
    this.customer,
    this.address,
    this.serviceDate,
    this.serviceTime,
    this.items,
    this.staffs,
  });

  factory ScheduleModel.fromMap(Map<String, dynamic> json) {
    return ScheduleModel(
      customer: json['customer'] != null
          ? CustomerModel.fromMap(json['customer'])
          : null,
      address: json['address'] != null
          ? AddressModel.fromMap(json['address'])
          : null,
      serviceDate: json['serviceDate'],
      serviceTime: json['serviceTime'],
      items: json['items'] != null
          ? (json['items'] as List).map((e) => e as Map).toList()
          : null,
      staffs: json['staffs'] != null
          ? (json['staffs'] as List).map((e) => StaffModel.fromMap(e)).toList()
          : null,
    );
  }

  @override
  List<Object?> get props => [
        customer,
        address,
        serviceDate,
        serviceTime,
        items,
        staffs,
      ];
}
