import '../error/exceptions.dart';

class Password {
  final String value;

  Password(String input) : value = _validate(input);

  static String _validate(String input) {
    if (input.length < 6) {
      throw ValidationException('Password must be at least 6 characters');
    }
    return input;
  }
}
