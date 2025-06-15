import 'package:flutter/material.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/providers/settings_provider.dart';
import 'package:sakeny/core/services/service_locator.dart';
import 'package:sakeny/core/theme/widget_themes/app_colors_scheme.dart';
import 'package:sakeny/core/theme/widget_themes/custom_app_bar_theme.dart';
import 'package:sakeny/core/theme/widget_themes/custom_color_scheme.dart';
import 'package:sakeny/core/theme/widget_themes/custom_elevated_button_theme.dart';
import 'package:sakeny/core/theme/widget_themes/custom_icon_theme.dart';
import 'package:sakeny/core/theme/widget_themes/custom_text_field_theme.dart';
import 'package:sakeny/core/theme/widget_themes/custom_text_theme.dart';
import 'package:sakeny/core/utils/Bilingual_text/Bilingual_text_theme_extension.dart';

class AppTheme {
  AppTheme._();

  static final SettingsProvider _settings = sl<SettingsProvider>();

  // Default font for the app UI
  static const String _defaultFontFamily = "Lato";

  static const double fontHeight = 1.0;
  static const double arabicFontHeight = .9;

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: _defaultFontFamily,
    brightness: Brightness.light,
    primaryColor: ConstColors.primaryColor,
    scaffoldBackgroundColor: ConstColors.scaffoldBackground,
    iconTheme: CustomIconTheme.lightIconTheme,
    // listTileTheme: ,
    textTheme: CustomTextTheme.lightTextTheme.bilingual,
    appBarTheme: CustomAppBarTheme.lightAppBarTheme,
    colorScheme: CustomColorScheme.lightColorScheme,
    inputDecorationTheme: CustomTextFieldTheme.lightInputDecorationTheme,
    elevatedButtonTheme: CustomElevatedButtonTheme.lightElevatedButtonTheme(_settings.isEn),
    extensions: [
      AppColorsScheme.light,
    ],
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: _defaultFontFamily,
    brightness: Brightness.dark,
    primaryColor: ConstColors.primaryColor,
    scaffoldBackgroundColor: ConstColors.scaffoldBackgroundDark,
    iconTheme: CustomIconTheme.darkIconTheme,
    textTheme: CustomTextTheme.darkTextTheme.bilingual,
    appBarTheme: CustomAppBarTheme.darkAppBarTheme,
    colorScheme: CustomColorScheme.darkColorScheme,
    inputDecorationTheme: CustomTextFieldTheme.darkInputDecorationTheme,
    elevatedButtonTheme: CustomElevatedButtonTheme.darkElevatedButtonTheme(_settings.isEn),
    extensions: [
      AppColorsScheme.dark,
    ],
  );
}
