import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sakeny/core/providers/settings_provider.dart';
import 'package:sakeny/core/routing/page_route_name.dart';
import 'package:sakeny/core/services/service_locator.dart';

class TokenManager {
  static final SettingsProvider _settings = sl<SettingsProvider>();

  static bool get hasValidAccessToken =>
      _settings.accessToken != null && _settings.accessToken!.isNotEmpty;

  static bool get hasValidRefreshToken =>
      _settings.refreshToken != null && _settings.refreshToken!.isNotEmpty;

  static void debugTokenStatus() {
    if (kDebugMode) {
      print('Token Status:');
      print('Has Access Token: ${hasValidAccessToken}');
      print('Has Refresh Token: ${hasValidRefreshToken}');
      if (hasValidAccessToken) {
        print('Access Token prefix: ${_settings.accessToken!.substring(0, 10)}...');
      }
      if (hasValidRefreshToken) {
        print('Refresh Token prefix: ${_settings.refreshToken!.substring(0, 10)}...');
      }
    }
  }

  static void clearTokens() {
    _settings.clearToken();
    if (kDebugMode) {
      print('Tokens have been cleared');
    }
  }

  // Handle token failure by redirecting to login screen
  static void handleTokenFailure(BuildContext context) {
    clearTokens();

    // Navigate to login screen
    Navigator.of(context).pushNamedAndRemoveUntil(
      PageRouteNames.login,
      (route) => false,
    );

    // Show a snackbar to inform the user
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Session expired. Please log in again.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

// ...existing TokenDebugScreen code...
