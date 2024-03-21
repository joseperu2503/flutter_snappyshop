import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static initEnvironment() async {
    await dotenv.load(fileName: ".env");
  }

  static String urlBase = dotenv.env['URL_BASE'] ?? 'No URL_BASE';
  static String urlImages = dotenv.env['URL_IMAGES'] ?? 'No URL_IMAGES';
  static String googleClientIdOAuth =
      dotenv.env['GOOGLE_CLIENT_ID_OAUTH'] ?? 'No GOOGLE_CLIENT_ID_OAUTH';
}
