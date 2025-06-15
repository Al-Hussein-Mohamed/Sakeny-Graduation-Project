import 'package:flutter/material.dart';
import 'package:sakeny/core/constants/const_images.dart';
import 'package:sakeny/generated/l10n.dart';

enum NotificationType {
  announcement,
  alert,
  like,
  comment,
  message;

  factory NotificationType.fromInt(int value) {
    switch (value) {
      case 0:
        return NotificationType.announcement;
      case 1:
        return NotificationType.alert;
      case 2:
        return NotificationType.like;
      case 3:
        return NotificationType.comment;
      case 4:
        return NotificationType.message;
      default:
        throw ArgumentError('Invalid notification type value: $value');
    }
  }
}

class NotificationModel {
  const NotificationModel({
    required this.type,
    required this.contentId,
    required this.content,
    required this.receiverUserId,
    required this.userId,
    required this.userName,
    required this.userPic,
  });

  final NotificationType type;
  final int contentId;
  final String content;
  final String receiverUserId;
  final String userId;
  final String userName;
  final String? userPic;

  // ignore: sort_constructors_first
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      type: NotificationType.fromInt(json['notificationType'] as int),
      contentId: json['contentId'] as int,
      content: json['content'] as String,
      receiverUserId: json['to'] as String,
      userId: json['userId'] as String,
      userName: json['name'] as String,
      userPic: json['picture'] as String?,
    );
  }

  String getSvgIcon() {
    switch (type) {
      case NotificationType.announcement:
        return ConstImages.notificationsAnnouncement;
      case NotificationType.alert:
        return ConstImages.notificationsAlert;
      case NotificationType.like:
        return ConstImages.notificationsLike;
      case NotificationType.comment:
        return ConstImages.notificationsComment;
      case NotificationType.message:
        return ConstImages.notificationsChat;
    }
  }

  String getNotificationText(BuildContext context) {
    final lang = S.of(context);
    switch (type) {
      case NotificationType.announcement:
        return content;
      case NotificationType.alert:
        return content;
      case NotificationType.like:
        return lang.notificationLikeBody;
      case NotificationType.comment:
        return lang.notificationCommentBody;
      case NotificationType.message:
        return lang.notificationChatBody;
    }
  }
}
