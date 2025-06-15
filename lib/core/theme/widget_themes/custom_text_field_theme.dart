import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakeny/core/constants/const_colors.dart';

class CustomTextFieldTheme {
  CustomTextFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: ConstColors.lightInputFieldIcon,
    suffixIconColor: ConstColors.lightInputFieldIcon,
    floatingLabelStyle: TextStyle(
      fontSize: 22.spMin,
      fontWeight: FontWeight.w600,
      color: ConstColors.lightInputField,
    ),
    labelStyle: TextStyle(
      fontSize: 18.spMin,
      fontWeight: FontWeight.w600,
      color: ConstColors.lightInputField,
    ),
    hintStyle: TextStyle(
      fontSize: 14.spMin,
      fontWeight: FontWeight.w400,
      color: ConstColors.lightInputFieldHint,
    ),
    errorStyle: TextStyle(
      fontSize: 14.spMin,
      fontWeight: FontWeight.w500,
      color: ConstColors.lightWrongInputField,
    ),
    floatingLabelBehavior: FloatingLabelBehavior.always,
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: ConstColors.lightInputField),
      borderRadius: BorderRadius.circular(10.r),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: ConstColors.lightInputField),
      borderRadius: BorderRadius.circular(10.r),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: ConstColors.lightInputField),
      borderRadius: BorderRadius.circular(10.r),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: ConstColors.lightInputField, width: 2.0),
      borderRadius: BorderRadius.circular(10.r),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: ConstColors.lightWrongInputField, width: 2.0),
      borderRadius: BorderRadius.circular(10.r),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: ConstColors.lightWrongInputField, width: 2.0),
      borderRadius: BorderRadius.circular(10.r),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    fillColor: ConstColors.onScaffoldBackgroundDark,
    filled: true,
    prefixIconColor: Colors.white,
    suffixIconColor: Colors.white,
    floatingLabelStyle: TextStyle(
      fontSize: 22.spMin,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    labelStyle: TextStyle(
      fontSize: 18.spMin,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    hintStyle: TextStyle(
      fontSize: 14.spMin,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    errorStyle: TextStyle(
      fontSize: 14.spMin,
      fontWeight: FontWeight.w500,
      color: ConstColors.darkWrongInputField,
    ),
    floatingLabelBehavior: FloatingLabelBehavior.always,
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(10.r),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(10.r),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(10.r),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white, width: 2.0),
      borderRadius: BorderRadius.circular(10.r),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: ConstColors.darkWrongInputField, width: 2.0),
      borderRadius: BorderRadius.circular(10.r),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: ConstColors.darkWrongInputField, width: 2.0),
      borderRadius: BorderRadius.circular(10.r),
    ),
  );
}
