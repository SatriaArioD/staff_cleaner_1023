import 'package:equatable/equatable.dart';
import 'package:staff_cleaner/models/address_model.dart';

class CustomerModel extends Equatable {
  final String? id;
  final String? name;
  final String? birthdate;
  final String? phoneNumber;
  final String? knowFrom;
  final List<AddressModel>? addresses;

  const CustomerModel({
    this.id,
    this.name,
    this.birthdate,
    this.phoneNumber,
    this.knowFrom,
    this.addresses,
  });

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'],
      name: map['name'],
      birthdate: map['birthdate'],
      phoneNumber: map['phoneNumber'],
      knowFrom: map['knowFrom'],
      addresses: (map['addresses'] as List)
          .map((e) => AddressModel.fromMap(e))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'birthdate': birthdate,
      'phoneNumber': phoneNumber,
      'knowFrom': knowFrom,
      'addresses': addresses?.map((e) => e.toMap()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        birthdate,
        phoneNumber,
        knowFrom,
        addresses,
      ];
}
