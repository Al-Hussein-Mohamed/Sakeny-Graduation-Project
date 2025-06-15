part of '../screens/post_widget.dart';

class _PostHeader extends StatelessWidget {
  const _PostHeader({
    required this.userName,
    required this.userId,
    required this.profilePictureURL,
    required this.date,
    required this.postId,
    required this.userRate,
  });

  final String userId;
  final String userName;
  final String? profilePictureURL;
  final int postId;
  final DateTime date;
  final num userRate;

  @override
  Widget build(BuildContext context) {
    final PostCubit postCubit = context.read<PostCubit>();
    final ThemeData theme = Theme.of(context);
    final double profilePictureSize = 35;

    final String heroTag = "${postId.toString()}_header_${postCubit.postContent}";

    return Row(
      children: [
        GestureDetector(
          onTap: () => _goToProfileScreen(context, heroTag),
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: CustomColorScheme.getColor(context, CustomColorScheme.postUserBackground),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (postCubit.postContent == PostContent.profile)
                  ViewProfilePicture(
                    profilePictureURL: profilePictureURL,
                    profilePictureSize: profilePictureSize,
                  ),
                if (postCubit.postContent != PostContent.profile)
                  Hero(
                    tag: heroTag,
                    child: ViewProfilePicture(
                      profilePictureURL: profilePictureURL,
                      profilePictureSize: profilePictureSize,
                    ),
                  ),
                const SizedBox(width: 8),
                Text(userName, style: theme.textTheme.titleSmall),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final String fullDateText = "${date.day} ${getMonthName(date.month)} ${date.year}";
              final TextPainter textPainter = TextPainter(
                text: TextSpan(
                  text: fullDateText,
                  style: theme.textTheme.bodySmall,
                ),
                maxLines: 1,
                textDirection: TextDirection.ltr,
              )..layout();

              final bool willOverflow = textPainter.width > constraints.maxWidth - 10;

              if (willOverflow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      children: [
                        Text(
                          "${date.day} ${getMonthName(date.month)}",
                          style: theme.textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${date.year}",
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return Text(
                  fullDateText,
                  style: theme.textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                );
              }
            },
          ),
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  void _goToProfileScreen(BuildContext context, String heroTag) {
    final PostCubit postCubit = context.read<PostCubit>();
    if (postCubit.postContent == PostContent.profile) return;
    final homeCubit = context.read<HomeCubit>();

    final ProfileArgs profileArgs = ProfileArgs(
      userState: homeCubit.user,
      userId: userId,
      userName: userName,
      userProfilePictureUrl: profilePictureURL,
      heroTag: heroTag,
      userRate: userRate,
    );

    Navigator.pushNamed(context, PageRouteNames.profile, arguments: profileArgs);
  }
}
