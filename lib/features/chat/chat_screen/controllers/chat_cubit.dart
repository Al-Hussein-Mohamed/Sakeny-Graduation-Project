import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakeny/core/APIs/api_chat.dart';
import 'package:sakeny/core/services/signalr_streams/chat_hub.dart';
import 'package:sakeny/features/chat/all_chats/controllers/chat_sync.dart';
import 'package:sakeny/features/chat/chat_screen/models/chat_args.dart';
import 'package:sakeny/features/chat/chat_screen/models/message_model.dart';
import 'package:sakeny/features/chat/chat_screen/models/seen_model.dart';
import 'package:sakeny/features/chat/chat_screen/models/send_message_args.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({required ChatArgs args}) : super(const ChatLoading()) {
    _args = args;
    _chatHub = ChatHub();
    _messageStreamSubscription = _chatHub.messagesStream.listen(_onNewMessage);
    _seenStreamSubscription = _chatHub.seenStream.listen(_onMessageSeen);
    init();
  }

  static ChatCubit of(BuildContext context) => context.read<ChatCubit>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController scrollController = ScrollController();
  final TextEditingController messageController = TextEditingController();

  late final ChatArgs _args;
  late final ChatHub _chatHub;
  late final StreamSubscription<MessageModel> _messageStreamSubscription;
  late final StreamSubscription<SeenModel> _seenStreamSubscription;

  final int _pageSize = 25;
  int _currentPage = 1;
  bool _loading = false;
  bool _reachMax = false;

  Future<void> init() async {
    _loading = true;

    emit(const ChatLoading());
    try {
      final messages = await ApiChat.getChat(
        senderId: _args.myId,
        receiverId: _args.otherId,
        pageSize: _pageSize,
        pageIndex: _currentPage,
      );
      await _chatHub.connect();
      _currentPage++;
      _reachMax = messages.length < _pageSize;
      emit(ChatLoaded(messages: messages));
    } catch (e) {
      emit(ChatError(e.toString()));
    }

    _loading = false;
  }

  void loadMoreMessages() async {
    if (_reachMax) return;
    if (_loading) return;
    if (state is! ChatLoaded) return;

    _loading = true;
    try {
      final messages = await ApiChat.getChat(
        senderId: _args.myId,
        receiverId: _args.otherId,
        pageSize: _pageSize,
        pageIndex: _currentPage,
      );
      _currentPage++;
      _reachMax = messages.length < _pageSize;
      final currentMessages = (state as ChatLoaded).messages;
      emit(ChatLoaded(messages: [...currentMessages, ...messages]));
    } catch (e) {
      showError(e.toString());
    } finally {
      _loading = false;
    }
  }

  void _onNewMessage(MessageModel message) {
    if ((message.senderId == _args.myId && message.receiverId == _args.otherId) ||
        (message.senderId == _args.otherId && message.receiverId == _args.myId)) {
      final List<MessageModel> newMessages = [
        message,
        ...(state is ChatLoaded ? (state as ChatLoaded).messages : []),
      ];
      emit(ChatLoaded(messages: newMessages));

      scrollToBottom();
    }
  }

  void _onMessageSeen(SeenModel seenModel) {
    if ((seenModel.senderId == _args.myId && seenModel.receiverId == _args.otherId) ||
        (seenModel.receiverId == _args.myId && seenModel.senderId == _args.otherId)) {
      final currentState = state;
      if (state is! ChatLoaded) return;
      final messages = (currentState as ChatLoaded).messages;
      final updatedMessages = messages.map((message) {
        if (message.messageId == seenModel.messageId) {
          return message.copyWith(read: true);
        }
        return message;
      }).toList();
      emit(ChatLoaded(messages: updatedMessages));
    }
  }

  Future<void> sendMessage() async {
    if (messageController.text.isEmpty) return;
    final messageContent = messageController.text.trim();
    messageController.clear();

    try {
      await ApiChat.sendMessage(
        message: SendMessageArgs(
          content: messageContent,
          senderId: _args.myId,
          receiverId: _args.otherId,
          chatId: _args.chatId,
          time: DateTime.now(),
        ),
      );
      scrollToBottom();
    } catch (e) {
      showError(e.toString());
    }
  }

  void markMessageAsRead(MessageModel message) async {
    if (message.read || message.senderId == _args.myId) return;

    final messageId = message.messageId;
    try {
      await ApiChat.markMessageAsRead(messageId: message.messageId);
      ChatSync.add(SeenModel(
        messageId: 0,
        senderId: _args.otherId,
        receiverId: _args.myId,
      ));
    } catch (e) {
      log("Marking message as read failed: $e, messageId: $messageId");
    }
  }

  void showError(String errorMessage) {
    emit(ChatError(errorMessage));
  }

  void jumpToBottom() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(0);
    }
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Future<void> close() {
    _messageStreamSubscription.cancel();
    _seenStreamSubscription.cancel();
    _chatHub.dispose();
    messageController.dispose();
    scrollController.dispose();
    return super.close();
  }
}
