import 'package:flutter/material.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/theme/widget_themes/app_colors.dart';

class AppColorsScheme {
  AppColorsScheme._();

  static AppColors light = const AppColors(
    primary: ConstColors.primaryColor,
    text: ConstColors.primaryColor,
    shimmerBase: Color(0xFFE0E0E0),
    shimmerHighlight: Color(0xFFF5F5F5),
    textFieldBorder: ConstColors.primaryColor,
    myMessageBackground: Color(0xFF3D555D),
    myMessageText: Colors.white,
    otherMessageBackground: Color(0xFFE6E6E6),
    otherMessageText: Colors.black,
    unitBorder: Colors.grey,
  );

  static AppColors dark = const AppColors(
    primary: ConstColors.darkPrimary,
    text: Colors.white,
    shimmerBase: ConstColors.postShimmerBaseColorDark,
    shimmerHighlight: ConstColors.postShimmerHighLightColorDark,
    textFieldBorder: Colors.white,
    myMessageBackground: Color(0xFF3D555D),
    myMessageText: Colors.white,
    otherMessageBackground: Color(0xFF1F2E33),
    otherMessageText: Colors.white,
    unitBorder: Colors.white,
  );
}
