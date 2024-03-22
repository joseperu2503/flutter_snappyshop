import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static initEnvironment() async {
    await dotenv.load(fileName: ".env");
  }

  static String urlBase = dotenv.env['URL_BASE'] ?? 'No URL_BASE';
  static String urlImages = dotenv.env['URL_IMAGES'] ?? 'No URL_IMAGES';
  static String googleClientIdOAuthServer =
      dotenv.env['GOOGLE_CLIENT_ID_OAUTH_SERVER'] ??
          'No GOOGLE_CLIENT_ID_OAUTH_SERVER';
  static String googleClientIdOAuthAndroid =
      dotenv.env['GOOGLE_CLIENT_ID_OAUTH_ANDROID'] ??
          'No GOOGLE_CLIENT_ID_OAUTH_ANDROID';
  static String googleClientIdOAuthIos =
      dotenv.env['GOOGLE_CLIENT_ID_OAUTH_IOS'] ??
          'No GOOGLE_CLIENT_ID_OAUTH_IOS';
}
