import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sakeny/common/widgets/custom_circle_progress_indicator.dart';
import 'package:sakeny/common/widgets/custom_scaffold.dart';
import 'package:sakeny/common/widgets/view_profile_picture.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/constants/const_images.dart';
import 'package:sakeny/core/theme/widget_themes/app_colors.dart';
import 'package:sakeny/core/utils/extensions/dynamic_text_field_direction_extension.dart';
import 'package:sakeny/features/chat/chat_screen/controllers/chat_cubit.dart';
import 'package:sakeny/features/chat/chat_screen/models/chat_args.dart';
import 'package:sakeny/features/chat/chat_screen/models/message_model.dart';
import 'package:sakeny/features/chat/chat_screen/screens/widgets/date_header.dart';
import 'package:sakeny/features/chat/chat_screen/screens/widgets/message_widget.dart';
import 'package:sakeny/generated/l10n.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.args});

  final ChatArgs args;

  @override
  Widget build(BuildContext context) {
    final ChatCubit chatCubit = ChatCubit.of(context);

    return CustomScaffold(
      scaffoldKey: chatCubit.scaffoldKey,
      screenTitle: args.receiverName,
      titleWidget: Row(
        children: [
          Hero(
            tag: args.profilePictureHeroTag,
            child: ViewProfilePicture(
              profilePictureURL: args.receiverImageUrl,
              profilePictureSize: 40,
            ),
          ),
          const SizedBox(width: 10),
          Text(args.receiverName),
        ],
      ),
      onBack: () => Navigator.pop(context),
      body: _ChatBody(args: args),
    );
  }
}

class _ChatBody extends StatelessWidget {
  const _ChatBody({required this.args});

  final ChatArgs args;

  @override
  Widget build(BuildContext context) {
    final ChatCubit chatCubit = ChatCubit.of(context);

    return Column(
      children: [
        Expanded(
          child: BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              switch (state) {
                case ChatLoading():
                  return const CustomCircleProgressIndicator();
                case ChatLoaded():
                  if (state.messages.isEmpty) {
                    return const _EmptyChatBody();
                  }
                  return _ChatLoadedBody(myId: args.myId, messages: state.messages);

                case ChatError():
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.error, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: chatCubit.init,
                          child: const Text("try again"),
                        ),
                      ],
                    ),
                  );
              }
            },
          ),
        ),
        const _ChatTextField(),
      ],
    );
  }
}

class _ChatTextField extends StatelessWidget {
  const _ChatTextField();

  @override
  Widget build(BuildContext context) {
    final ChatCubit chatCubit = ChatCubit.of(context);
    final AppColors colors = AppColors.of(context);
    final ThemeData theme = Theme.of(context);
    final S lang = S.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: chatCubit.messageController,
              decoration: InputDecoration(
                hintText: lang.writeMessage,
                focusedBorder: _buildOutlineInputBorder(colors.textFieldBorder),
                enabledBorder: _buildOutlineInputBorder(colors.textFieldBorder),
              ),
              onSubmitted: (_) => chatCubit.sendMessage(),
            ).withAutomaticDirection(),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.send),
            color: Colors.white,
            padding: const EdgeInsetsDirectional.only(top: 14, bottom: 14, start: 16, end: 12),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(colors.primary),
            ),
            onPressed: () => chatCubit.sendMessage(),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _buildOutlineInputBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color),
      borderRadius: BorderRadius.circular(26),
    );
  }
}

class _EmptyChatBody extends StatelessWidget {
  const _EmptyChatBody();

  @override
  Widget build(BuildContext context) {
    final AppColors colors = AppColors.of(context);
    final ThemeData theme = Theme.of(context);
    final S lang = S.of(context);

    return Padding(
      padding: ConstConfig.screenPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            ConstImages.emptyChat,
            width: 120,
            height: 120,
            colorFilter: ColorFilter.mode(
              colors.text,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 2),
          Text(lang.emptyChatTitle, style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            lang.emptyUserChatMessage,
            style: theme.textTheme.bodyMedium?.copyWith(color: colors.text.withOpacity(0.5)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _ChatLoadedBody extends StatefulWidget {
  const _ChatLoadedBody({required this.myId, required this.messages});

  final String myId;
  final List<MessageModel> messages;

  @override
  State<_ChatLoadedBody> createState() => _ChatLoadedBodyState();
}

class _ChatLoadedBodyState extends State<_ChatLoadedBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ChatCubit chatCubit = ChatCubit.of(context);
      chatCubit.scrollController.addListener(_messagePagination);
      // chatCubit.scrollController.jumpTo(chatCubit.scrollController.position.maxScrollExtent);
    });
  }

  @override
  void dispose() {
    final ChatCubit chatCubit = ChatCubit.of(context);
    chatCubit.scrollController.removeListener(_messagePagination);
    super.dispose();
  }

  void _messagePagination() {
    final ChatCubit chatCubit = ChatCubit.of(context);
    if (chatCubit.scrollController.position.pixels >=
        chatCubit.scrollController.position.maxScrollExtent - 200) {
      chatCubit.loadMoreMessages();
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    final ChatCubit chatCubit = ChatCubit.of(context);
    final messages = widget.messages;

    return ListView.builder(
      controller: chatCubit.scrollController,
      reverse: true,
      padding: const EdgeInsets.only(top: 12),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final sentByMe = message.senderId == widget.myId;
        if (!sentByMe && !message.read) {
          chatCubit.markMessageAsRead(message);
        }

        final showDateHeader =
            index == messages.length - 1 || !_isSameDay(message.time, messages[index + 1].time);

        return Column(
          children: [
            if (showDateHeader) DateHeader(date: message.time),
            MessageWidget(
              message: message,
              sentByMe: sentByMe,
            ),
          ],
        );
      },
    );
  }
}
