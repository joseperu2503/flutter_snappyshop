import './validators/validator.dart';
import 'package:flutter/services.dart';

export './validators/validators.dart';

// enum ValidatorType {
//   required,
//   email,
//   password,
//   phone,
//   url,
//   minLength,
//   maxLength,
//   lessThan,
//   greaterThan,
//   pattern,
//   onlyNumbers,
//   custom,
// }

// class Validator {
//   final ValidatorType type;
//   final dynamic value;
//   final String? errorMessage;

//   const Validator(
//     this.type, {
//     this.value,
//     this.errorMessage,
//   });
// }

class Formx {
  static bool validate(List<FormxInput<dynamic>> inputs) {
    return inputs.every((input) => input.isValid);
  }
}

class FormxInput<T> {
  const FormxInput({
    required T value,
    List<Validator<T>> validators = const [],
    List<TextInputFormatter> formatters = const [],
    bool touched = false,
  })  : _value = value,
        _formatters = formatters,
        _validators = validators,
        _touched = touched;

  final T _value;
  final List<Validator<T>> _validators;
  final List<TextInputFormatter> _formatters;
  final bool _touched;

  T get value => _value;
  bool get isValid => errorMessage == null;
  bool get isInvalid => errorMessage != null;
  bool get touched => _touched;

  String? get errorMessage {
    for (final validator in _validators) {
      final error = validator.validate(this._value);
      if (error != null) {
        return error;
      }
    }

    return null;
  }

  FormxInput<T> touch() {
    return _copyWith(
      isTouched: true,
    );
  }

  FormxInput<T> updateValue(T value) {
    return _copyWith(
      value: value,
    );
  }

  FormxInput<T> _copyWith({
    bool? isTouched,
    T? value,
  }) =>
      FormxInput<T>(
        value: value ?? this._value,
        touched: isTouched ?? this._touched,
        validators: this._validators,
        formatters: this._formatters,
      );
}
