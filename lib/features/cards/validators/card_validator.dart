import 'package:flutter_snappyshop/features/shared/plugins/formx/formx.dart';

class VisaValidator<T> extends Validator<T> {
  const VisaValidator() : super();
  final String error = 'Invalid card.';

  @override
  String? validate(T value) {
    if (value is! String) {
      return null;
    }

    // Eliminar espacios en blanco y guiones del número de tarjeta
    String numeroTarjeta = value.replaceAll(RegExp(r'\s+|-'), '');

    // Verificar si el número de tarjeta comienza con '4' (prefijo de Visa)
    if (!numeroTarjeta.startsWith('4')) {
      return error;
    }

    // Verificar la longitud del número de tarjeta (13 o 16 dígitos)
    if (numeroTarjeta.length != 13 && numeroTarjeta.length != 16) {
      return error;
    }

    // Aplicar el algoritmo de Luhn
    int suma = 0;
    bool multiplicarPorDos = false;
    for (int i = numeroTarjeta.length - 1; i >= 0; i--) {
      int digito = int.tryParse(numeroTarjeta[i]) ?? 0;
      if (multiplicarPorDos) {
        digito *= 2;
        if (digito > 9) {
          digito -= 9;
        }
      }
      suma += digito;
      multiplicarPorDos = !multiplicarPorDos;
    }

    // Verificar si la suma total es divisible por 10
    if (suma % 10 != 0) {
      return error;
    }

    return null;
  }
}

class MasterCardValidator<T> extends Validator<T> {
  const MasterCardValidator() : super();
  final String error = 'Invalid card.';

  @override
  String? validate(T value) {
    if (value is! String) {
      return null;
    }

    // Eliminar espacios en blanco y guiones del número de tarjeta
    String numeroTarjeta = value.replaceAll(RegExp(r'\s+|-'), '');

    // Verificar si el número de tarjeta comienza con '51'-'55' o '2221'-'2720' (prefijo de Mastercard)
    if (!RegExp(r'^5[1-5]|^(2(?:2[2-9][^0]|2[3-9]|[3-6]|22[1-9]|7[0-1]|72[0]))')
        .hasMatch(numeroTarjeta)) {
      return error;
    }

    // Verificar la longitud del número de tarjeta (16 dígitos)
    if (numeroTarjeta.length != 16) {
      return error;
    }

    // Aplicar el algoritmo de Luhn
    int suma = 0;
    bool multiplicarPorDos = false;
    for (int i = numeroTarjeta.length - 1; i >= 0; i--) {
      int digito = int.tryParse(numeroTarjeta[i]) ?? 0;
      if (multiplicarPorDos) {
        digito *= 2;
        if (digito > 9) {
          digito -= 9;
        }
      }
      suma += digito;
      multiplicarPorDos = !multiplicarPorDos;
    }

    // Verificar si la suma total es divisible por 10
    if (suma % 10 != 0) {
      return error;
    }

    return null;
  }
}

class AmexValidator<T> extends Validator<T> {
  const AmexValidator() : super();
  final String error = 'Invalid card.';

  @override
  String? validate(T value) {
    if (value is! String) {
      return null;
    }

    // Eliminar espacios en blanco y guiones del número de tarjeta
    String numeroTarjeta = value.replaceAll(RegExp(r'\s+|-'), '');

    // Verificar si el número de tarjeta comienza con '34' o '37' (prefijos de Amex)
    if (!numeroTarjeta.startsWith('34') && !numeroTarjeta.startsWith('37')) {
      return error;
    }

    // Verificar la longitud del número de tarjeta (15 dígitos)
    if (numeroTarjeta.length != 15) {
      return error;
    }

    // Aplicar el algoritmo de Luhn
    int suma = 0;
    bool multiplicarPorDos = false;
    for (int i = numeroTarjeta.length - 1; i >= 0; i--) {
      int digito = int.tryParse(numeroTarjeta[i]) ?? 0;
      if (multiplicarPorDos) {
        digito *= 2;
        if (digito > 9) {
          digito -= 9;
        }
      }
      suma += digito;
      multiplicarPorDos = !multiplicarPorDos;
    }

    // Verificar si la suma total es divisible por 10
    if (suma % 10 != 0) {
      return error;
    }

    return null;
  }
}

class ExpiredValidator<T> extends Validator<T> {
  const ExpiredValidator() : super();
  final String error = 'Invalid date.';

  @override
  String? validate(T value) {
    if (value is! String) {
      return null;
    }

    final DateTime now = DateTime.now();
    final List<String> date = value.split(RegExp(r'/'));

    final int month = int.parse(date.first);
    final int year = int.parse('20${date.last}');

    final int lastDayOfMonth = month < 12
        ? DateTime(year, month + 1, 0).day
        : DateTime(year + 1, 1, 0).day;

    final DateTime cardDate =
        DateTime(year, month, lastDayOfMonth, 23, 59, 59, 999);

    if (cardDate.isBefore(now) || month > 12 || month == 0) {
      return error;
    }

    return null;
  }
}
