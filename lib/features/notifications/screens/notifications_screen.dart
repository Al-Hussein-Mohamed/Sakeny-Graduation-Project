import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakeny/common/widgets/custom_circle_progress_indicator.dart';
import 'package:sakeny/common/widgets/custom_scaffold.dart';
import 'package:sakeny/core/services/overlays/toastification_service.dart';
import 'package:sakeny/features/notifications/controllers/notifications_cubit.dart';
import 'package:sakeny/features/notifications/models/notificatnion_model.dart';
import 'package:sakeny/features/notifications/widgets/notification_tile.dart';
import 'package:sakeny/generated/l10n.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationsCubit = NotificationsCubit.of(context);
    final lang = S.of(context);
    return CustomScaffold(
      scaffoldKey: notificationsCubit.scaffoldKey,
      screenTitle: lang.drawerNotification,
      openDrawer: () => notificationsCubit.scaffoldKey.currentState?.openEndDrawer(),
      onBack: () => Navigator.pop(context),
      body: const _NotificationBody(),
    );
  }
}

class _NotificationBody extends StatelessWidget {
  const _NotificationBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        switch (state) {
          case NotificationsLoading():
            return const CustomCircleProgressIndicator();

          case NotificationsLoaded():
            return _NotificationsLoaded(
              notifications: state.notifications,
              hasReachedMax: state.hasReachedMax,
            );

          case NotificationsFailure():
            ToastificationService.showGlobalSomethingWentWrongToast();
            return Center(child: Text(state.error));
        }
      },
    );
  }
}

class _NotificationsLoaded extends StatelessWidget {
  const _NotificationsLoaded({required this.notifications, required this.hasReachedMax});

  final List<NotificationModel> notifications;
  final bool hasReachedMax;

  @override
  Widget build(BuildContext context) {
    final notificationsCubit = NotificationsCubit.of(context);
    final textTheme = Theme.of(context).textTheme;
    final lang = S.of(context);

    if (notifications.isEmpty) {
      return Center(
        child: Text(lang.emptyNotificationsTitle, style: textTheme.titleMedium),
      );
    }

    return ListView.builder(
      controller: notificationsCubit.scrollController,
      itemCount: notifications.length + (hasReachedMax ? 0 : 1),
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemBuilder: (context, index) {
        if (index == notifications.length - 1 && !hasReachedMax) {
          return const CustomCircleProgressIndicator();
        }
        return NotificationTile(notification: notifications[index]);
      },
    );
  }
}
