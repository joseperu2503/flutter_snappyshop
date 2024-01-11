import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/shared/providers/snackbar_provider.dart';
import 'package:flutter_snappyshop/features/shared/services/key_value_storage_service.dart';
import 'package:flutter_snappyshop/features/settings/services/notification_service.dart';

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  return NotificationNotifier(ref);
});

class NotificationNotifier extends StateNotifier<NotificationState> {
  NotificationNotifier(this.ref) : super(NotificationState());
  final StateNotifierProviderRef ref;

  getNotificationsEnabled() async {
    bool? notificationsEnabled = await KeyValueStorageService()
        .getKeyValue<bool>('notificationsEnabled');

    notificationsEnabled ??= false;
    state = state.copyWith(
      notificationsEnabled: notificationsEnabled,
    );
  }

  //alterna el estado de las notificaciones
  toggleNotificationsEnabled() async {
    await getNotificationsEnabled();
    if (state.notificationsEnabled) {
      await disableNotifications();
    } else {
      await enableNotifications();
    }
  }

  //deshabilita las notificaciones
  disableNotifications() async {
    state = state.copyWith(
      notificationsEnabled: false,
    );
    KeyValueStorageService().setKeyValue<bool>('notificationsEnabled', false);
    NotificationService().deleteToken();
  }

  //habilita las notificaciones
  enableNotifications() async {
    state = state.copyWith(
      notificationsEnabled: true,
    );
    await KeyValueStorageService()
        .setKeyValue<bool>('notificationsEnabled', true);

    try {
      await NotificationService().initNotifications();
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
      disableNotifications();
    }
  }
}

class NotificationState {
  final bool notificationsEnabled;

  NotificationState({
    this.notificationsEnabled = false,
  });

  NotificationState copyWith({
    bool? notificationsEnabled,
  }) =>
      NotificationState(
        notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      );
}
