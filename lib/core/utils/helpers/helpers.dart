import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/constants/const_enum.dart';
import 'package:sakeny/core/providers/settings_provider.dart';
import 'package:sakeny/core/services/service_locator.dart';
import 'package:sakeny/features/unit/models/unit_model/unit_model.dart';

Future<bool> isPhysicalDevice() async {
  final deviceInfo = DeviceInfoPlugin();

  if (defaultTargetPlatform == TargetPlatform.android) {
    final androidInfo = await deviceInfo.androidInfo;
    return androidInfo.isPhysicalDevice;
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    final iosInfo = await deviceInfo.iosInfo;
    return iosInfo.isPhysicalDevice;
  }

  return false; // Fallback for web/desktop
}

Future<File?> pickImageFromGallery() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}

Future<File?> pickImageFromCamera() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.camera);
  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}

String getMonthName(int month) {
  final SettingsProvider settings = sl<SettingsProvider>();
  const englishMonthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  const arabicMonthNames = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];

  return settings.isEn ? englishMonthNames[month - 1] : arabicMonthNames[month - 1];
}

Color getColor(context, Color light, Color dark) {
  return Theme.of(context).brightness == Brightness.light ? light : dark;
}

Color getTextColor(context) {
  return Theme.of(context).brightness == Brightness.light ? ConstColors.primaryColor : Colors.white;
}

RentFrequency? getRentFrequencyByUnitModel(UnitModel unit) {
  switch (unit) {
    case RoomRental():
      return unit.rentalFrequency;
    case ApartmentAndHouseRental():
      return unit.rentalFrequency;
    case ApartmentAndHouseSale():
      return null;
  }
}

int? getBedCountByUnitModel(UnitModel unit) {
  switch (unit) {
    case RoomRental():
      return unit.numberOfBeds;
    case ApartmentAndHouseRental():
      return null;
    case ApartmentAndHouseSale():
      return null;
  }
}

int? getRoomCountByUnitModel(UnitModel unit) {
  switch (unit) {
    case RoomRental():
      return null;
    case ApartmentAndHouseRental():
      return unit.numberOfRooms;
    case ApartmentAndHouseSale():
      return unit.numberOfRooms;
  }
}
