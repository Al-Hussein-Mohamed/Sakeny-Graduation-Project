import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakeny/core/constants/const_colors.dart';

class CustomTextTheme {
  CustomTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    titleLarge: TextStyle(
      fontSize: 22.spMin,
      fontWeight: FontWeight.w700,
      color: ConstColors.lightTextTitle,
    ),
    titleMedium: TextStyle(
      fontSize: 20.spMin,
      fontWeight: FontWeight.w700,
      color: ConstColors.lightTextTitle,
    ),
    titleSmall: TextStyle(
      fontSize: 16.spMin,
      fontWeight: FontWeight.w700,
      color: ConstColors.lightTextTitle,
    ),
    bodyLarge: TextStyle(
      fontSize: 18.spMin,
      fontWeight: FontWeight.w700,
      color: ConstColors.lightTextBody,
    ),
    bodyMedium: TextStyle(
      fontSize: 16.spMin,
      fontWeight: FontWeight.w700,
      color: ConstColors.lightTextBody,
    ),
    bodySmall: TextStyle(
      fontSize: 14.spMin,
      fontWeight: FontWeight.w500,
      color: ConstColors.lightTextBody,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    titleLarge: TextStyle(
      fontSize: 22.spMin,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    titleMedium: TextStyle(
      fontSize: 20.spMin,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    titleSmall: TextStyle(
      fontSize: 16.spMin,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    bodyLarge: TextStyle(
      fontSize: 18.spMin,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      fontSize: 16.spMin,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    bodySmall: TextStyle(
      fontSize: 14.spMin,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
  );
}
