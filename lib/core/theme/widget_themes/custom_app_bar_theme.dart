import 'package:flutter/material.dart';
import 'package:sakeny/core/constants/const_colors.dart';

class CustomAppBarTheme {
  static const double _appBarHeight = 68;

  static AppBarTheme lightAppBarTheme = const AppBarTheme(
    backgroundColor: ConstColors.primaryColor,
    foregroundColor: Colors.white,
    toolbarHeight: _appBarHeight,
    titleSpacing: 0,
  );

  static AppBarTheme darkAppBarTheme = const AppBarTheme(
    backgroundColor: ConstColors.primaryColor,
    foregroundColor: Colors.white,
    toolbarHeight: _appBarHeight,
    titleSpacing: 0,
  );
}
