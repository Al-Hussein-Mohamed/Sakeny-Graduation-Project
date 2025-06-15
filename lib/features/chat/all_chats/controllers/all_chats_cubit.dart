import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakeny/core/APIs/api_chat.dart';
import 'package:sakeny/core/services/signalr_streams/chat_hub.dart';
import 'package:sakeny/features/chat/all_chats/controllers/chat_sync.dart';
import 'package:sakeny/features/chat/all_chats/models/chat_tile_model.dart';
import 'package:sakeny/features/chat/chat_screen/models/message_model.dart';
import 'package:sakeny/features/chat/chat_screen/models/seen_model.dart';

part 'all_chats_state.dart';

class AllChatsCubit extends Cubit<AllChatsState> {
  AllChatsCubit({required this.myId}) : super(const AllChatsLoading()) {
    init();
    _messageStreamSubscription = _chatHub.messagesStream.listen(_onNewMessage);
    _seenStreamSubscription = ChatSync.seenStream.listen(_onMessageSeen);
    scrollController.addListener(_loadMoreChats);
  }

  @override
  Future<void> close() async {
    scrollController
      ..removeListener(_loadMoreChats)
      ..dispose();
    _chatHub.disconnect();
    await _messageStreamSubscription.cancel();
    await _seenStreamSubscription.cancel();
    super.close();
  }

  static AllChatsCubit of(BuildContext context) {
    return BlocProvider.of<AllChatsCubit>(context);
  }

  final _chatHub = ChatHub();
  late final StreamSubscription<MessageModel> _messageStreamSubscription;
  late final StreamSubscription<SeenModel> _seenStreamSubscription;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final scrollController = ScrollController();

  final String myId;
  final int pageSize = 15;
  int pageCount = 1;
  bool loading = false;
  bool reachMax = false;

  void init() async {
    loading = true;
    try {
      final List<ChatTileModel> chatTiles = await ApiChat.getAllChats(
        pageIndex: pageCount,
        pageSize: pageSize,
      );
      await _chatHub.connect();
      pageCount++;
      reachMax = chatTiles.length < pageSize;
      emit(AllChatsLoaded(chatTiles: chatTiles));
    } catch (e) {
      emit(AllChatsError(e.toString()));
    }
    loading = false;
  }

  Future<void> _loadMoreChats() async {
    if (scrollController.position.pixels < scrollController.position.maxScrollExtent - 200) return;
    if (state is! AllChatsLoaded) return;
    if (reachMax || loading) return;
    loading = true;

    try {
      final List<ChatTileModel> chatTiles = await ApiChat.getAllChats(
        pageIndex: pageCount,
        pageSize: pageSize,
      );
      pageCount++;
      reachMax = chatTiles.length < pageSize;

      emit(AllChatsLoaded(chatTiles: [...(state as AllChatsLoaded).chatTiles, ...chatTiles]));
    } catch (e) {
      emit(AllChatsError(e.toString()));
    }

    loading = false;
  }

  void _onNewMessage(MessageModel message) {
    if (state is! AllChatsLoaded) return;

    final List<ChatTileModel> chatTiles = List.from((state as AllChatsLoaded).chatTiles);
    final int idx = chatTiles.indexWhere((chat) => chat.chatId == message.chatId);
    if (idx == -1) return;

    chatTiles[idx] = chatTiles[idx].copyWith(
      lastMessage: message.content,
      lastMessageTime: message.time,
      unreadMessagesCount: chatTiles[idx].unreadMessagesCount + 1,
      lastMessageSenderId: message.senderId,
    );

    chatTiles.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));

    emit(AllChatsLoaded(chatTiles: chatTiles));
  }

  void _onMessageSeen(SeenModel seenModel) {
    final List<ChatTileModel> chatTiles = List.from((state as AllChatsLoaded).chatTiles);
    final int idx = chatTiles.indexWhere(
      (chat) => chat.senderId == seenModel.senderId && myId == seenModel.receiverId,
    );
    // for (int i = 0; i < chatTiles.length; i++) {
    //   log("i: $i, ${chatTiles[i].senderId} , $myId");
    // }
    // log("seenModel : sender ${seenModel.senderId} , ${seenModel.receiverId}");
    // log("idx : $idx");
    if (idx == -1) return;

    chatTiles[idx] = chatTiles[idx].copyWith(
      unreadMessagesCount: chatTiles[idx].unreadMessagesCount - 1,
    );
    // log("Message seen: ${seenModel.senderId} -> ${seenModel.receiverId}, unread count: ${chatTiles[idx].unreadMessagesCount}");
    emit(AllChatsLoaded(chatTiles: chatTiles));
  }
}
