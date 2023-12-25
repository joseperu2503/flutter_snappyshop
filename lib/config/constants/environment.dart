import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static initEnvironment() async {
    await dotenv.load(fileName: ".env");
  }

  static String urlBase =
      dotenv.env['URL_BASE'] ?? 'No esta configurado el URL_BASE';
}
