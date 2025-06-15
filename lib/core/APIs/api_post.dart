import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sakeny/core/constants/const_api.dart';
import 'package:sakeny/core/network/dio_client.dart';
import 'package:sakeny/core/network/interceptors/refresh_token_interceptor.dart';
import 'package:sakeny/core/services/service_locator.dart';
import 'package:sakeny/features/addrealstate/models/add_estate_params.dart';
import 'package:sakeny/features/filters/models/filters_parameters_model.dart';
import 'package:sakeny/features/post/comments/models/comment_model.dart';
import 'package:sakeny/features/post/posts/models/post_model.dart';
import 'package:sakeny/features/unit/models/reportModel.dart';

class ApiPost {
  ApiPost._();

  static final DioClient _dioClient = sl<DioClient>();

  static Future<Either> getPosts({
    required int pageCount,
    required int pageSize,
    String? userId,
  }) async {
    try {
      final response = await sl<DioClient>().get(
        ConstApi.getPostsUrl,
        queryParameters: {
          "PageIndex": pageCount,
          "PageSize": pageSize,
          "UserId": userId,
        },
      );

      if (response.statusCode == 200) {
        final jsonList = response.data["data"] as List;
        return Right(jsonList.map((e) => PostModel.fromJson(e)).toList());
      } else {
        return Left(response.data);
      }
    } on DioException catch (e) {
      return Left(e.response!.data);
    }
  }

  static Future<Either> getPostsByUser({
    required String userId,
    required int pageSize,
    required int pageCount,
  }) async {
    try {
      final response = await _dioClient.get(
        ConstApi.getPostsByUserUrl,
        queryParameters: {
          "UserId": userId,
          "pageSize": pageSize,
          "PageIndex": pageCount,
        },
        options: withAuth(),
      );

      if (response.statusCode == 200) {
        final jsonList = response.data["data"] as List;
        return Right(jsonList.map((e) => PostModel.fromJson(e)).toList());
      } else {
        return Left(response.data.toString());
      }
    } on DioException catch (e) {
      return Left(e.response!.data.toString());
    }
  }

  static Future<Either> addLikeToPost({required int postId}) async {
    try {
      final response = await sl<DioClient>().post(
        ConstApi.addLikeUrl,
        options: withAuth(),
        data: {
          "postId": postId,
        },
      );

      if (response.statusCode == 200) {
        return Right(response.data);
      } else {
        return Left("error: data ${response.data}");
      }
    } on DioException catch (e) {
      return Left(e.response!.data.toString());
    }
  }

  static Future<Either> removeLikeFromPost({required int postId}) async {
    try {
      final response = await sl<DioClient>().delete(
        ConstApi.removeLikeUrl,
        options: withAuth(),
        data: {
          "postId": postId,
        },
      );

      if (response.statusCode == 200) {
        return Right(response.data);
      } else {
        return Left("error: data ${response.data}");
      }
    } on DioException catch (e) {
      return Left(e.response!.data.toString());
    }
  }

  static Future<Either> addPostToFavorites({required int postId}) async {
    try {
      final response = await _dioClient.post(
        ConstApi.addToFavoritesUrl,
        data: {
          "PostId": postId,
        },
        options: withAuth(),
      );

      if (response.statusCode == 200) {
        return Right(response.data);
      } else {
        return Left("error: data ${response.data}");
      }
    } on DioException catch (e) {
      return Left(e.response!.data.toString());
    }
  }

  static Future<Either> removePostFromFavorites({required int postId}) async {
    try {
      final response = await _dioClient.delete(
        ConstApi.removeFromFavoritesUrl,
        data: {
          "PostId": postId,
        },
        options: withAuth(),
      );

      if (response.statusCode == 200) {
        return Right(response.data);
      } else {
        return Left("error: data ${response.data}");
      }
    } on DioException catch (e) {
      return Left(e.response!.data.toString());
    }
  }

  static Future<Either> getFavoritesList({required int pageSize, required int pageIndex}) async {
    try {
      final response = await _dioClient.get(
        ConstApi.getFavoritesUrl,
        queryParameters: {
          "PageSize": pageSize,
          "PageIndex": pageIndex,
        },
        options: withAuth(),
      );

      if (response.statusCode == 200) {
        final jsonList = response.data["data"] as List;
        return Right(jsonList.map((e) => PostModel.fromJson(e)).toList());
      } else {
        return Left("error: data ${response.data}");
      }
    } on DioException catch (e) {
      return Left(e.response!.data.toString());
    }
  }

  static Future<Either> getAllComments({
    required postId,
    required pageSize,
    required pageCount,
  }) async {
    try {
      final response = await _dioClient.get(
        ConstApi.getPostCommentsUrl,
        options: withAuth(),
        queryParameters: {
          "PostId": postId,
          "pageSize": pageSize,
          "PageIndex": pageCount,
        },
      );

      if (response.statusCode == 200) {
        final jsonList = response.data["data"] as List;
        return Right(jsonList.map((e) => CommentModel.fromJson(e)).toList());
      } else {
        return Left("error: data ${response.data}");
      }
    } on DioException catch (e) {
      return Left(e.response!.data.toString());
    }
  }

  static Future<Either> addComment({required int postId, required String content}) async {
    try {
      final response = await _dioClient.post(
        ConstApi.addCommentUrl,
        options: withAuth(),
        data: {
          "postId": postId,
          "content": content,
        },
      );

      if (response.statusCode == 200) {
        return Right(response.data.toString());
      } else {
        return Left("error: data ${response.data}");
      }
    } on DioException catch (e) {
      return Left(e.response!.data.toString());
    }
  }

  static Future<Either> addPost({required AddEstateParams params}) async {
    try {
      final response = await _dioClient.post(
        ConstApi.addPostUrl,
        data: FormData.fromMap(await params.toJson()),
        options: withAuth(),
      );

      if (response.statusCode == 200) {
        log('Post added successfully: ${response.data}');
        return Right(response.data);
      } else {
        log('Failed to add post: ${response.data}');
        return Left(response.data.toString());
      }
    } on DioException catch (e) {
      log('Error adding post: $e');
      return Left(e.response?.data.toString() ?? 'Unknown error');
    }
  }

  static Future<void> addUnitRate({
    required int unitId,
    required double rate,
    required String ratedUserId,
  }) async {
    try {
      final response = await _dioClient.post(
        ConstApi.addUnitRateUrl,
        data: {
          "unitId": unitId,
          "rate": rate,
          "ratedUserId": ratedUserId,
        },
        options: withAuth(),
      );

      if (response.statusCode == 200) {
        log('Unit rate added successfully: ${response.data}');
      } else {
        log('Failed to add unit rate: ${response.data}');
        throw Exception('Failed to add unit rate');
      }
    } catch (e) {
      log('Error adding unit rate: $e');
      throw Exception('Failed to add unit rate');
    }
  }

  static Future<List<PostModel>> getPostsByFilter({required FiltersParametersModel filter}) async {
    try {
      final response = await _dioClient.get(
        ConstApi.getUnitsByFilterUrl,
        data: filter.toMap(pageIndex: 1, pageCount: 30),
        options: withAuth(),
      );

      if (response.statusCode == 200) {
        final jsonList = response.data["data"] as List;
        return jsonList.map((json) => PostModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch units');
      }
    } catch (e) {
      log('Error getting units by filter: $e');
      throw Exception('Failed to get units by filter');
    }
  }

  static Future<Either> reportPost({required ReportModel reportModel}) async {
    try {
      final response = await _dioClient.post(
        ConstApi.reportUnitUrl,
        data: reportModel.toJson(),
        options: withAuth(),
      );

      if (response.statusCode == 200) {
        log('Post reported successfully: ${response.data}');
        return Right(response.data);
      } else {
        log('Failed to report post: ${response.data}');
        return Left(response.data.toString());
      }
    } on DioException catch (e) {
      return Left(e.response?.data.toString());
    }
  }

  static Future<Either> editPost({
    required int postId,
    required int unitId,
    bool? isRented,
    bool? isDeleted,
  }) async {
    try {
      final response = await _dioClient.put(
        ConstApi.editPostUrl,
        data: {
          "postId": postId,
          "unitId": unitId,
          "isRented": isRented,
          "isDeleted": isDeleted,
        },
        options: withAuth(),
      );

      if (response.statusCode == 200) {
        return Right(response.data);
      } else {
        return Left(response.data.toString());
      }
    } on DioException catch (e) {
      return Left(e.response?.data.toString());
    }
  }

  static Future<Either> searchByTerm({
    required String term,
    required int pageSize,
    required int pageIndex,
  }) async {
    try {
      final response = await _dioClient.get(
        ConstApi.searchByTermUrl,
        queryParameters: {
          "SearchTerm": term,
          "PageSize": pageSize,
          "PageIndex": pageIndex,
        },
      );

      if (response.statusCode == 200) {
        final jsonList = response.data["data"] as List;
        return Right(jsonList.map((e) => PostModel.fromJson(e)).toList());
      } else {
        return Left(response.data.toString());
      }
    } on DioException catch (e) {
      return Left(e.response?.data.toString());
    }
  }
}
