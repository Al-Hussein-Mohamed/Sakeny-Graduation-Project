import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sakeny/common/models/user_model.dart';
import 'package:sakeny/common/widgets/view_profile_picture.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/constants/const_images.dart';
import 'package:sakeny/core/routing/page_route_name.dart';
import 'package:sakeny/core/services/overlays/toastification_service.dart';
import 'package:sakeny/features/chat/chat_screen/models/chat_args.dart';
import 'package:sakeny/features/home/controllers/home_cubit.dart';
import 'package:sakeny/features/profile/profile/controllers/profile_cubit.dart';
import 'package:sakeny/features/profile/profile/models/profile_args.dart';
import 'package:sakeny/features/profile/profile/screens/widgets/profile_button.dart';
import 'package:sakeny/generated/l10n.dart';

class UserInfoAndControls extends StatelessWidget {
  const UserInfoAndControls({
    super.key,
    required this.profileArgs,
  });

  final ProfileArgs profileArgs;

  @override
  Widget build(BuildContext context) {
    const double profilePictureSize = 140;
    final ThemeData theme = Theme.of(context);

    const double iconSize = 18;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        Hero(
          tag: profileArgs.heroTag ?? "null hero tag profile picture ${profileArgs.userId}}",
          child: ViewProfilePicture(
            profilePictureURL: profileArgs.userProfilePictureUrl,
            profilePictureSize: profilePictureSize,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(profileArgs.userName, style: theme.textTheme.titleMedium),
            const SizedBox(width: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: ConstColors.ratingStars),
                const SizedBox(width: 2),
                Text(profileArgs.userRate.toString(), style: theme.textTheme.bodyLarge),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (profileArgs.myProfile) ..._myProfileButtons(context, iconSize),
        if (!profileArgs.myProfile) ...otherProfileButtons(context, iconSize),
        const SizedBox(height: 12),
        const Divider(
          height: 1,
          thickness: 1,
          color: ConstColors.grey,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  List<Widget> _myProfileButtons(BuildContext context, double iconSize) {
    final ThemeData theme = Theme.of(context);
    final S lang = S.of(context);
    final Color contentColor = theme.brightness == Brightness.light ? Colors.black : Colors.white;

    void managePostsOnTap() {
      ProfileCubit.of(context).setEditing(true);
    }

    return [
      ProfileButton(
        prefixIcon: Icon(Icons.add, color: contentColor, size: iconSize),
        title: lang.addRealEstate,
        onTap: () => Navigator.pushNamed(context, PageRouteNames.addRealEstate),
      ),
      const SizedBox(height: 4),
      ProfileButton(
        prefixIcon: SvgPicture.asset(
          ConstImages.managePosts,
          width: iconSize,
          height: iconSize,
          colorFilter: ColorFilter.mode(contentColor, BlendMode.srcIn),
        ),
        title: lang.managePosts,
        onTap: managePostsOnTap,
      ),
    ];
  }

  List<Widget> otherProfileButtons(BuildContext context, double iconSize) {
    final HomeCubit homeCubit = HomeCubit.of(context);
    final ThemeData theme = Theme.of(context);
    final S lang = S.of(context);
    final Color contentColor = theme.brightness == Brightness.light ? Colors.black : Colors.white;

    void chatButtonOnTap() {
      switch (homeCubit.user) {
        case GuestUser():
          ToastificationService.showGlobalGuestLoginToast();
          break;

        case AuthenticatedUser(userModel: final user):
          Navigator.pushNamed(
            context,
            PageRouteNames.chat,
            arguments: ChatArgs(
              myId: user!.userId,
              otherId: profileArgs.userId,
              receiverName: profileArgs.userName,
              receiverImageUrl: profileArgs.userProfilePictureUrl,
              profilePictureHeroTag:
                  profileArgs.heroTag ?? "null hero tag profile picture ${profileArgs.userId}",
            ),
          );
          break;
      }
    }

    return [
      ProfileButton(
        prefixIcon: SvgPicture.asset(
          ConstImages.chat,
          width: iconSize,
          height: iconSize,
          colorFilter: ColorFilter.mode(contentColor, BlendMode.srcIn),
        ),
        title: lang.chat,
        onTap: chatButtonOnTap,
      ),
      // const SizedBox(height: 4),
      // ProfileButton(
      //   prefixIcon: Icon(Icons.star, color: contentColor, size: iconSize),
      //   title: lang.rate,
      //   onTap: () {},
      // ),
    ];
  }
}
