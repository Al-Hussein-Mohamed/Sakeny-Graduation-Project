import 'package:flutter/material.dart';
import 'package:sakeny/core/services/navigation_service.dart';
import 'package:sakeny/core/services/service_locator.dart';
import 'package:sakeny/generated/l10n.dart';
import 'package:toastification/toastification.dart';

class ToastificationService {
  static final NavigationService _navigationService = sl<NavigationService>();

  static void showToast(
    BuildContext context,
    ToastificationType type,
    String title,
    String? description,
  ) {
    toastification.show(
      context: context,
      type: type,
      title: Text(title),
      description: description == null ? null : Text(description),
      primaryColor: Colors.white,
      autoCloseDuration: const Duration(seconds: 4),
      showProgressBar: true,
      backgroundColor: type == ToastificationType.success
          ? Colors.green
          : type == ToastificationType.info
              ? Colors.blue
              : type == ToastificationType.warning
                  ? Colors.orange
                  : Colors.red,
      foregroundColor: Colors.white,
    );
  }

  static void somethingWentWrong(BuildContext context) {
    final S lang = S.of(context);
    toastification.show(
      context: context,
      type: ToastificationType.error,
      title: Text(lang.toastErrorTitle),
      description: Text(lang.toastErrorMessage),
      primaryColor: Colors.white,
      autoCloseDuration: const Duration(seconds: 4),
      // progressBarTheme: ProgressIndicatorThemeData(
      //   color: type == ToastificationType.success
      //       ? Colors.green
      //       : type == ToastificationType.info
      //           ? Colors.blue
      //           : type == ToastificationType.warning
      //               ? Colors.orange
      //               : Colors.red,
      // ),
      showProgressBar: true,
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
    );
  }

  static void showErrorToast(BuildContext context, String message) {
    final S lang = S.of(context);
    toastification.show(
      context: context,
      type: ToastificationType.error,
      title: Text(lang.error),
      description: Text(message),
      primaryColor: Colors.white,
      autoCloseDuration: const Duration(seconds: 4),
      // progressBarTheme: ProgressIndicatorThemeData(
      //   color: type == ToastificationType.success
      //       ? Colors.green
      //       : type == ToastificationType.info
      //           ? Colors.blue
      //           : type == ToastificationType.warning
      //               ? Colors.orange
      //               : Colors.red,
      // ),
      showProgressBar: true,
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
    );
  }

  static void showSuccessToast(BuildContext context, String? message) {
    final S lang = S.of(context);
    toastification.show(
      context: context,
      type: ToastificationType.success,
      title: Text(lang.success),
      description: message == null ? null : Text(message),
      primaryColor: Colors.white,
      autoCloseDuration: const Duration(seconds: 4),
      showProgressBar: true,
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
    );
  }

  static void showGlobalToast(
    String title,
    String? description,
    ToastificationType type,
  ) {
    final context = _navigationService.navigatorKey.currentContext;
    if (context != null) {
      showToast(context, type, title, description);
    }
  }

  static void showGlobalErrorToast(String message) {
    final context = _navigationService.navigatorKey.currentContext;
    if (context != null) {
      showErrorToast(context, message);
    }
  }

  static void showGlobalSuccessToast(String? message) {
    final context = _navigationService.navigatorKey.currentContext;
    if (context != null) {
      showSuccessToast(context, message);
    }
  }

  static void showGlobalSomethingWentWrongToast() {
    final context = _navigationService.navigatorKey.currentContext;
    if (context != null) {
      somethingWentWrong(context);
    }
  }

  static void showGlobalGuestLoginToast() {
    final context = _navigationService.navigatorKey.currentContext;
    if (context == null) return;
    final S lang = S.of(context);

    showToast(
      context,
      ToastificationType.error,
      lang.toastPleaseLoginTitle,
      lang.toastPleaseLoginMessage,
    );
  }
}
