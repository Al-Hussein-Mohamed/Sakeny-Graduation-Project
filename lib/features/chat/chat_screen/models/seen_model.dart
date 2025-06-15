class SeenModel {
  const SeenModel({
    required this.messageId,
    required this.senderId,
    required this.receiverId,
  });

  final int messageId;
  final String senderId;
  final String receiverId;

  // ignore: sort_constructors_first
  factory SeenModel.fromJson(Map<String, dynamic> json) => SeenModel(
        messageId: json['msgId'],
        senderId: json['senderId'],
        receiverId: json['receiverId'],
      );
}
