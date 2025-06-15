part of 'forget_password_cubit.dart';

@immutable
sealed class ForgetPasswordState {}

final class ForgetPasswordInitial extends ForgetPasswordState {}

// ---------------------> Forget Password Screen <----------------------------
final class ForgetPasswordEmailSuccess extends ForgetPasswordState {}

final class ForgetPasswordEmailFailure extends ForgetPasswordState {
  ForgetPasswordEmailFailure({this.error = "Something went wrong!"});

  final String error;
}

// --------------------> OTP Screen <----------------------------------
final class ForgetPasswordOtpInitial extends ForgetPasswordState {}

final class ForgetPasswordOtpRefresh extends ForgetPasswordState {}

final class ForgetPasswordResendOtpSuccess extends ForgetPasswordState {}

final class ForgetPasswordOtpSuccess extends ForgetPasswordState {}

final class ForgetPasswordOtpFailure extends ForgetPasswordState {
  ForgetPasswordOtpFailure({this.error = "Something went wrong!"});

  final String error;
}

// -------------------> Change password screen <--------------------------------
final class ChangePasswordSuccess extends ForgetPasswordState {}

final class ChangePasswordFailure extends ForgetPasswordState {
  ChangePasswordFailure({this.error = "Something went wrong!"});

  final String error;
}
