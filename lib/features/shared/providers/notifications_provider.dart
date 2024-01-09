import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, NotificationsState>((ref) {
  return NotificationsNotifier();
});

class NotificationsNotifier extends StateNotifier<NotificationsState> {
  NotificationsNotifier() : super(NotificationsState());

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  initialStatusCheck() async {
    final settings = await messaging.getNotificationSettings();
    state = state.copyWith(
      status: settings.authorizationStatus,
    );
    _getToken();
    _onForegroundMessage();
  }

  void _getToken() async {
    if (state.status != AuthorizationStatus.authorized) return;

    final token = await messaging.getToken();
    print(token);
  }

  void _handleRemoteMessage(RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  }

  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(_handleRemoteMessage);
  }

  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    state = state.copyWith(
      status: settings.authorizationStatus,
    );
    _getToken();
  }
}

class NotificationsState {
  final List<dynamic> notifications;
  final AuthorizationStatus status;

  NotificationsState({
    this.notifications = const [],
    this.status = AuthorizationStatus.notDetermined,
  });

  NotificationsState copyWith({
    List<dynamic>? notifications,
    AuthorizationStatus? status,
  }) =>
      NotificationsState(
        notifications: notifications ?? this.notifications,
        status: status ?? this.status,
      );
}
