import 'dart:io';

import 'package:dio/dio.dart';

class EditProfileParams {
  EditProfileParams({
    required this.firstName,
    required this.secondName,
    required this.email,
    required this.phoneNumber,
    required this.longitude,
    required this.latitude,
    required this.address,
    this.profilePic,
    required this.removedPicture,
  });

  final String firstName;
  final String secondName;
  final String email;
  final String phoneNumber;
  final double longitude;
  final double latitude;
  final String address;
  final File? profilePic;
  final bool removedPicture;

  Map<String, dynamic> toJson({bool? profilePicChanged}) {
    final map = {
      'FirstName': firstName,
      'SecondName': secondName,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'Longitude': longitude,
      'Latitude': latitude,
      'Address': address,
      'RemovedPicture': removedPicture,
      'File': null,
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
