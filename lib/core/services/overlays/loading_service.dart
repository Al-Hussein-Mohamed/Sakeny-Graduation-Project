import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sakeny/core/constants/const_colors.dart';

void configEasyLoading(bool isDark) {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..maskType = EasyLoadingMaskType.black
    ..backgroundColor = isDark ? const Color(0xFF141922) : Colors.white
    ..textColor = isDark ? Colors.white : ConstColors.primaryColor
    ..indicatorColor = isDark ? Colors.white : ConstColors.primaryColor
    ..userInteractions = false
    ..dismissOnTap = false
    ..contentPadding = const EdgeInsets.all(24)
    ..displayDuration = const Duration(seconds: 1)
    ..animationDuration = const Duration(milliseconds: 400)
    ..animationStyle = EasyLoadingAnimationStyle.offset;
}
