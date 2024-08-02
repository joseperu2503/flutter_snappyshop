import './validator.dart';

/// Validator that requires the control's value to be greater than or equal
/// to a provided value.
class MinValidator<T> extends Validator<T> {
  final double min;

  const MinValidator(this.min);

  @override
  String? validate(T value) {
    final String error = 'El valor debe ser mayor o igual a $min';

    if (value == null) {
      return error;
    }

    assert(value is Comparable<double>,
        'The MinValidator validator is expecting a control of type `Comparable` but received a control of type ${value.runtimeType}');

    final comparableValue = value as Comparable<double>;
    return comparableValue.compareTo(min) >= 0 ? null : error;
  }
}
