import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sakeny/core/constants/const_enum.dart';
import 'package:sakeny/features/unit/models/nearby_services_model.dart';
import 'package:sakeny/features/unit/models/service_model.dart';

part 'apartment_and_house_rental.dart';
part 'apartment_and_house_sale.dart';
part 'room_rental.dart';

class KUnitJsonKeys {
  static const String unitId = "id";
  static const String unitType = "unitType";
  static const String title = "title";
  static const String description = "description";
  static const String address = "address";
  static const String unitPicturesUrls = "picutresUrl";
  static const String price = "price";
  static const String unitArea = "unitArea";
  static const String unitRate = "rate";
  static const String unitRateCount = "countRated";
  static const String bathRoomCount = "bathRoomCount";
  static const String floor = "floor";
  static const String isRented = "isRented";
  static const String isFurnished = "isFurnished";
  static const String isFavorite = "isFavorite";
  static const String location = "location";
  static const String latitude = "latitude";
  static const String longitude = "longitude";
  static const String nearbyServices = "nearbyServices";
  static const String services = "unitServices";
  static const String gender = "genderType";
  static const String ownerId = "ownerId";
  static const String ownerName = "ownerName";
  static const String ownerRate = "userRate";
  static const String ownerRateCount = "userCountRated";
  static const String visitorRate = "vistorRate";
  static const String ownerProfilePictureUrl = "userPicture";
  static const String ownerLocationLatitude = "userLatitude";
  static const String ownerLocationLongitude = "userLongitude";
  static const String numberOfRooms = "roomsCount";
  static const String numberOfBeds = "bedRoomCount";
  static const String rentalFrequency = "rentalFrequency";
}

@immutable
sealed class UnitModel {
  const UnitModel({
    required this.unitId,
    required this.unitType,
    required this.title,
    required this.description,
    required this.address,
    required this.date,
    required this.unitPicturesUrls,
    required this.price,
    required this.unitArea,
    required this.unitRate,
    required this.unitRateCount,
    required this.visitorRate,
    required this.bathRoomCount,
    required this.floor,
    required this.isRented,
    required this.isFurnished,
    required this.isFavorite,
    required this.location,
    required this.nearbyServices,
    required this.services,
    required this.gender,
    required this.ownerId,
    required this.ownerName,
    required this.ownerRate,
    required this.ownerRateCount,
    required this.ownerProfilePictureUrl,
    required this.ownerLocation,
  });

  // unit
  final int unitId;
  final UnitType unitType;
  final String title;
  final String description;
  final String address;
  final DateTime date;

  final List<String> unitPicturesUrls;
  final num price;
  final num unitArea;
  final num unitRate;
  final int unitRateCount;
  final int bathRoomCount;
  final int floor;
  final bool isRented;
  final bool isFurnished;
  final bool isFavorite;
  final LatLng location;
  final NearbyServicesModel nearbyServices;
  final ServicesModel services;
  final Gender gender;

  // owner
  final String ownerId;
  final String ownerName;
  final num ownerRate;
  final int ownerRateCount;
  final String? ownerProfilePictureUrl;
  final LatLng ownerLocation;

  final num? visitorRate;

  static UnitModel fromJson(Map<String, dynamic> json) {
    final UnitType type = UnitType.get(json[KUnitJsonKeys.unitType] as String);

    switch (type) {
      case UnitType.roomRental:
        return RoomRental.fromJson(json);

      case UnitType.studentHousing:
        return ApartmentAndHouseRental.fromJson(json);

      case UnitType.apartmentRent:
        return ApartmentAndHouseRental.fromJson(json);

      case UnitType.apartmentSale:
        return ApartmentAndHouseSale.fromJson(json);

      case UnitType.houseRental:
        return ApartmentAndHouseRental.fromJson(json);

      case UnitType.houseSale:
        return ApartmentAndHouseSale.fromJson(json);
    }
  }

  UnitModel copyWith({num? visitorRate, bool? isRented});
}
