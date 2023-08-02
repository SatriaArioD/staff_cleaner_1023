import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class StaffModel extends Equatable {
  final String? email;
  final String? fullName;
  final String? phoneNumber;
  final String? birthdate;
  final String? image;
  final bool? isScheduled;

  const StaffModel({
    this.email,
    this.fullName,
    this.phoneNumber,
    this.birthdate,
    this.image,
    this.isScheduled,
  });

  factory StaffModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return StaffModel.fromMap(data);
  }

  factory StaffModel.fromMap(Map<String, dynamic> map) {
    return StaffModel(
      email: map['email'],
      fullName: map['nama_lengkap'],
      phoneNumber: map['no_hp'],
      birthdate: map['tanggal_lahir'],
      image: map['image'],
      isScheduled: map['bertugas'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'nama_lengkap': fullName,
      'no_hp': phoneNumber,
      'tanggal_lahir': birthdate,
      'image': image,
      'bertugas': isScheduled,
    };
  }

  @override
  List<Object?> get props => [
        email,
        fullName,
        phoneNumber,
        birthdate,
        isScheduled,
      ];
}
