import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sakeny/core/constants/const_images.dart';
import 'package:sakeny/generated/l10n.dart';

class KNearbyServicesKeys {
  static const String restaurant = 'restaurant';
  static const String bank = 'bank';
  static const String parking = 'parking';
  static const String university = 'university';
  static const String hospital = 'hospital';
  static const String school = 'school';
  static const String gym = 'gym';

  static final int restaurantBit = 1 << 0;
  static final int bankBit = 1 << 1;
  static final int parkingBit = 1 << 2;
  static final int universityBit = 1 << 3;
  static final int hospitalBit = 1 << 4;
  static final int schoolBit = 1 << 5;
  static final int gymBit = 1 << 6;

  // Change the order of keys to Change the order of the services in Unit screen
  static const List<String> allKeys = [
    restaurant,
    bank,
    parking,
    university,
    hospital,
    school,
    gym,
  ];

  static final Map<String, int> serviceBit = {
    restaurant: restaurantBit,
    bank: bankBit,
    parking: parkingBit,
    university: universityBit,
    hospital: hospitalBit,
    school: schoolBit,
    gym: gymBit,
  };

  static final Map<String, String> serviceIcon = {
    restaurant: ConstImages.restaurant,
    bank: ConstImages.bank,
    parking: ConstImages.parking,
    university: ConstImages.university,
    hospital: ConstImages.hospital,
    school: ConstImages.school,
    gym: ConstImages.gym,
  };

  static bool isServicesAvailable(String service, int msk) {
    return (msk & serviceBit[service]!) != 0;
  }

  static String getTitle(BuildContext context, String service) {
    final S lang = S.of(context);
    switch (service) {
      case restaurant:
        return lang.nearby_restaurant;
      case bank:
        return lang.nearby_bank;
      case parking:
        return lang.nearby_parking;
      case university:
        return lang.nearby_university;
      case hospital:
        return lang.nearby_hospital;
      case school:
        return lang.nearby_school;
      case gym:
        return lang.nearby_gym;
      default:
        return '';
    }
  }
}

class NearbyServicesModel extends Equatable {
  const NearbyServicesModel({
    required this.mask,
    required this.services,
  });

  final int mask;
  final Map<String, bool> services;

  int toMask() {
    int mask = 0;
    for (final e in services.entries) {
      if (e.value) {
        mask |= KNearbyServicesKeys.serviceBit[e.key]!;
      }
    }

    return mask;
  }

  // ignore: sort_constructors_first
  factory NearbyServicesModel.fromMask(int mask) {
    return NearbyServicesModel(
      mask: mask,
      services: Map.fromEntries(
        KNearbyServicesKeys.allKeys.map(
          (e) => MapEntry(e, KNearbyServicesKeys.isServicesAvailable(e, mask)),
        ),
      ),
    );
  }

  @override
  List<Object?> get props => [
        mask,
        services,
      ];
}
