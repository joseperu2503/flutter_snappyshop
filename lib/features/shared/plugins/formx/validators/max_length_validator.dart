import './validator.dart';

/// Validator that validates whether the value meets a minimum length
/// requirement.
class MaxLengthValidator<T> extends Validator<T> {
  final int maxLength;

  const MaxLengthValidator(this.maxLength, {this.errorMessage}) : super();
  final String? errorMessage;

  @override
  String? validate(T value) {
    final String error = errorMessage ?? 'Max length: $maxLength';

    if (value is String && value.length > maxLength) {
      return error;
    }

    return null;
  }
}
