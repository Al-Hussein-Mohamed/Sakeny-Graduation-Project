import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.text,
    required this.primary,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.textFieldBorder,
    required this.myMessageBackground,
    required this.myMessageText,
    required this.otherMessageBackground,
    required this.otherMessageText,
    required this.unitBorder,
  });

  final Color text;
  final Color primary;
  final Color shimmerBase;
  final Color shimmerHighlight;

  // chat
  final Color textFieldBorder;
  final Color myMessageBackground;
  final Color myMessageText;
  final Color otherMessageBackground;
  final Color otherMessageText;

  // unit
  final Color unitBorder;

  static AppColors of(BuildContext context) {
    return Theme.of(context).extension<AppColors>()!;
  }

  @override
  ThemeExtension<AppColors> copyWith() {
    // TODO: implement copyWith
    throw UnimplementedError();
  }

  @override
  ThemeExtension<AppColors> lerp(covariant ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }

    return AppColors(
      text: Color.lerp(text, other.text, t) ?? text,
      primary: Color.lerp(primary, other.primary, t) ?? primary,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t) ?? shimmerBase,
      shimmerHighlight: Color.lerp(shimmerHighlight, other.shimmerHighlight, t) ?? shimmerHighlight,
      textFieldBorder: Color.lerp(textFieldBorder, other.textFieldBorder, t) ?? textFieldBorder,
      myMessageBackground:
          Color.lerp(myMessageBackground, other.myMessageBackground, t) ?? myMessageBackground,
      myMessageText: Color.lerp(myMessageText, other.myMessageText, t) ?? myMessageText,
      otherMessageBackground: Color.lerp(otherMessageBackground, other.otherMessageBackground, t) ??
          otherMessageBackground,
      otherMessageText: Color.lerp(otherMessageText, other.otherMessageText, t) ?? otherMessageText,
      unitBorder: Color.lerp(unitBorder, other.unitBorder, t) ?? unitBorder,
    );
  }
}
