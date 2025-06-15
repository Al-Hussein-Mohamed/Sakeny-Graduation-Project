import 'package:flutter/material.dart';

class ConstConfig {
  ConstConfig._();

  // physics
  static const ScrollPhysics scrollPhysics = BouncingScrollPhysics();

  // padding
  static const double screenHorizontalPadding = 16;
  static const double screenVerticalPadding = 22;
  static const EdgeInsets screenPadding =
      EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: screenVerticalPadding);

  static const EdgeInsets textFieldPadding = EdgeInsets.symmetric(horizontal: 7);

  // border radius
  static BorderRadius borderRadius = BorderRadius.circular(15);
  static BorderRadius smallBorderRadius = BorderRadius.circular(8);

  // icons
  static const double iconSize = 28;
  static const double smallIconSize = 20;

  // shadow
  static const Shadow shadow = Shadow(color: Colors.black38, offset: Offset(0, 3), blurRadius: 10);

  // Hero tags
  static const String selectLocationHeroTag = "select_location_hero_tag";
  static const String logoTag = "logo_tag";
  static const String authButtonTag = "button";
  static const String profilePicTag = "profile_pic_tag";
  static const String drawerIconTag = "drawer_icon_tag";

  // Durations
  static const Duration navigationDuration = Duration(milliseconds: 500);

  // Elevations
  static const double elevation = 5.0;
  static const double smallElevation = 3.0;
}
