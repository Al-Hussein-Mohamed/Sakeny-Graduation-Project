import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakeny/core/APIs/api_notifications.dart';
import 'package:sakeny/features/notifications/models/notificatnion_model.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(const NotificationsLoading()) {
    _getNotifications();
    scrollController.addListener(_pagination);
  }

  @override
  Future close() async {
    scrollController.removeListener(_pagination);
    super.close();
  }

  static NotificationsCubit of(BuildContext context) => context.read<NotificationsCubit>();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final scrollController = ScrollController();
  final int _pageSize = 20;
  int _pageIndex = 1;
  bool _isLoading = false;

  void _pagination() {
    if (scrollController.hasClients == false) return;
    if (scrollController.position.pixels < scrollController.position.maxScrollExtent - 300) return;

    _getNotifications();
  }

  void _getNotifications() async {
    if (state is NotificationsFailure) return;
    if (state is NotificationsLoaded && (state as NotificationsLoaded).hasReachedMax) return;
    if (_isLoading) return;
    _isLoading = true;
    // await Future.delayed(Duration(seconds: 3));
    // emit(const NotificationsLoaded(notifications: [], hasReachedMax: false));
    // return;

    final List<NotificationModel> notifications =
        (state is NotificationsLoaded) ? (state as NotificationsLoaded).notifications : [];

    final res = await ApiNotifications.getAllNotifications(
      pageIndex: _pageIndex,
      pageSize: _pageSize,
    );

    res.fold(
      (error) => emit(NotificationsFailure(error: error)),
      (newNotificationList) {
        _pageIndex++;
        final hasReachedMax = newNotificationList.length < _pageSize;
        emit(NotificationsLoaded(
          notifications: [...notifications, ...newNotificationList],
          hasReachedMax: hasReachedMax,
        ));
      },
    );

    _isLoading = false;
  }
}
