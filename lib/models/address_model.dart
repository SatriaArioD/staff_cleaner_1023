import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class AddressModel extends Equatable {
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? electricalPower;

  const AddressModel({
    this.address,
    this.latitude,
    this.longitude,
    this.electricalPower,
  });

  factory AddressModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return AddressModel.fromMap(data);
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      address: map['address'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      electricalPower: map['electricalPower'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'electricalPower': electricalPower,
    };
  }

  @override
  List<Object?> get props => [
        address,
        latitude,
        longitude,
        electricalPower,
      ];
}
