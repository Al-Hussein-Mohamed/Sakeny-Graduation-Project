part of 'chat_cubit.dart';

@immutable
sealed class ChatState extends Equatable {
  const ChatState();
}

final class ChatLoading extends ChatState {
  const ChatLoading();

  @override
  List<Object?> get props => [];
}

final class ChatLoaded extends ChatState {
  const ChatLoaded({required this.messages});

  final List<MessageModel> messages;

  @override
  List<Object?> get props => [messages];
}

final class ChatError extends ChatState {
  const ChatError(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}
