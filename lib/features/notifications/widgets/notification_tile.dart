import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sakeny/common/widgets/view_profile_picture.dart';
import 'package:sakeny/features/notifications/models/notificatnion_model.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key, required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
      child: Row(
        children: [
          _ProfilePic(notification: notification),
          const SizedBox(width: 15),
          _NotificationContent(notification: notification),
        ],
      ),
    );
  }
}

class _ProfilePic extends StatelessWidget {
  const _ProfilePic({required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: ViewProfilePicture(
            profilePictureURL: notification.userPic,
            profilePictureSize: 55,
          ),
        ),
        PositionedDirectional(
          bottom: 0,
          end: 0,
          child: SvgPicture.asset(
            notification.getSvgIcon(),
            width: 20,
            height: 20,
          ),
        )
      ],
    );
  }
}

class _NotificationContent extends StatelessWidget {
  const _NotificationContent({required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: notification.userName,
              style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            TextSpan(
              text: " ${notification.getNotificationText(context)}",
              style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        softWrap: true,
      ),
    );
  }
}
