import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sakeny/core/constants/const_enum.dart';
import 'package:sakeny/features/unit/models/nearby_services_model.dart';
import 'package:sakeny/features/unit/models/service_model.dart';

class AddEstateParams {
  const AddEstateParams({
    required this.unitType,
    required this.title,
    required this.description,
    required this.area,
    required this.price,
    required this.floor,
    required this.bathrooms,
    required this.location,
    required this.address,
    required this.isFurnished,
    required this.images,
    required this.gender,
    required this.nearbyServices,
    required this.services,
    required this.rooms,
    required this.beds,
    required this.rentalFrequency,
  });

  final UnitType unitType;
  final String title;
  final String description;
  final num area;
  final num price;
  final int floor;
  final int bathrooms;
  final LatLng location;
  final String address;
  final bool isFurnished;
  final List<XFile> images;
  final Gender gender;
  final NearbyServicesModel nearbyServices;
  final ServicesModel services;

  final int? rooms;
  final int? beds;
  final RentFrequency? rentalFrequency;

  Future<Map<String, dynamic>> toJson() async {
    final List<MultipartFile> imageFiles = await Future.wait(
      images.map((xFile) async => await MultipartFile.fromFile(xFile.path, filename: xFile.name)),
    );

    return {
      'UnitType': unitType.toJson(),
      'Title': title,
      'Description': description,
      'Area': area,
      'Price': price,
      'Floor': floor,
      'BathRoomCount': bathrooms,
      'Location.Latitude': location.latitude,
      'Location.Longitude': location.longitude,
      'Address': address,
      'IsFurnished': isFurnished,
      'Pictures': imageFiles,
      'GenderType': gender.toJson(),
      'NearbyServices': nearbyServices.toMask(),
      'UnitServices': services.toMask(),
      'RoomsCount': rooms,
      'BedRoomCount': beds,
      'RentalFrequency': rentalFrequency?.toJson(),
    };
  }
}
