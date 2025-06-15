import 'package:equatable/equatable.dart';

class MessageModel extends Equatable {
  const MessageModel({
    required this.chatId,
    required this.messageId,
    required this.content,
    required this.senderId,
    required this.receiverId,
    required this.time,
    required this.read,
  });

  final int chatId;
  final int messageId;
  final String content;
  final String senderId;
  final String receiverId;
  final DateTime time;
  final bool read;

  @override
  List<Object?> get props => [chatId, content, senderId, receiverId, time, read];

  // ignore: sort_constructors_first
  factory MessageModel.fromJson(Map<String, dynamic> map) {
    return MessageModel(
      chatId: map['chatId'] as int,
      messageId: map['id'] as int,
      content: map['content'] as String,
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      time: DateTime.parse(map['date'] as String),
      read: map['read'] as bool,
    );
  }

  MessageModel copyWith({
    int? chatId,
    int? messageId,
    String? content,
    String? senderId,
    String? receiverId,
    DateTime? time,
    bool? read,
  }) {
    return MessageModel(
      chatId: chatId ?? this.chatId,
      messageId: messageId ?? this.messageId,
      content: content ?? this.content,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      time: time ?? this.time,
      read: read ?? this.read,
    );
  }
}
