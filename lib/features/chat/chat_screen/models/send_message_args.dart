class SendMessageArgs {
  const SendMessageArgs({
    required this.content,
    required this.senderId,
    required this.receiverId,
    required this.chatId,
    required this.time,
  });

  final String content;
  final String senderId;
  final String receiverId;
  final int? chatId;
  final DateTime time;

  Map<String, dynamic> toJson() => {
        'Content': content,
        'From': senderId,
        'To': receiverId,
        'ChatId': chatId,
        'SendedAt': time.toIso8601String(),
      };
}
