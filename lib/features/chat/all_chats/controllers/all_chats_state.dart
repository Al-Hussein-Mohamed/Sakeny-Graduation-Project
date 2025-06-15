part of 'all_chats_cubit.dart';

@immutable
sealed class AllChatsState extends Equatable {
  const AllChatsState();
}

class AllChatsLoading extends AllChatsState {
  const AllChatsLoading();

  @override
  List<Object?> get props => [];
}

class AllChatsLoaded extends AllChatsState {
  const AllChatsLoaded({required this.chatTiles});

  final List<ChatTileModel> chatTiles;

  @override
  List<Object?> get props => [chatTiles];
}

class AllChatsError extends AllChatsState {
  const AllChatsError(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}
