import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakeny/core/constants/const_colors.dart';

class CustomElevatedButtonTheme {
  CustomElevatedButtonTheme._();

  static ElevatedButtonThemeData lightElevatedButtonTheme(bool isEn) => ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: ConstColors.primaryColor,
          // disabledForegroundColor: Colors.grey,
          // disabledBackgroundColor: Colors.grey,
          // side: const BorderSide(color: Colors.blue),
          // padding: const EdgeInsets.symmetric(vertical: 10),
          textStyle: TextStyle(
            fontFamily: isEn ? "Lato" : "Tajawal",
            fontSize: 20.spMin,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          minimumSize: Size(double.infinity, 50.h),
        ),
      );

  static ElevatedButtonThemeData darkElevatedButtonTheme(bool isEn) => ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: ConstColors.onScaffoldBackgroundDark,
          // disabledForegroundColor: Colors.grey,
          // disabledBackgroundColor: Colors.grey,
          // side: const BorderSide(color: Colors.blue),
          // padding: const EdgeInsets.symmetric(vertical: 10),
          textStyle: TextStyle(
            fontFamily: isEn ? "Lato" : "Tajawal",
            fontSize: 20.spMin,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          minimumSize: Size(double.infinity, 50.h),
        ),
      );
}
