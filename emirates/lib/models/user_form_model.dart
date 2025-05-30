import 'package:cloud_firestore/cloud_firestore.dart';

class UserFormModel {
  late final String firstName;
  late final String lastName;
  late final String email;
  late final String password;
  late final int phoneNumber;
  late final int dateOfBirth;
  late final String country;

  UserFormModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.country,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth,
      'country': country,
    };
  }

  static UserFormModel fromSnap(DocumentSnapshot<Object?> snap) {
    var snapshot = snap.data() as Map<String, dynamic>?;

    if (snapshot != null) {
      return UserFormModel(
        firstName: snapshot['firstName'],
        lastName: snapshot['lastName'],
        email: snapshot['email'],
        password: snapshot['password'],
        phoneNumber: snapshot['phoneNumber'],
        dateOfBirth: snapshot['dateOfBirth'],
        country: snapshot['country'],
      );
    }
    else{
      return UserFormModel(
        firstName: '',
        lastName: '',
        email: '',
        password: '',
        phoneNumber: 0,
        dateOfBirth: 0,
        country: '',
      );
    }
  }
}
