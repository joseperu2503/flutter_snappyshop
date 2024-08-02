abstract class Validator<T> {
  const Validator();

  /// Validates the [value].
  String? validate(T value);

  String? call(T value) {
    return validate(value);
  }
}
