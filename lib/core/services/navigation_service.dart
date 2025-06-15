import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  NavigatorState? get navigator => navigatorKey.currentState;

  ScaffoldMessengerState? get scaffoldMessenger => scaffoldMessengerKey.currentState;

  Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    if (navigator == null) {
      throw Exception('Navigator is not available');
    }
    return navigator!.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pop() async {
    if (navigator == null) {
      throw Exception('Navigator is not available');
    }
    return navigator!.pop();
  }

  Future<dynamic> navigateToAndRemoveUntil(String routeName, {Object? arguments}) {
    if (navigator == null) {
      throw Exception('Navigator is not available');
    }
    return navigator!.pushNamedAndRemoveUntil(
      routeName,
      (Route<dynamic> route) => false,
      arguments: arguments,
    );
  }

  void showErrorSnackBar(String message) {
    scaffoldMessenger?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void showSuccessSnackBar(String message) {
    scaffoldMessenger?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
