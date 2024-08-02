import './validator.dart';

/// Validator that requires the control's value pass an email validation test.
class EmailValidator<T> extends Validator<T> {
  static final RegExp emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  const EmailValidator({this.errorMessage}) : super();

  final String? errorMessage;

  @override
  String? validate(T value) {
    final String error = errorMessage ?? 'Invalid email format';

    return (value == null ||
            value.toString().isEmpty ||
            emailRegex.hasMatch(value.toString()))
        ? null
        : error;
  }
}
