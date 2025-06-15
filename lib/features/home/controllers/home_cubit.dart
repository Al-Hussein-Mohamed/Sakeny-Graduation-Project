import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakeny/common/models/user_model.dart';
import 'package:sakeny/core/APIs/api_service.dart';
import 'package:sakeny/core/providers/settings_provider.dart';
import 'package:sakeny/core/services/service_locator.dart';
import 'package:sakeny/features/filters/models/filters_parameters_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeLoading()) {
    final SettingsProvider settings = sl<SettingsProvider>();
    user = settings.user;
  }

  static HomeCubit of(BuildContext context) => context.read<HomeCubit>();

  final TextEditingController searchController = TextEditingController();
  FiltersParametersModel filtersParams = FiltersParametersModel();

  // void collapseAppBar() {
  //   appBarPosition.scrollController.animateTo(
  //     appBarPosition.appBarMaxHeight - appBarPosition.appBarMinHeight,
  //     duration: const Duration(milliseconds: 300),
  //     curve: Curves.easeInOut,
  //   );
  // }

  // void expandAppBar() {
  //   appBarPosition.scrollController.animateTo(
  //     0,
  //     duration: const Duration(milliseconds: 300),
  //     curve: Curves.easeInOut,
  //   );
  // }

  void scrollOnSearchTap() {
    // collapseAppBar();
  }

  late UserAuthState user;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> getUserData() async {
    if (user is! AuthenticatedUser) return;
    await ApiService.getUserData().then((res) {
      res.fold(
        (error) => emit(HomeFailure(error)),
        (json) {
          user = (user as AuthenticatedUser).copyWith(userModel: UserModel.fromJson(json));
          emit(HomeLoaded(user: user));
        },
      );
    });
  }
}
