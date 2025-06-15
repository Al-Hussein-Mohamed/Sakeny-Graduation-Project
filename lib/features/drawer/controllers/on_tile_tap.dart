import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakeny/common/models/user_model.dart';
import 'package:sakeny/core/APIs/api_auth_services.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/constants/const_text.dart';
import 'package:sakeny/core/providers/settings_provider.dart';
import 'package:sakeny/core/routing/page_route_name.dart';
import 'package:sakeny/core/services/notificaion_services/push_notifications_service.dart';
import 'package:sakeny/core/services/service_locator.dart';
import 'package:sakeny/features/drawer/models/drawer_tile_model.dart';
import 'package:sakeny/features/drawer/screens/widgets/language_bottom_sheet.dart';
import 'package:sakeny/features/drawer/screens/widgets/log_out_dialog.dart';
import 'package:sakeny/features/home/controllers/home_cubit.dart';
import 'package:sakeny/features/profile/edit_profile/models/edit_profile_args.dart';
import 'package:sakeny/features/profile/profile/models/profile_args.dart';

Set<String> guestDisabled = {
  ConstText.drawerMyProfile,
  ConstText.drawerChat,
  ConstText.drawerFavorites,
  ConstText.drawerAddEstate,
};

void drawerEditProfileOnTap(BuildContext context, String routeName) {
  Navigator.pop(context);
  if (routeName == PageRouteNames.editProfile) return;
  final HomeCubit homeCubit = context.read<HomeCubit>();
  if (homeCubit is GuestUser) return;

  final user = (homeCubit.user as AuthenticatedUser).userModel;
  final EditProfileArgs editProfileArgs = EditProfileArgs(user: user!);
  Navigator.pushNamed(context, PageRouteNames.editProfile, arguments: editProfileArgs);
}

void drawerProfilePictureOnTap(BuildContext context, String routeName) {
  Navigator.pop(context);
  _myProfileOnTap(context, routeName);
}

void loginOnTap(BuildContext context) {
  Navigator.pop(context);
  Navigator.pushNamedAndRemoveUntil(
    context,
    PageRouteNames.login,
    (route) => false,
  );
}

void Function() onTileTap(
  BuildContext context,
  DrawerTileModel drawerTile,
  String routeName,
) {
  return () {
    Navigator.pop(context);
    tileTapAction(context, drawerTile, routeName);
  };
}

void tileTapAction(
  BuildContext context,
  DrawerTileModel drawerTile,
  String routeName,
) {
  switch (drawerTile.id) {
    case ConstText.drawerMyProfile:
      _myProfileOnTap(context, routeName);
      break;
    case ConstText.drawerHome:
      _homeOnTap(context, drawerTile, routeName);
      break;
    case ConstText.drawerChat:
      _chatOnTap(context, drawerTile, routeName);
      break;
    case ConstText.drawerFavorites:
      _favoritesOnTap(context, drawerTile, routeName);
      break;
    case ConstText.drawerNotification:
      _onNotificationOnTap(context, drawerTile, routeName);
      break;
    case ConstText.drawerFilters:
      _filtersOnTap(context, drawerTile, routeName);
      break;
    case ConstText.drawerAddEstate:
      _addRealEstateOnTap(context, drawerTile, routeName);
      break;
    case ConstText.drawerLanguage:
      _languageOnTap(context);
      break;
    case ConstText.drawerLogout:
      _logoutOnTap(context, drawerTile, routeName);
      break;
    default:
  }
}

void _homeOnTap(
  BuildContext context,
  DrawerTileModel drawerTile,
  String routeName,
) {
  if (routeName == PageRouteNames.home) return;

  Navigator.popUntil(
    context,
    (route) => route.settings.name == PageRouteNames.home,
  );
}

void _myProfileOnTap(BuildContext context, String routeName) {
  final HomeCubit homeCubit = context.read<HomeCubit>();
  final user = homeCubit.user as AuthenticatedUser;

  if (routeName == PageRouteNames.profile) {
    final prevArgs = ModalRoute.of(context)?.settings.arguments;
    if (prevArgs is ProfileArgs && prevArgs.userId == user.userModel?.userId) {
      return;
    }
  }

  final ProfileArgs profileArgs = ProfileArgs(
    userState: user,
    userId: user.userModel!.userId,
    userName: user.userModel!.fullName,
    userRate: user.userModel!.rate,
    userProfilePictureUrl: user.userModel!.profilePictureURL,
    heroTag: ConstConfig.profilePicTag,
  );

  Navigator.pushNamed(context, PageRouteNames.profile, arguments: profileArgs);
}

void _chatOnTap(
  BuildContext context,
  DrawerTileModel drawerTile,
  String routeName,
) {
  if (routeName == PageRouteNames.allChats) return;
  Navigator.pushNamed(context, PageRouteNames.allChats);
}

void _favoritesOnTap(
  BuildContext context,
  DrawerTileModel drawerTile,
  String routeName,
) {
  if (routeName == PageRouteNames.favorites) return;
  Navigator.pushNamed(context, PageRouteNames.favorites);
}

void _onNotificationOnTap(
  BuildContext context,
  DrawerTileModel drawerTile,
  String routeName,
) {
  if (routeName == PageRouteNames.notifications) return;
  Navigator.pushNamed(context, PageRouteNames.notifications);
}

void _addRealEstateOnTap(
  BuildContext context,
  DrawerTileModel drawerTile,
  String routeName,
) {
  if (routeName == PageRouteNames.addRealEstate) return;
  Navigator.pushNamed(context, PageRouteNames.addRealEstate);
}

void _filtersOnTap(
  BuildContext context,
  DrawerTileModel drawerTile,
  String routeName,
) {
  if (routeName == PageRouteNames.filters) return;
  Navigator.pushNamed(context, PageRouteNames.filters);
}

void _languageOnTap(BuildContext context) {
  final ThemeData theme = Theme.of(context);
  showModalBottomSheet(
    context: context,
    builder: (context) => const LanguageBottomSheet(),
    backgroundColor: theme.scaffoldBackgroundColor,
  );
}

void _logoutOnTap(
  BuildContext context,
  DrawerTileModel drawerTile,
  String routeName,
) async {
  final navigator = Navigator.of(context);

  final res = await showDialog(
    context: context,
    builder: (context) => const LogOutDialog(),
  );

  if (res == true) {
    navigator.pushNamedAndRemoveUntil(
      PageRouteNames.login,
      (route) => false,
    );
    sl<SettingsProvider>().clearToken();
    PushNotificationsService.removeDeviceToken();
  }

  ApiAuthServices.googleSignOut();
}
