import 'package:reactive_forms/reactive_forms.dart';

class VisaValidator extends Validator<dynamic> {
  const VisaValidator() : super();

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    String? value = control.value;

    // Eliminar espacios en blanco y guiones del número de tarjeta
    String numeroTarjeta = value?.replaceAll(RegExp(r'\s+|-'), '') ?? '';

    // Verificar si el número de tarjeta comienza con '4' (prefijo de Visa)
    if (!numeroTarjeta.startsWith('4')) {
      return {'invalidCard': true};
    }

    // Verificar la longitud del número de tarjeta (13 o 16 dígitos)
    if (numeroTarjeta.length != 13 && numeroTarjeta.length != 16) {
      return {'invalidCard': true};
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
      return {'invalidCard': true};
    }

    return null;
  }
}

class MasterCardValidator extends Validator<dynamic> {
  const MasterCardValidator() : super();

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    String? value = control.value;

    // Eliminar espacios en blanco y guiones del número de tarjeta
    String numeroTarjeta = value?.replaceAll(RegExp(r'\s+|-'), '') ?? '';

    // Verificar si el número de tarjeta comienza con '51'-'55' o '2221'-'2720' (prefijo de Mastercard)
    if (!RegExp(r'^5[1-5]|^(2(?:2[2-9][^0]|2[3-9]|[3-6]|22[1-9]|7[0-1]|72[0]))')
        .hasMatch(numeroTarjeta)) {
      return {'invalidCard': true};
    }

    // Verificar la longitud del número de tarjeta (16 dígitos)
    if (numeroTarjeta.length != 16) {
      return {'invalidCard': true};
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
      return {'invalidCard': true};
    }

    return null;
  }
}

class AmexValidator extends Validator<dynamic> {
  const AmexValidator() : super();

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    String? value = control.value;

    // Eliminar espacios en blanco y guiones del número de tarjeta
    String numeroTarjeta = value?.replaceAll(RegExp(r'\s+|-'), '') ?? '';

    // Verificar si el número de tarjeta comienza con '34' o '37' (prefijos de Amex)
    if (!numeroTarjeta.startsWith('34') && !numeroTarjeta.startsWith('37')) {
      return {'invalidCard': true};
    }

    // Verificar la longitud del número de tarjeta (15 dígitos)
    if (numeroTarjeta.length != 15) {
      return {'invalidCard': true};
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
      return {'invalidCard': true};
    }

    return null;
  }
}

class ExpiredValidator extends Validator<dynamic> {
  const ExpiredValidator() : super();

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    String? value = control.value;

    if (value?.isEmpty ?? true) {
      return null;
    }

    final DateTime now = DateTime.now();
    final List<String> date = value!.split(RegExp(r'/'));

    final int month = int.parse(date.first);
    final int year = int.parse('20${date.last}');

    final int lastDayOfMonth = month < 12
        ? DateTime(year, month + 1, 0).day
        : DateTime(year + 1, 1, 0).day;

    final DateTime cardDate =
        DateTime(year, month, lastDayOfMonth, 23, 59, 59, 999);

    if (cardDate.isBefore(now) || month > 12 || month == 0) {
      return {'invalid': true};
    }

    return null;
  }
}
