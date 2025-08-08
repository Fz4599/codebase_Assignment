import '../error/exceptions.dart';

class Email {
  final String value;

  Email(String input) : value = _validate(input);

  static String _validate(String input) {
    const emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    if (!RegExp(emailRegex).hasMatch(input)) {
      throw ValidationException('Invalid email format');
    }
    return input;
  }
}
