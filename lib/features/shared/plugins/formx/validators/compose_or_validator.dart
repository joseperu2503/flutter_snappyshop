import './validator.dart';

/// Compose multiple validators into a single function.
///
/// If at least one validator returns 'null' then the compose validator
/// returns 'null', otherwise returns the union of the individual error
/// maps returned by each validator.
class ComposeOrValidator<T> extends Validator<T> {
  final List<Validator<T>> validators;

  const ComposeOrValidator(this.validators) : super();

  @override
  String? validate(T value) {
    for (final validator in validators) {
      final error = validator.validate(value);
      if (error != null) {
        return error;
      } else {
        return null;
      }
    }

    return null;
  }
}
