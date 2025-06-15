class ChatArgs {
  const ChatArgs({
    this.chatId,
    required this.myId,
    required this.otherId,
    required this.receiverName,
    required this.receiverImageUrl,
    required this.profilePictureHeroTag,
  });

  final int? chatId;
  final String myId;
  final String otherId;
  final String receiverName;
  final String? receiverImageUrl;
  final String profilePictureHeroTag;
}
