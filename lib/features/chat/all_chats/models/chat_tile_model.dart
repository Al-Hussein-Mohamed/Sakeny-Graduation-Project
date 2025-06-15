class ChatTileModel {
  const ChatTileModel({
    required this.chatId,
    required this.senderId,
    required this.name,
    required this.profilePicture,
    required this.lastMessage,
    required this.lastMessageSenderId,
    required this.lastMessageTime,
    required this.unreadMessagesCount,
  });

  final int chatId;
  final String senderId;
  final String name;
  final String? profilePicture;
  final String lastMessage;
  final String lastMessageSenderId;
  final DateTime lastMessageTime;
  final int unreadMessagesCount;

  // ignore: sort_constructors_first
  factory ChatTileModel.fromJson(Map<String, dynamic> json) {
    final String? profilePicResponse = json['picUrl'] as String?;
    final String? profilePicture = profilePicResponse?.isEmpty ?? true ? null : profilePicResponse;
    return ChatTileModel(
      chatId: json['id'] as int,
      senderId: json['userId'] as String,
      name: json['name'] as String,
      profilePicture: profilePicture,
      lastMessage: json['lastMsg'] as String,
      lastMessageSenderId: json['lastId'] as String,
      lastMessageTime: DateTime.parse(json['last'] as String),
      unreadMessagesCount: json['count'] as int,
    );
  }

  ChatTileModel copyWith({
    int? chatId,
    String? senderId,
    String? name,
    String? profilePicture,
    String? lastMessage,
    String? lastMessageSenderId,
    DateTime? lastMessageTime,
    int? unreadMessagesCount,
  }) {
    return ChatTileModel(
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadMessagesCount: unreadMessagesCount ?? this.unreadMessagesCount,
    );
  }
}
