import 'dart:io';

import 'package:dio/dio.dart';

class RegisterReqParams {
  RegisterReqParams({
    required this.firstName,
    required this.secondName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.confirmPassword,
    required this.longitude,
    required this.latitude,
    required this.address,
    this.profilePic,
  });

  final String firstName;
  final String secondName;
  final String email;
  final String phoneNumber;
  final String password;
  final String confirmPassword;
  final double longitude;
  final double latitude;
  final String address;
  final File? profilePic;

  Map<String, dynamic> toJson() {
    final map = {
      'FirstName': firstName,
      'SecondName': secondName,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'Password': password,
      'ConfirmPassword': confirmPassword,
      'Longitude': longitude,
      'Latitude': latitude,
      'Address': address,
    };

    if (profilePic != null) {
      map['File'] = MultipartFile.fromFileSync(
        profilePic!.path,
        filename: profilePic!.path.split('/').last,
      );
    }

    return map;
  }
}
