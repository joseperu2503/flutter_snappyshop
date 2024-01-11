import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_snappyshop/config/api/api.dart';
import 'package:flutter_snappyshop/config/router/app_router.dart';
import 'package:flutter_snappyshop/features/shared/models/save_snappy_token_response.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';

final api = Api();
final FirebaseMessaging messaging = FirebaseMessaging.instance;

class NotificationService {
  static Future<SaveSnappyTokenResponse> saveSnappyToken({
    required String token,
  }) async {
    try {
      Map<String, dynamic> form = {
        "token": token,
      };

      final response = await api.post('/snappytoken', data: form);

      return SaveSnappyTokenResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.data['message'] != null) {
        throw ServiceException(e.response?.data['message']);
      }
      throw ServiceException('An error occurred while saving the SnappyToken.');
    } catch (e) {
      throw ServiceException('An error occurred while saving the SnappyToken.');
    }
  }

  initNotifications() async {
    final settings = await requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final token = await messaging.getToken();
      if (token != null) {
        try {
          await saveSnappyToken(token: token);
        } on ServiceException catch (e) {
          throw ServiceException(e.message);
        }
      } else {
        throw ServiceException('An error occurred while obtaining the token.');
      }
    } else {
      throw ServiceException('Notification permissions not authorized.');
    }
  }

  initListeners() {
    _onForegroundMessage();
    _setupInteractedMessage();
  }

  Future<NotificationSettings> getStatus() async {
    return await messaging.getNotificationSettings();
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

  Future<NotificationSettings> requestPermission() async {
    return await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
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

  Future<void> deleteToken() async {
    await messaging.deleteToken();
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Si vas a utilizar otros servicios de Firebase en segundo plano, como Firestore,
  // asegúrate de llamar a `initializeApp` antes de usar otros servicios de Firebase.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}
