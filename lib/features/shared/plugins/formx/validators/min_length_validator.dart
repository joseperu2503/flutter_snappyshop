import './validator.dart';

/// Validator that validates whether the value meets a minimum length
/// requirement.
class MinLengthValidator<T> extends Validator<T> {
  final int minLength;

  const MinLengthValidator(this.minLength, {this.errorMessage}) : super();
  final String? errorMessage;

  @override
  String? validate(T value) {
    final String error = errorMessage ?? 'Min length: $minLength';

    if (value is String && value.length < minLength) {
      return error;
    }

    return null;
  }
}
