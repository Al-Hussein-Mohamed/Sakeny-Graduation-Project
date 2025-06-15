import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sakeny/core/theme/widget_themes/app_colors.dart';
import 'package:sakeny/core/utils/extensions/dynamic_text_direction_extension.dart';
import 'package:sakeny/features/chat/chat_screen/models/message_model.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({super.key, required this.message, required this.sentByMe});

  final bool sentByMe;
  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = AppColors.of(context);
    final ThemeData theme = Theme.of(context);
    final bool isRow = message.content.length < 25;

    final Color textColor = sentByMe ? colors.myMessageText : colors.otherMessageText;
    final Color backgroundColor =
        sentByMe ? colors.myMessageBackground : colors.otherMessageBackground;

    final String formattedTime = DateFormat('h:mm a').format(message.time);

    return Align(
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: sentByMe ? const Radius.circular(18) : const Radius.circular(0),
            bottomRight: sentByMe ? const Radius.circular(0) : const Radius.circular(18),
          ),
        ),
        child: isRow
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: messageContents(theme, textColor, formattedTime),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: messageContents(theme, textColor, formattedTime),
              ),
      ),
    );
  }

  List<Widget> messageContents(ThemeData theme, Color textColor, String formattedTime) {
    return [
      Text(
        message.content,
        style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
        textAlign: TextAlign.start,
        softWrap: true,
        overflow: TextOverflow.visible,
      ).withAutomaticDirection(),
      const SizedBox(height: 5, width: 5),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            formattedTime,
            style: theme.textTheme.bodySmall?.copyWith(
              color: textColor.withOpacity(0.7),
              fontSize: 10,
            ),
          ),
          if (sentByMe) ...[
            const SizedBox(width: 4),
            Icon(
              message.read ? Icons.done_all : Icons.done,
              size: 14,
              color: textColor.withOpacity(0.7),
            ),
          ],
        ],
      ),
    ];
  }
}
