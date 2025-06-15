part of 'home_cubit.dart';

@immutable
sealed class HomeState {
  const HomeState();
}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  const HomeLoaded({required this.user});

  final UserAuthState user;
}

final class HomeFailure extends HomeState {
  const HomeFailure(this.error);

  final String error;
}
