import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sakeny/common/models/user_model.dart';
import 'package:sakeny/common/widgets/custom_elevated_button.dart';
import 'package:sakeny/common/widgets/view_profile_picture.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/constants/const_images.dart';
import 'package:sakeny/core/routing/page_route_name.dart';
import 'package:sakeny/features/drawer/controllers/on_tile_tap.dart';
import 'package:sakeny/features/home/controllers/home_cubit.dart';
import 'package:sakeny/generated/l10n.dart';
import 'package:shimmer/shimmer.dart';

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeCubit homeCubit = context.read<HomeCubit>();

    switch (homeCubit.user) {
      case GuestUser():
        return const _GuestHeader();
      case AuthenticatedUser():
        return BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            switch (state) {
              case HomeLoading():
                return const _AuthedUserHeaderShimmer();

              case HomeLoaded():
                return _AuthedUserHeader(user: (state.user as AuthenticatedUser).userModel!);

              case HomeFailure():
                return Center(child: Text(state.error));
            }
          },
        );
    }
  }
}

class _GuestHeader extends StatelessWidget {
  const _GuestHeader();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final S lang = S.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
      child: Column(
        children: [
          _GuestButton(
            title: lang.signIn,
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, PageRouteNames.login, (route) => false);
            },
          ),
          const SizedBox(height: 4),
          _GuestButton(
            title: lang.signUp,
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, PageRouteNames.login, (route) => false);
              Navigator.pushNamed(context, PageRouteNames.register);
            },
          ),
          // Divider(),
          const SizedBox(height: 8),
          Text(
            lang.guestSignInMessage,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 10.spMin,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            lang.guestSignUpMessage,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 10.spMin,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _GuestButton extends StatelessWidget {
  const _GuestButton({required this.title, required this.onTap});

  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: CustomElevatedButton(
        isPrimary: true,
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(),
          shape: RoundedRectangleBorder(borderRadius: ConstConfig.borderRadius),
          maximumSize: const Size(double.infinity, 40),
          minimumSize: const Size(double.infinity, 40),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white, fontSize: 15.spMin),
        ),
      ),
    );
  }
}

class _AuthedUserHeader extends StatelessWidget {
  const _AuthedUserHeader({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          _AuthedProfilePicture(userProfilePictureUrl: user.profilePictureURL),
          _AuthedHeaderContent(
            user: user,
          ),
        ],
      ),
    );
  }
}

class _AuthedProfilePicture extends StatelessWidget {
  const _AuthedProfilePicture({required this.userProfilePictureUrl});

  final String? userProfilePictureUrl;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Set<String> blackList = {
      PageRouteNames.editProfile,
      PageRouteNames.profile,
    };

    final double profilePictureSize = 80;

    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 12, end: 10),
      child: Material(
        elevation: ConstConfig.smallElevation,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: () =>
              drawerProfilePictureOnTap(context, ModalRoute.of(context)?.settings.name ?? ""),
          child: Hero(
            tag: blackList.contains(ModalRoute.of(context)?.settings.name)
                ? "blah blah"
                : ConstConfig.profilePicTag,
            child: ViewProfilePicture(
              profilePictureURL: userProfilePictureUrl,
              profilePictureSize: profilePictureSize,
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthedHeaderContent extends StatelessWidget {
  const _AuthedHeaderContent({required this.user});

  final UserModel user;

  static final _editProfileIcon = SvgPicture.asset(
    ConstImages.drawerEditProfile,
  );

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final S lang = S.of(context);

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            child: Text(
              user.fullName,
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            user.phoneNumber,
            maxLines: 1,
            style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 3),
          Text(
            user.email,
            maxLines: 1,
            style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: Material(
              color: ConstColors.drawerButton,
              shape: RoundedRectangleBorder(
                borderRadius: ConstConfig.smallBorderRadius,
                side: const BorderSide(color: Colors.white, width: .5),
              ),
              child: InkWell(
                onTap: () =>
                    drawerEditProfileOnTap(context, ModalRoute.of(context)?.settings.name ?? ""),
                borderRadius: ConstConfig.smallBorderRadius,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _editProfileIcon,
                      const SizedBox(width: 5),
                      Text(
                        lang.profileEdit,
                        style: const TextStyle().copyWith(
                          color: Colors.white,
                          fontSize: 11.spMin,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthedUserHeaderShimmer extends StatelessWidget {
  const _AuthedUserHeaderShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          _ShimmerProfilePicture(),
          _ShimmerHeaderContent(),
        ],
      ),
    );
  }
}

class _ShimmerProfilePicture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 12, end: 10),
      child: CircleAvatar(
          radius: 40,
          backgroundColor: theme.scaffoldBackgroundColor,
          child: Image.asset(
            ConstImages.profilePic,
            fit: BoxFit.cover,
          )),
    );
  }
}

class _ShimmerHeaderContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 100,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 150,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 100,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: ConstConfig.smallBorderRadius,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
