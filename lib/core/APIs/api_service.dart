import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sakeny/core/constants/const_api.dart';
import 'package:sakeny/core/network/dio_client.dart';
import 'package:sakeny/core/network/interceptors/refresh_token_interceptor.dart';
import 'package:sakeny/core/services/service_locator.dart';

class ApiService {
  ApiService._();

  static final _dio = sl<DioClient>();

  // Get User Data
  static Future<Either> getUserData() async {
    try {
      if (kDebugMode) {
        print('🔍 Sending getUserData request');
      }

      final response = await _dio.get(
        ConstApi.getUserDataUrl,
        options: withAuth(),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('✅ getUserData succeeded');
        }
        return Right(response.data);
      } else {
        if (kDebugMode) {
          print('❌ getUserData failed with status: ${response.statusCode}');
        }
        return Left(response.data);
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ getUserData DioException: ${e.message}');
        print('Response: ${e.response}');
      }
      return Left(e.response?.toString() ?? e.toString());
    } catch (e) {
      if (kDebugMode) {
        print('❌ getUserData general exception: $e');
      }
      return Left(e.toString());
    }
  }

  // Test Refresh Token - for debugging purposes
  static Future<Either> testRefreshToken() async {
    try {
      if (kDebugMode) {
        print('🔍 Testing refresh token flow');
      }

      // This will trigger a 401 response which should initiate the refresh flow
      final response = await _dio.get(
        '/test-auth-endpoint',
        options: withAuth(),
      );

      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response?.toString() ?? e.toString());
    }
  }
}
