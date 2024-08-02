import '../validators/compose_or_validator.dart';
import '../validators/email_validator.dart';
import '../validators/min_length_validator.dart';
import '../validators/required_validator.dart';

import './min_validator.dart';
import './validator.dart';

class Validators {
  /// Creates a validator that requires the control's value to be greater than
  /// or equal to [min] value.
  ///
  /// The argument [min] must not be null.
  static Validator<T> min<T>(double min) => MinValidator<T>(min);

  /// Creates a validator that requires the control have a non-empty value.
  static Validator<T> required<T>({String? errorMessage}) =>
      RequiredValidator<T>(errorMessage: errorMessage);

  static Validator<T> email<T>({String? errorMessage}) =>
      EmailValidator<T>(errorMessage: errorMessage);

  static Validator<T> minLenth<T>(int minLenth, {String? errorMessage}) =>
      MinLengthValidator<T>(minLenth, errorMessage: errorMessage);

  static Validator<T> composeOR<T>(List<Validator<T>> validators) {
    return ComposeOrValidator<T>(validators);
  }
}
