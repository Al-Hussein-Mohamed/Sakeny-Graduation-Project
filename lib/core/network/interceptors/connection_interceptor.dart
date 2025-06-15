import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sakeny/core/providers/settings_provider.dart';
import 'package:sakeny/core/services/service_locator.dart';

class ConnectionInterceptor extends Interceptor {
  final _settings = sl<SettingsProvider>();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (_isConnectionError(err)) {
      if (kDebugMode) {
        print('No internet connection detected by Dio interceptor.');
      }
      _settings.gotToConnectionLostScreen();
    }
    super.onError(err, handler);
  }

  bool _isConnectionError(DioException err) {
    if (err.type == DioExceptionType.connectionError || err.error is SocketException) {
      return true;
    }
    return false;
  }
}
