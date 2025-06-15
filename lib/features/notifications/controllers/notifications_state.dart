part of 'notifications_cubit.dart';

@immutable
sealed class NotificationsState extends Equatable {
  const NotificationsState();
}

final class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();

  @override
  List<Object?> get props => [];
}

final class NotificationsLoaded extends NotificationsState {
  const NotificationsLoaded({
    required this.notifications,
    required this.hasReachedMax,
  });

  final List<NotificationModel> notifications;
  final bool hasReachedMax;

  @override
  List<Object?> get props => [notifications, hasReachedMax];
}

final class NotificationsFailure extends NotificationsState {
  const NotificationsFailure({required this.error});

  final String error;

  @override
  List<Object?> get props => [error];
}
