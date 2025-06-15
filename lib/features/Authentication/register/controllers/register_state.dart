part of 'register_cubit.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}
final class RegisterLoading extends RegisterState {}
final class RegisterSuccess extends RegisterState {}
final class RegisterFailed extends RegisterState {

  RegisterFailed({this.errorMessage = "Register failed"});
  final String errorMessage;
}

