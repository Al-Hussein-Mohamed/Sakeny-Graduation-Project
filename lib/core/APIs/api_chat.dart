import 'dart:developer';

import 'package:sakeny/core/constants/const_api.dart';
import 'package:sakeny/core/network/dio_client.dart';
import 'package:sakeny/core/network/interceptors/refresh_token_interceptor.dart';
import 'package:sakeny/core/services/service_locator.dart';
import 'package:sakeny/features/chat/all_chats/models/chat_tile_model.dart';
import 'package:sakeny/features/chat/chat_screen/models/message_model.dart';
import 'package:sakeny/features/chat/chat_screen/models/send_message_args.dart';

class ApiChat {
  ApiChat._();

  static final DioClient _dio = sl<DioClient>();

  static Future<List<ChatTileModel>> getAllChats({
    required int pageIndex,
    required int pageSize,
  }) async {
    try {
      final response = await _dio.get(
        ConstApi.getAllChatsUrl,
        queryParameters: {
          "pageIndex": pageIndex,
          "PageSize": pageSize,
        },
        options: withAuth(),
      );

      if (response.statusCode == 200) {
        final jsonList = response.data as List;
        return jsonList.map((json) => ChatTileModel.fromJson(json)).toList();
      } else {
        throw Exception("Network error: ${response.statusCode}");
      }
    } catch (e) {
      log("Fetching chats failed: $e");
      throw Exception("Failed to fetch chats");
    }
  }

  static Future<void> sendMessage({required SendMessageArgs message}) async {
    try {
      final response = await _dio.post(
        ConstApi.sendMessageUrl,
        data: message.toJson(),
        options: withAuth(),
      );

      if (response.statusCode == 200) {
        log("Message sent successfully");
      } else {
        log("Sending message failed: ${response.statusCode}");
        throw Exception("Network error: ${response.statusCode}");
      }
    } catch (e) {
      log("Sending message failed: $e");
      throw Exception("Failed to send message");
    }
  }

  static Future<List<MessageModel>> getChat({
    required String senderId,
    required String receiverId,
    required int pageSize,
    required int pageIndex,
  }) async {
    try {
      final response = await _dio.get(
        ConstApi.getChatUrl,
        queryParameters: {
          "id1": senderId,
          "id2": receiverId,
          "PageSize": pageSize,
          "pageIndex": pageIndex,
        },
        options: withAuth(),
      );

      if (response.statusCode == 200) {
        final jsonList = response.data as List;
        return jsonList.map((json) => MessageModel.fromJson(json)).toList();
      } else {
        log("Fetching chat messages failed: ${response.statusCode}");
        throw Exception("Network error: ${response.statusCode}");
      }
    } catch (e) {
      log("Fetching chat messages failed: $e");
      throw Exception("Failed to fetch chat messages");
    }
  }

  static Future<void> markMessageAsRead({required int messageId}) async {
    try {
      final response = await _dio.put(
        ConstApi.markMessageAsReadUrl,
        queryParameters: {
          "MsgId": messageId,
        },
        options: withAuth(),
      );

      if (response.statusCode == 200) {
        log(response.data.toString());
        log("Message marked as read successfully");
      } else {
        log("Marking message as read failed: ${response.statusCode}");
        throw Exception("Network error: ${response.statusCode}");
      }
    } catch (e) {
      log("Marking message as read failed: $e");
      throw Exception("Failed to mark message as read");
    }
  }
}
