import 'package:flutter/material.dart';
import 'package:sakeny/common/widgets/view_profile_picture.dart';
import 'package:sakeny/core/theme/widget_themes/app_colors.dart';
import 'package:sakeny/features/chat/all_chats/models/chat_tile_model.dart';
import 'package:sakeny/generated/l10n.dart';
import 'package:shimmer/shimmer.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.chatTileModel,
    required this.onTap,
  });

  final ChatTileModel chatTileModel;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final lang = S.of(context);
    final bool isLastMessageSentByMe = chatTileModel.lastMessageSenderId != chatTileModel.senderId;
    final int unreadMessagesCount = isLastMessageSentByMe ? 0 : chatTileModel.unreadMessagesCount;

    final String lastMessage =
        (isLastMessageSentByMe ? "${lang.you}: " : "") + chatTileModel.lastMessage;

    return Column(
      children: [
        ListTile(
          leading: Hero(
            tag: "${chatTileModel.senderId}_${chatTileModel.name}",
            child: ViewProfilePicture(
              profilePictureURL: chatTileModel.profilePicture,
              profilePictureSize: 50,
            ),
          ),
          title: Text(
            chatTileModel.name,
            style: theme.textTheme.bodyMedium,
          ),
          subtitle: Text(
            lastMessage,
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
          trailing: isLastMessageSentByMe || unreadMessagesCount == 0
              ? null
              : Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.of(context).primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    unreadMessagesCount > 0 ? '$unreadMessagesCount' : '',
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.white),
                  ),
                ),
          onTap: onTap,
        ),
        const Divider(
          height: 1,
          color: Colors.grey,
        ),
      ],
    );
  }
}

class ChatTileShimmer extends StatelessWidget {
  const ChatTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final AppColors colors = AppColors.of(context);
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: colors.shimmerBase,
          highlightColor: colors.shimmerHighlight,
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            title: Container(
              height: 16,
              width: double.infinity,
              color: Colors.white,
              margin: const EdgeInsetsDirectional.only(end: 80),
            ),
            subtitle: Container(
              height: 12,
              width: double.infinity,
              color: Colors.white,
              margin: const EdgeInsetsDirectional.only(top: 8, end: 120),
            ),
          ),
        ),
        const Divider(
          height: 1,
          color: Colors.grey,
        ),
      ],
    );
  }
}
