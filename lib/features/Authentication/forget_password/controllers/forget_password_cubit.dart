import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sakeny/core/APIs/api_auth_services.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/routing/page_route_name.dart';
import 'package:sakeny/features/Authentication/forget_password/models/change_password_params.dart';
import 'package:sakeny/features/Authentication/forget_password/models/verify_otp_params.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit() : super(ForgetPasswordInitial());

  @override
  Future<void> close() {
    emailController.dispose();
    for (final controller in otpFieldControllers) {
      controller.dispose();
    }
    for (final node in otpFieldFocusNodes) {
      node.dispose();
    }
    return super.close();
  }

  //------------------------> Forget Password Screen <--------------------------

  final GlobalKey<FormState> forgetPasswordFormKey =
      GlobalKey<FormState>(debugLabel: 'forgetPasswordForm');
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();

  void goToForgetPasswordVerification(BuildContext context) {
    emailFocusNode.unfocus();
    Navigator.pushNamed(context, PageRouteNames.forgotPasswordOTP);
  }

  void fetchEmail(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    // print(args);

    if (args != null && args is Map<String, dynamic>) {
      emailController.text = args["email"] ?? "noEmail";
    }
  }

  void sendEmail() async {
    final bool isValid = forgetPasswordFormKey.currentState!.validate();
    if (isValid == false) return;

    EasyLoading.show();
    await ApiAuthServices.forgetPassword(email: emailController.text).then(
      (res) {
        res.fold(
          (error) {
            emit(ForgetPasswordEmailFailure(error: error));
          },
          (r) {
            initOtp();
            email = emailController.text;
            emit(ForgetPasswordEmailSuccess());
          },
        );
      },
    );
    EasyLoading.dismiss();
  }

  // ---------------------> OTP Screen <--------------------------
  static final _otpLength = 4;
  final GlobalKey<FormState> forgetPasswordOTPFormKey =
      GlobalKey<FormState>(debugLabel: 'forgetPasswordOTPForm');
  List<TextEditingController> otpFieldControllers =
      List.generate(_otpLength, (_) => TextEditingController());
  List<FocusNode> otpFieldFocusNodes = List.generate(_otpLength, (_) => FocusNode());
  List<bool> hasError = List.filled(_otpLength, false);

  late String email;

  void setHasError(int idx, bool value) {
    if (hasError[idx] == value) return;
    hasError[idx] = value;
    emit(ForgetPasswordOtpRefresh());
  }

  void initOtp() {
    for (int i = 0; i < _otpLength; i++) {
      hasError[i] = false;
      otpFieldControllers[i].clear();
      otpFieldFocusNodes[i].unfocus();
    }
  }

  void checkOtp() {
    for (int i = 0; i < _otpLength; i++) {
      if (otpFieldControllers[i].text.isEmpty) return;
    }

    verifyOTP();
  }

  void goToChangePassword(BuildContext context) {
    for (final f in otpFieldFocusNodes) {
      f.unfocus();
    }

    Navigator.pushNamed(context, PageRouteNames.changePassword);
  }

  void verifyOTP() async {
    for (int i = 0; i < otpFieldFocusNodes.length; i++) {
      otpFieldFocusNodes[i].unfocus();
    }

    if (forgetPasswordOTPFormKey.currentState!.validate() == false) return;

    EasyLoading.show();

    await ApiAuthServices.verifyOtp(
      verifyOtpParams: VerifyOtpParams(
        email: email,
        otpList: otpFieldControllers.map((e) => int.parse(e.text)).toList(),
      ),
    ).then(
      (res) {
        res.fold(
          (error) {
            emit(ForgetPasswordOtpFailure(error: error));
            initOtp();
          },
          (r) {
            emit(ForgetPasswordOtpSuccess());
            Future.delayed(ConstConfig.navigationDuration, initOtp);
          },
        );
      },
    );

    EasyLoading.dismiss();
  }

  Future<void> resendOTP() async {
    EasyLoading.show();
    await ApiAuthServices.forgetPassword(email: email).then(
      (res) {
        res.fold(
          (error) => emit(ForgetPasswordOtpFailure(error: error)),
          (r) => emit(ForgetPasswordResendOtpSuccess()),
        );
      },
    );
    EasyLoading.dismiss();
  }

  // ---------------------> change password screen <--------------------------------

  final GlobalKey<FormState> changePasswordFormKey =
      GlobalKey<FormState>(debugLabel: 'changePasswordForm');

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  void changePassword() async {
    final bool isValid = changePasswordFormKey.currentState!.validate();
    if (isValid == false) return;

    if (passwordController.text != confirmPasswordController.text) {
      emit(ChangePasswordFailure(error: "Passwords don't match!"));
      return;
    }

    EasyLoading.show();
    await ApiAuthServices.changePassword(
      changePasswordParams: ChangePasswordParams(
        email: email,
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
      ),
    ).then(
      (res) {
        res.fold(
          (error) => emit(ChangePasswordFailure()),
          (r) => emit(ChangePasswordSuccess()),
        );
      },
    );
    EasyLoading.dismiss();
  }

  void exit(BuildContext context) {
    final Set<String> popScreens = {
      PageRouteNames.forgotPassword,
      PageRouteNames.forgotPasswordOTP,
      PageRouteNames.changePassword,
    };

    Future.microtask(
      () {
        Navigator.popUntil(
          context,
          (route) => !popScreens.contains(route.settings.name),
        );
      },
    );
  }
}
