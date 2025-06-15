import 'package:flutter/cupertino.dart';
import 'package:sakeny/generated/l10n.dart';

class Validator {
  static String? validateEmail(BuildContext context, String? value) {
    final lang = S.of(context);

    if (value == null || value.isEmpty) {
      return lang.validators_emailRequired;
    }

    final emailRegExp = RegExp(r'^[\w-/.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return lang.validators_invalidEmail;
    }

    return null;
  }

  static String? validatePassword(BuildContext context, String? value) {
    final lang = S.of(context);

    if (value == null || value.isEmpty) {
      return lang.validators_passwordRequired;
    }

    if (value.length < 6) {
      return lang.validators_passwordMinLength;
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return lang.validators_passwordUppercase;
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return lang.validators_passwordNumber;
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return lang.validators_passwordSpecialChar;
    }

    return null;
  }

  static String? validateLoginPassword(BuildContext context, String? value) {
    final lang = S.of(context);

    value = value?.trim();
    if (value == null || value.isEmpty) {
      return lang.validators_loginPasswordRequired;
    }

    return null;
  }

  static String? validatePhoneNumber(BuildContext context, String? value) {
    final lang = S.of(context);

    if (value == null || value.isEmpty) {
      return lang.validators_phoneRequired;
    }

    final phoneRegExp = RegExp(r'^\d{11}$');

    if (!phoneRegExp.hasMatch(value)) {
      return lang.validators_invalidPhone;
    }

    return null;
  }

  static String? validateName(BuildContext context, String? value) {
    final lang = S.of(context);

    value = value?.trim();
    if (value == null || value.isEmpty) {
      return lang.validators_nameRequired;
    }

    return null;
  }

  static String? validateOTPField(BuildContext context, String? value) {
    final lang = S.of(context);

    value = value?.trim();
    if (value == null || value.isEmpty) {
      return lang.validators_otpRequired;
    }

    return null;
  }

  static String? validateArea(BuildContext context, String? value) {
    final lang = S.of(context);

    // Check if empty
    if (value == null || value.trim().isEmpty) {
      return lang.validators_areaRequired;
    }

    int? areaValue;
    try {
      areaValue = int.parse(value.trim());
    } catch (e) {
      return lang.validatosrs_invalidArea;
    }

    // Check if area is reasonable
    if (areaValue <= 0) {
      return lang.validators_areaPositive;
    }

    if (areaValue > 1000) {
      return lang.validators_areaTooLarge;
    }

    return null;
  }

  static String? validateTitle(BuildContext context, String? value) {
    final lang = S.of(context);

    // Check if empty
    value = value?.trim();
    if (value == null || value.isEmpty) {
      return lang.validators_titleRequired;
    }

    // Check for minimum length
    if (value.length < 3) {
      return lang.validators_titleTooShort;
    }

    // Check for maximum length
    if (value.length > 100) {
      return lang.validators_titleTooLong;
    }

    return null;
  }

  static String? validateDescription(BuildContext context, String? value) {
    final lang = S.of(context);

    // Check if empty
    value = value?.trim();
    if (value == null || value.isEmpty) {
      return lang.validators_descriptionRequired;
    }

    // Check for minimum length
    if (value.length < 10) {
      return lang.validators_descriptionTooShort;
    }

    // Check for maximum length
    if (value.length > 500) {
      return lang.validators_descriptionTooLong;
    }

    return null;
  }

  static String? validatePrice(BuildContext context, String? value) {
    final lang = S.of(context);

    // Check if empty
    if (value == null || value.trim().isEmpty) {
      return lang.validators_priceRequired;
    }

    int? priceValue;
    try {
      priceValue = int.parse(value.trim());
    } catch (e) {
      return lang.validators_invalidPrice;
    }


    if (priceValue <= 0) {
      return lang.validators_pricePositive;
    }
    if (priceValue >= 2e15) {
      return lang.validators_priceTooLarge;
    }

    return null;
  }
}
