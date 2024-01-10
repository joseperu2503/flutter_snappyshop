import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/router/app_router.dart';

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, NotificationsState>((ref) {
  return NotificationsNotifier();
});

class NotificationsNotifier extends StateNotifier<NotificationsState> {
  NotificationsNotifier() : super(NotificationsState());

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  initNotificationStatus() async {
    _setupInteractedMessage();
    await requestPermission();
    _getToken();
    _onForegroundMessage();
  }

  Future<void> getStatus() async {
    final settings = await messaging.getNotificationSettings();
    state = state.copyWith(
      status: settings.authorizationStatus,
    );
  }

  Future<void> _getToken() async {
    if (state.status != AuthorizationStatus.authorized) return;
    final token = await messaging.getToken();
    print(token);
  }

  void _onForegroundMessage() {
    //cuando la aplicacion esta siendo usada, en primer plano
    FirebaseMessaging.onMessage.listen(_handleRemoteMessage);
  }

  void _handleRemoteMessage(RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  }

  Future<void> requestPermission() async {
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

  //configuracion de las interacciones con las notificaciones

  // Se supone que todos los mensajes contienen un campo de datos con la key 'type'
  Future<void> _setupInteractedMessage() async {
    // Recibe cualquier mensaje que provocó que la aplicación se abriera desde
    // un estado terminado.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // Si el mensaje también contiene una propiedad de datos con un "type" de "chat",
    // navegar a una pantalla de chat
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // También maneja cualquier interacción cuando la aplicación
    // está en segundo plano a través de un Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'product' &&
        message.data['productId'] != null) {
      appRouter.push('/product/${message.data['productId']}');
    }
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

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Si vas a utilizar otros servicios de Firebase en segundo plano, como Firestore,
  // asegúrate de llamar a `initializeApp` antes de usar otros servicios de Firebase.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}
