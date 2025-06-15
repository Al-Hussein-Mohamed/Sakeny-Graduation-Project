import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sakeny/core/APIs/api_notifications.dart';
import 'package:sakeny/core/providers/settings_provider.dart';
import 'package:sakeny/core/services/notificaion_services/local_notification_services.dart';
import 'package:sakeny/core/services/overlays/toastification_service.dart';
import 'package:sakeny/core/services/service_locator.dart';

class PushNotificationsService {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static final _settings = sl<SettingsProvider>();

  static Future init() async {
    await firebaseMessaging.requestPermission();

    try {
      final String? fcmToken = await firebaseMessaging.getToken();
      log("FCM Token: $fcmToken");
    } catch (e, s) {
      log("❌ Failed to get FCM token: $e");
      log("📍 Stack trace: $s");
    }

    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("Received a message in the foreground: ${message.messageId}");
      log("Message data: ${message.data}");
      log("Message notification: ${message.notification?.title} - ${message.notification?.body}");
      LocalNotificationServices.showNotification(
        title: message.notification?.title ?? "No Title",
        body: message.notification?.body ?? "No Body",
        payload: message.data.toString(),
      );
    });
  }

  static Future _handleBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    log("Handling a background message: ${message.messageId}");
  }

  static Future<String?> getToken() async {
    return await firebaseMessaging.getToken();
  }

  static addDeviceToken() async {
    log("Adding device token...");
    if (_settings.userId == null) {
      log("User ID is null, cannot add device token");
      return;
    }
    log("Adding device token for user ID: ${_settings.userId}");
    final String? token = await getToken();
    if (token != null) {
      final response = await ApiNotifications.addDeviceToken(
        deviceToken: token,
        userId: _settings.userId!,
      );
      if (response.isLeft()) {
        ToastificationService.showGlobalErrorToast("Failed to add device token");
      } else {
        log("Device token added successfully");
      }
    } else {
      ToastificationService.showGlobalErrorToast("Failed to get FCM token");
    }
  }

  static removeDeviceToken() async {
    if (_settings.userId == null) {
      log("User ID is null, cannot delete device token");
      return;
    }

    final String? token = await getToken();
    if (token != null) {
      final response = await ApiNotifications.removeDeviceToken(
        deviceToken: token,
        userId: _settings.userId!,
      );
      if (response.isLeft()) {
        ToastificationService.showGlobalErrorToast("Failed to remove device token");
      } else {
        log("Device token removed successfully");
      }
    } else {
      ToastificationService.showGlobalErrorToast("Failed to get FCM token");
    }
  }
}
