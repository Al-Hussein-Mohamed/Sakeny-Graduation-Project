import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:sakeny/core/APIs/api_auth_services.dart';
import 'package:sakeny/core/constants/const_api.dart';
import 'package:sakeny/core/network/dio_client.dart';
import 'package:sakeny/core/network/interceptors/logger_interceptors.dart';
import 'package:sakeny/core/providers/settings_provider.dart';
import 'package:sakeny/core/routing/page_route_name.dart';
import 'package:sakeny/core/services/navigation_service.dart';
import 'package:sakeny/core/services/notificaion_services/push_notifications_service.dart';
import 'package:sakeny/core/services/overlays/toastification_service.dart';
import 'package:sakeny/core/services/service_locator.dart';
import 'package:sakeny/generated/l10n.dart';
import 'package:toastification/toastification.dart';

Options withAuth([Options? base]) {
  return (base ?? Options()).copyWith(
    extra: {...(base?.extra ?? {}), 'auth': true},
  );
}

class RefreshTokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final auth = (options.extra['auth'] ?? false) == true;

    if (auth) {
      final accessToken = sl<SettingsProvider>().accessToken;
      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
        if (kDebugMode) {
          print('Adding auth header to ${options.path}');
        }
      } else {
        if (kDebugMode) {
          print('Warning: Auth required for ${options.path} but no token available');
        }
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && err.requestOptions.extra['auth'] == true) {
      final dio = sl<DioClient>();
      final settings = sl<SettingsProvider>();
      final accessToken = settings.accessToken;
      final refreshToken = settings.refreshToken;

      if (kDebugMode) {
        print('🔑 Received 401 error, attempting token refresh');
        print('Access token: ${accessToken?.toString()}...');
        print('Refresh token: ${refreshToken?.toString()}...');
      }

      // Check if we have a refresh token to use
      if (refreshToken == null || refreshToken.isEmpty) {
        // No refresh token available, can't refresh
        if (kDebugMode) {
          print('❌ No refresh token available, cannot refresh auth token');
        }
        _handleAuthFailure('Session expired. Please log in again.');
        return handler.next(err);
      }

      try {
        if (kDebugMode) {
          print('🔄 Attempting to refresh token...');
        }

        // Create a separate Dio instance for token refresh to avoid interceptors
        final tokenDio = Dio(
          BaseOptions(
            baseUrl: dio.raw.options.baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            contentType: 'application/json',
          ),
        )..interceptors.addAll([LoggerInterceptor()]);

        // Ensure the refresh endpoint is correctly formatted
        // if (kDebugMode) {
        //   print(
        //     '📤 Refresh data: { "accessToken": "${accessToken?.toString()}...", "refreshToken": "${refreshToken.toString()}..." }',
        //   );
        // }

        final refreshResponse = await tokenDio.post(
          ConstApi.refreshTokenUrl,
          data: {
            "accessToken": accessToken,
            "refreshToken": refreshToken,
          },
        );

        if (kDebugMode) {
          print('📥 Refresh response status: ${refreshResponse.statusCode}');
          print('📥 Refresh response headers: ${refreshResponse.headers}');
          print('📥 Refresh response request: ${refreshResponse.requestOptions}');
          print('📥 Refresh response data: ${refreshResponse.data}');
        }

        if (refreshResponse.statusCode != 200 || refreshResponse.data == null) {
          if (kDebugMode) {
            print('❌ Token refresh failed with status: ${refreshResponse.statusCode}');
          }
          _handleAuthFailure('Session expired. Please log in again.');
          return handler.next(err);
        }

        final newAccessToken = refreshResponse.data['accessToken'];
        final newRefreshToken = refreshResponse.data['refreshToken'];

        if (newAccessToken == null || newRefreshToken == null) {
          if (kDebugMode) {
            print('❌ Invalid refresh response: missing tokens');
            print('Response data: ${refreshResponse.data}');
          }
          _handleAuthFailure('Authentication failed. Please log in again.');
          return handler.next(err);
        }

        if (kDebugMode) {
          print('✅ Token refresh successful. Updating tokens...');
          print('New access token: ${newAccessToken.toString()}...');
          print('New refresh token: ${newRefreshToken.toString()}...');
        }

        settings.setToken(newAccessToken, newRefreshToken, null, null);

        // Retry the original request with new token
        final updatedRequestOptions = err.requestOptions;
        updatedRequestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

        if (kDebugMode) {
          print('🔄 Retrying original request to ${updatedRequestOptions.path}');
        }

        final clonedRequest = await dio.raw.fetch(updatedRequestOptions);
        return handler.resolve(clonedRequest);
      } catch (e) {
        if (kDebugMode) {
          print('❌ Error refreshing token: $e');
        }
        _handleAuthFailure('Authentication error. Please log in again.');
        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  void _handleAuthFailure(String message) {
    if (kDebugMode) {
      print('🚨 Handling auth failure: $message');
    }
    sl<SettingsProvider>().clearToken();
    ApiAuthServices.googleSignOut();

    Future.microtask(() {
      final navigator = sl<NavigationService>();
      final context = navigator.navigatorKey.currentContext;
      if (context == null || !context.mounted) return;

      final S lang = S.of(context);
      ToastificationService.showToast(
        context,
        ToastificationType.error,
        lang.sessionExpiredTitle,
        lang.sessionExpiredMessage,
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        PageRouteNames.login,
        (route) => false,
      );

      PushNotificationsService.removeDeviceToken();
    });
  }
}
