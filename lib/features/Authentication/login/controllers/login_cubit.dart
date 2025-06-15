import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sakeny/core/APIs/api_auth_services.dart';
import 'package:sakeny/core/providers/settings_provider.dart';
import 'package:sakeny/core/routing/page_route_name.dart';
import 'package:sakeny/core/services/notificaion_services/push_notifications_service.dart';
import 'package:sakeny/core/services/service_locator.dart';
import 'package:sakeny/features/Authentication/login/models/sign_in_params.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  bool rememberMe = false;

  void setRememberMe(bool value) {
    rememberMe = value;
  }

  void unfocus() {
    emailFocusNode.unfocus();
    passwordFocusNode.unfocus();
  }

  void signIn() async {
    unfocus();
    if (formKey.currentState!.validate() == false) return;

    emit(LoginLoading());
    EasyLoading.show();

    await ApiAuthServices.signIn(
      signInParams: SignInParams(
        email: emailController.text,
        password: passwordController.text,
        rememberMe: rememberMe,
      ),
    ).then((res) {
      res.fold((error) {
        emit(LoginFailed(errorMessage: error));
      }, (data) {
        sl<SettingsProvider>().setToken(
          data.data["accessToken"],
          data.data["refreshToken"],
          data.data["userId"],
          rememberMe,
        );
        PushNotificationsService.addDeviceToken();
        emit(LoginSuccess());
      });
    });

    EasyLoading.dismiss();
  }

  void signInWithGoogle() async {
    try {
      final account = await ApiAuthServices.getGoogleAccount();
      if (account == null) {
        log("User cancelled the sign-in process");
        return;
      }

      final auth = await account.authentication;
      final String? idToken = auth.idToken;
      if (idToken == null) {
        log("Failed to retrieve Google ID Token.");
        return;
      }

      log("Google Token: $idToken");

      unfocus();
      emit(LoginLoading());
      EasyLoading.show();

      final res = await ApiAuthServices.signInWithGoogle(idToken: idToken, rememberMe: rememberMe);
      res.fold((error) {
        emit(LoginFailed(errorMessage: error));
      }, (json) {
        sl<SettingsProvider>().setToken(
          json["token"] as String,
          json["refreshToken"] as String,
          json["userId"] as String,
          rememberMe,
        );
        emit(LoginSuccess());
        PushNotificationsService.addDeviceToken();
      });
    } catch (e) {
      emit(LoginFailed(errorMessage: e.toString()));
    } finally {
      EasyLoading.dismiss();
    }
  }

  // Navigation
  void clearFocus() {
    emailFocusNode.unfocus();
    passwordFocusNode.unfocus();
  }

  void goToOnboarding(BuildContext context) {
    clearFocus();
    Navigator.pushReplacementNamed(context, PageRouteNames.onboarding);
  }

  void goToRegister(BuildContext context) async {
    clearFocus();
    final args = await Navigator.pushNamed(context, PageRouteNames.register);
    if (args != null &&
        args is Map<String, dynamic> &&
        args["email"] != null &&
        args["password"] != null) {
      emailController.text = args["email"];
      passwordController.text = args["password"];
    }
  }

  void goToHome(BuildContext context) {
    clearFocus();
    Navigator.pushNamedAndRemoveUntil(
      context,
      PageRouteNames.home,
      (route) => false,
    );
  }

  void goToForgetPassword(BuildContext context) {
    clearFocus();

    final Map<String, dynamic> args = {};
    args["email"] = emailController.text;

    Navigator.pushNamed(context, PageRouteNames.forgotPassword, arguments: args);
  }

  @override
  Future<void> close() async {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.close();
  }
}
