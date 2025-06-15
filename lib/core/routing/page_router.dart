import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sakeny/common/models/user_model.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/routing/page_route_name.dart';
import 'package:sakeny/features/Authentication/forget_password/controllers/forget_password_cubit.dart';
import 'package:sakeny/features/Authentication/forget_password/screens/change_password_screen.dart';
import 'package:sakeny/features/Authentication/forget_password/screens/forget_password_OTP_screen.dart';
import 'package:sakeny/features/Authentication/forget_password/screens/forget_password_screen.dart';
import 'package:sakeny/features/Authentication/login/controllers/login_cubit.dart';
import 'package:sakeny/features/Authentication/login/screens/login_screen.dart';
import 'package:sakeny/features/Authentication/register/controllers/register_cubit.dart';
import 'package:sakeny/features/Authentication/register/screens/register_screen.dart';
import 'package:sakeny/features/addrealstate/controllers/add_real_estate_cubit.dart';
import 'package:sakeny/features/addrealstate/screens/add_estate_screen.dart';
import 'package:sakeny/features/addrealstate/screens/add_real_estate_screen.dart';
import 'package:sakeny/features/chat/all_chats/controllers/all_chats_cubit.dart';
import 'package:sakeny/features/chat/all_chats/screens/all_chats_screens.dart';
import 'package:sakeny/features/chat/chat_screen/controllers/chat_cubit.dart';
import 'package:sakeny/features/chat/chat_screen/models/chat_args.dart';
import 'package:sakeny/features/chat/chat_screen/screens/chat_screen.dart';
import 'package:sakeny/features/favorites/compare/controllers/compare_cubit.dart';
import 'package:sakeny/features/favorites/compare/screens/compare_screen.dart';
import 'package:sakeny/features/favorites/screens/favorites_screen.dart';
import 'package:sakeny/features/filters/controllers/filter_cubit.dart';
import 'package:sakeny/features/filters/screens/filters_screen.dart';
import 'package:sakeny/features/home/controllers/app_bar_positions.dart';
import 'package:sakeny/features/home/controllers/home_cubit.dart';
import 'package:sakeny/features/home/screens/home_screen.dart';
import 'package:sakeny/features/internet_connection_lost/screens/internet_connection_lost_screen.dart';
import 'package:sakeny/features/maps/map_select_location/controllers/map_overlay_controls_cubit.dart';
import 'package:sakeny/features/maps/map_select_location/controllers/map_search_cubit.dart';
import 'package:sakeny/features/maps/map_select_location/controllers/map_select_location_cubit.dart';
import 'package:sakeny/features/maps/map_select_location/models/map_select_location_args.dart';
import 'package:sakeny/features/maps/map_select_location/screens/map_select_location_screen.dart';
import 'package:sakeny/features/maps/map_show_units/controllers/map_show_units_cubit.dart';
import 'package:sakeny/features/maps/map_show_units/models/map_show_units_args.dart';
import 'package:sakeny/features/maps/map_show_units/screens/map_show_units_screen.dart';
import 'package:sakeny/features/notifications/controllers/notifications_cubit.dart';
import 'package:sakeny/features/notifications/screens/notifications_screen.dart';
import 'package:sakeny/features/onboarding/controllers/onboarding_cubit.dart';
import 'package:sakeny/features/onboarding/screens/onboarding_screen.dart';
import 'package:sakeny/features/post/posts/controllers/post_cubit.dart';
import 'package:sakeny/features/post/posts/models/post_model.dart';
import 'package:sakeny/features/profile/edit_profile/controllers/edit_profile_cubit.dart';
import 'package:sakeny/features/profile/edit_profile/models/edit_profile_args.dart';
import 'package:sakeny/features/profile/edit_profile/screens/edit_profile_screen.dart';
import 'package:sakeny/features/profile/profile/controllers/profile_cubit.dart';
import 'package:sakeny/features/profile/profile/models/profile_args.dart';
import 'package:sakeny/features/profile/profile/screens/profile_screen.dart';
import 'package:sakeny/features/unit/controllers/unit_cubit.dart';
import 'package:sakeny/features/unit/screens/unit_screen.dart';

class PageRouter {
  static late ForgetPasswordCubit forgetPasswordCubit;
  static late HomeCubit homeCubit;

  static defaultRoute() => CustomMaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => LoginCubit(),
          child: const LoginScreen(),
        ),
        settings: const RouteSettings(name: PageRouteNames.login),
      );

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case PageRouteNames.onboarding:
        return CustomMaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => OnboardingCubit(),
            child: const OnboardingScreen(),
          ),
          settings: settings,
        );

      case PageRouteNames.login:
        return CustomMaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => LoginCubit(),
            child: const LoginScreen(),
          ),
          settings: settings,
        );

      case PageRouteNames.register:
        return CustomMaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => RegisterCubit(),
            child: const RegisterScreen(),
          ),
          settings: settings,
        );

      case PageRouteNames.forgotPassword:
        forgetPasswordCubit = ForgetPasswordCubit();
        return CustomMaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => forgetPasswordCubit,
            child: const ForgetPassword(),
          ),
          settings: settings,
        );

      case PageRouteNames.forgotPasswordOTP:
        return CustomMaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: forgetPasswordCubit,
            child: const ForgetPasswordOTPScreen(),
          ),
          settings: settings,
        );

      case PageRouteNames.changePassword:
        return CustomMaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: forgetPasswordCubit,
            child: const ChangePasswordScreen(),
          ),
          settings: settings,
        );

      case PageRouteNames.home:
        homeCubit = HomeCubit();
        return CustomMaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: homeCubit),
              BlocProvider(create: (_) => PostCubit(postContent: PostContent.home)),
            ],
            child: ChangeNotifierProvider(
              create: (context) => AppBarPositions(),
              child: const HomeScreen(),
            ),
          ),
          settings: settings,
        );

      case PageRouteNames.unit:
        final PostModel post = settings.arguments as PostModel;
        return CustomMaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: homeCubit),
              BlocProvider(
                create: (context) =>
                    UnitCubit(unitId: post.unit.unitId, ownerId: post.unit.ownerId),
              ),
            ],
            child: UnitScreen(post: post),
          ),
          settings: settings,
        );

      case PageRouteNames.editProfile:
        final EditProfileArgs editProfileArgs = settings.arguments as EditProfileArgs;
        return CustomMaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: homeCubit),
              BlocProvider(create: (_) => EditProfileCubit(user: editProfileArgs.user)),
            ],
            child: const EditProfileScreen(),
          ),
          settings: settings,
        );

      case PageRouteNames.profile:
        final profileArgs = settings.arguments as ProfileArgs;

        return CustomMaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: homeCubit),
              BlocProvider(
                create: (_) => PostCubit(
                  postContent: PostContent.profile,
                  userId: profileArgs.userId,
                ),
              ),
              BlocProvider(create: (context) => ProfileCubit()),
            ],
            child: ProfileScreen(profileArgs: profileArgs),
          ),
          settings: settings,
        );

      case PageRouteNames.favorites:
        return CustomMaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: homeCubit),
              BlocProvider(create: (_) => PostCubit(postContent: PostContent.favorites)),
            ],
            child: const FavoritesScreen(),
          ),
          settings: settings,
        );

      case PageRouteNames.compare:
        return CustomMaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: homeCubit),
              BlocProvider(create: (_) => CompareCubit()),
            ],
            child: const CompareScreen(),
          ),
          settings: settings,
        );

      case PageRouteNames.addRealEstate:
        return CustomMaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: homeCubit),
              BlocProvider(create: (_) => AddRealEstateCubit()),
            ],
            child: const AddRealEstateScreen(),
          ),
          settings: settings,
        );

      case PageRouteNames.addEstateScreen:
        return CustomMaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: homeCubit),
              BlocProvider(create: (_) => AddRealEstateCubit()),
            ],
            child: const AddEstateScreen(),
          ),
          settings: settings,
        );

      case PageRouteNames.filters:
        return CustomMaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: homeCubit),
              BlocProvider(create: (_) => FiltersCubit()),
            ],
            child: const FiltersScreen(),
          ),
          settings: settings,
        );

      case PageRouteNames.mapSelectLocation:
        final MapSelectLocationArgs? args = settings.arguments as MapSelectLocationArgs?;
        return CustomMaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => MapSelectLocationCubit(args)),
              BlocProvider(create: (context) => MapSearchCubit()),
              BlocProvider(create: (context) => MapOverlayControlsCubit(args)),
            ],
            child: const MapSelectLocationScreen(),
          ),
          settings: settings,
        );

      case PageRouteNames.mapShowUnits:
        final MapShowUnitsArgs? args = settings.arguments as MapShowUnitsArgs?;
        return CustomMaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: homeCubit),
              BlocProvider(create: (context) => MapShowUnitsCubit(args: args)),
            ],
            child: const MapShowUnitsScreen(),
          ),
          settings: settings,
        );

      case PageRouteNames.allChats:
        final user = homeCubit.user;
        if (user is! AuthenticatedUser) return defaultRoute();
        final String myId = (user).userModel!.userId;
        return CustomMaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: homeCubit),
              BlocProvider(create: (context) => AllChatsCubit(myId: myId)),
            ],
            child: const AllChatsScreens(),
          ),
          settings: settings,
        );

      case PageRouteNames.chat:
        final chatArgs = settings.arguments as ChatArgs;
        return CustomMaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => ChatCubit(args: chatArgs),
            child: ChatScreen(args: chatArgs),
          ),
          settings: settings,
        );

      case PageRouteNames.internetConnectionLost:
        return CustomMaterialPageRoute(
          builder: (context) => const InternetConnectionLostScreen(),
          settings: settings,
        );

      case PageRouteNames.notifications:
        return CustomMaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: homeCubit),
              BlocProvider(create: (context) => NotificationsCubit()),
            ],
            child: const NotificationsScreen(),
          ),
          settings: settings,
        );

      default:
        if (kDebugMode) {
          print("❌ No route defined for ${settings.name}");
        }
        return CustomMaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => LoginCubit(),
            child: const LoginScreen(),
          ),
          settings: settings,
        );
    }
  }
}

class CustomMaterialPageRoute<T> extends MaterialPageRoute<T> {
  CustomMaterialPageRoute({
    required super.builder,
    required super.settings,
    this.customTransitionDuration = ConstConfig.navigationDuration,
    this.customReverseTransitionDuration = ConstConfig.navigationDuration,
  });

  final Duration customTransitionDuration;
  final Duration customReverseTransitionDuration;

  @override
  Duration get transitionDuration => customTransitionDuration;

  @override
  Duration get reverseTransitionDuration => customReverseTransitionDuration;
}
