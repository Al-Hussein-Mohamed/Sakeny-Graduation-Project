import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sakeny/features/filters/models/filters_parameters_model.dart';

part 'filters_state.dart';

class FiltersCubit extends Cubit<FiltersState> {
  FiltersCubit() : super(FiltersInitial());
  final scaffoldKeyFilters = GlobalKey<ScaffoldState>();

  final TextEditingController areaMinController = TextEditingController();
  final TextEditingController priceMinController = TextEditingController();
  final TextEditingController areaMaxController = TextEditingController();
  final TextEditingController priceMaxController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String? unitType;
  String? rentFrequency;
  String? furnished;
  double? latitude;
  double? longtitude;
  double? minPrice;
  double? maxPrice;
  double? minArea;
  double? maxArea;
  bool? isFurnished;
  int? level;
  int? beds;
  int? bathrooms;
  int? rooms;
  String? gender;
  String? purpose;
  LatLng? location;

  void updateRentFrequency(String? value) {
    rentFrequency = value;
    log(rentFrequency!);
  }

  void updateFurnishedStatus(String? value) {
    furnished = value;
    if (value == "furnished") {
      isFurnished = true;
      log(value!);
    } else if (value == "unfurnished") {
      isFurnished = false;
      log(value!);
    } else {
      isFurnished = null;
      log(value!);
    }
  }

  void updateLevel(int? value) {
    level = value;
    log(level.toString());
  }

  void updateBeds(int? value) {
    beds = value;
    log(beds.toString());
  }

  void updateBathrooms(int? value) {
    bathrooms = value;
    log(bathrooms.toString());
  }

  void updateRooms(int? value) {
    rooms = value;
    log(rooms.toString());
  }

  void updateGender(String? value) {
    gender = value;
    log(gender.toString());
  }

  void updatePurpose(String? value) {
    purpose = value;
    log(purpose.toString());
  }

  void updateLocation(LatLng? newLocation, String? address) {
    location = newLocation;
    addressController.text = address ?? "";
  }

  void resetFilters() {
    // Reset all filter values to defaults
    unitType = null;
    rentFrequency = null;
    furnished = null;
    latitude = null;
    longtitude = null;
    minPrice = null;
    maxPrice = null;
    minArea = null;
    maxArea = null;
    isFurnished = null;
    level = null;
    beds = null;
    bathrooms = null;
    rooms = null;
    gender = null;
    purpose = null;
    location = null;

    // Clear text controllers
    areaMinController.clear();
    priceMinController.clear();
    areaMaxController.clear();
    priceMaxController.clear();
    addressController.clear();
  }

  bool hasAnyFilterApplied() {
    return unitType != null ||
        rentFrequency != null ||
        furnished != null ||
        latitude != null ||
        longtitude != null ||
        minPrice != null ||
        maxPrice != null ||
        minArea != null ||
        maxArea != null ||
        isFurnished != null ||
        level != null ||
        beds != null ||
        bathrooms != null ||
        rooms != null ||
        gender != null ||
        purpose != null ||
        location != null ||
        (areaMinController.text.isNotEmpty && areaMaxController.text.isNotEmpty) ||
        (priceMinController.text.isNotEmpty && priceMaxController.text.isNotEmpty);
  }

  FiltersParametersModel getFiltersParams() {
    final bool? isFurnishedParam = furnished == "furnished"
        ? true
        : furnished == "unfurnished"
            ? false
            : null;
    return FiltersParametersModel(
      unitType: unitType,
      latitude: location?.latitude,
      longitude: location?.longitude,
      minPrice: double.tryParse(priceMinController.text),
      maxPrice: double.tryParse(priceMaxController.text),
      minArea: double.tryParse(areaMinController.text),
      maxArea: double.tryParse(areaMaxController.text),
      rentFrequency: rentFrequency,
      isFurnished: isFurnishedParam,
      level: level,
      beds: beds,
      bathrooms: bathrooms,
      rooms: rooms,
      gender: gender,
      purpose: purpose,
    );
  }

  void openDrawerFilter() {
    //open the drawer for the filter screen
    if (scaffoldKeyFilters.currentState != null) {
      scaffoldKeyFilters.currentState!.openEndDrawer();
    }
  }

  void closeDrawerFilter() {
    //close the drawer for the filter screen
    if (scaffoldKeyFilters.currentState != null) {
      scaffoldKeyFilters.currentState!.closeEndDrawer();
    }
  }

  @override
  Future<void> close() async {
    areaMinController.dispose();
    priceMinController.dispose();
    areaMaxController.dispose();
    priceMaxController.dispose();
    super.close();
  }
}
