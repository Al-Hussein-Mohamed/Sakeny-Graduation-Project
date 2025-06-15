// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sakeny/features/post/posts/models/post_model.dart';
import 'package:sakeny/features/unit/models/unit_model/unit_model.dart';

class UserModel extends Equatable {
  final String userId;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String address;
  final String? profilePictureURL;
  late final String fullName;

  final num rate;

  final LatLng location;

  UserModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.profilePictureURL,
    required this.rate,
    required this.location,
    required this.address,
  }) {
    fullName = "$firstName $lastName";
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userId: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
        profilePictureURL: json["picture"],
        rate: json['rate'] as num,
        address: json["address"],
        location: LatLng(
          (json["latitude"] as num).toDouble(),
          (json["longitude"] as num).toDouble(),
        ),
      );

  UserModel copyWith({
    bool? clearProfilePic,
    String? userId,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? email,
    String? profilePictureURL,
    num? rate,
    LatLng? location,
    String? address,
    List<PostModel>? posts,
    List<UnitModel>? units,
    List<UnitModel>? favorites,
  }) {
    final UserModel model = UserModel(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      profilePictureURL:
          clearProfilePic != null ? null : profilePictureURL ?? this.profilePictureURL,
      rate: rate ?? this.rate,
      location: location ?? this.location,
      address: address ?? this.address,
    );

    return model;
  }

  @override
  List<Object?> get props => [
        userId,
        firstName,
        lastName,
        phoneNumber,
        email,
        profilePictureURL,
        rate,
        location,
        address,
      ];
}

sealed class UserAuthState {
  const UserAuthState();
}

final class GuestUser extends UserAuthState {
  const GuestUser();
}

final class AuthenticatedUser extends UserAuthState {
  AuthenticatedUser({
    this.userModel,
  });

  final UserModel? userModel;

  AuthenticatedUser copyWith({
    UserModel? userModel,
  }) {
    return AuthenticatedUser(
      userModel: userModel ?? this.userModel,
    );
  }
}
