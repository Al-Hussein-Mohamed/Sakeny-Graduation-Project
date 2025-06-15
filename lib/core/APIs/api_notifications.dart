import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sakeny/core/constants/const_api.dart';
import 'package:sakeny/core/network/dio_client.dart';
import 'package:sakeny/core/network/interceptors/refresh_token_interceptor.dart';
import 'package:sakeny/core/services/service_locator.dart';
import 'package:sakeny/features/notifications/models/notificatnion_model.dart';

class ApiNotifications {
  ApiNotifications._();

  static final _dio = sl<DioClient>();

  static Future<Either> addDeviceToken({
    required String deviceToken,
    required String userId,
  }) async {
    try {
      final response = await _dio.post(
        ConstApi.addDeviceTokenUrl,
        data: {
          "deviceToken": deviceToken,
          "userId": userId,
        },
      );

      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return Left(response.data.toString());
      }
    } on DioException catch (e) {
      return Left(e.response?.data.toString());
    }
  }

  static Future<Either> removeDeviceToken({
    required String deviceToken,
    required String userId,
  }) async {
    try {
      final response = await sl<DioClient>().delete(
        ConstApi.deleteDeviceTokenUrl,
        queryParameters: {
          "DeviceToken": deviceToken,
          "UserId": userId,
        },
      );

      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return Left(response.data.toString());
      }
    } on DioException catch (e) {
      return Left(e.response?.data.toString());
    }
  }

  static Future<Either> getAllNotifications({required int pageIndex, required int pageSize}) async {
    try {
      final response = await _dio.get(
        ConstApi.getAllNotificationsUrl,
        queryParameters: {
          "PageIndex": pageIndex,
          "PageSize": pageSize,
        },
        options: withAuth(),
      );

      if (response.statusCode == 200) {
        final jsonList = response.data as List;
        return Right(jsonList.map((json) => NotificationModel.fromJson(json)).toList());
      } else {
        return Left(response.data.toString());
      }
    } on DioException catch (e) {
      return Left(e.response?.data.toString());
    }
  }
}
