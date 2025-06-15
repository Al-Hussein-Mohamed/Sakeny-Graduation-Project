import 'package:flutter/material.dart';
import 'package:sakeny/core/constants/const_colors.dart';

class CustomIconTheme {
  CustomIconTheme._();

  static const IconThemeData lightIconTheme = IconThemeData(
    color: ConstColors.primaryColor,
    size: 24,
  );

  static const IconThemeData darkIconTheme = IconThemeData(
    color: Colors.white,
    size: 24,
  );
}
