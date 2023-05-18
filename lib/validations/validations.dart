import 'package:intl/intl.dart';

class Validations {
  static final regexStringNotSpace = RegExp(r'^[a-zA-Z]+$');
  static final regexString = RegExp(r'^[a-zA-Z\s]+$');
  static final regexNumber = RegExp(r'^[0-9]+$');
  static final regexStringAndNumber = RegExp(r'^[a-zA-Z0-9]+$');

  String? validName(String name) {
    // Kiểm tra xem tên có chứa chữ cái không
    if (!regexString.hasMatch(name)) {
      return 'Invalid (a-z A-Z)';
    }
    return null;
  }

  String? validPhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty ||
        phoneNumber.length >= 12 ||
        !regexNumber.hasMatch(phoneNumber)) {
      return 'Invalid Phone Number';
    }
    return null;
  }

  String? validDate(String dateStr) {
    try {
      List<String> parts = dateStr.split('/');
      if (parts.length != 3) {
        return 'Invalid Time (00/00/0000)';
      }

      int month = int.parse(parts[0]);
      int day = int.parse(parts[1]);
      int year = int.parse(parts[2]);

      NumberFormat twoDigitFormat = NumberFormat('00');
      String formattedMonth = twoDigitFormat.format(month);
      String formattedDay = twoDigitFormat.format(day);

      DateFormat format = DateFormat('MM/dd/yyyy');
      String formattedDate = format.format(DateTime(year, month, day));

      if (formattedMonth != parts[0] ||
          formattedDay != parts[1] ||
          formattedDate != dateStr) {
        return 'Invalid Time (00/00/0000)';
      }
    } catch (e) {
      return 'Invalid Time (00/00/0000)';
    }

    return null;
  }

  String? validEmail(String email) {
    if (email.contains(" ")) {
      return 'Email cannot contain spaces';
    } else if (email.length < 12) {
      return 'Email must be longer than 12 characters';
    } else if (!email.substring(email.length - 10).contains("@gmail.com")) {
      return 'Invalid email (exp: a12...@gmail.com)';
    } else if (!regexStringAndNumber
        .hasMatch(email.substring(0, email.length - 10))) {
      return 'Invalid characters (a-z A-Z 0-9)@gmail.com';
    }
    return null;
  }

  String? validPassword(String password) {
    if (password.contains(" ")) {
      return 'Password cannot contain spaces';
    } else if (password.length < 7) {
      return 'Email must be longer than 7 characters';
    } else if (!regexStringAndNumber.hasMatch(password)) {
      return 'Invalid characters (a-z A-Z 0-9)';
    }
    return null;
    // return password != null && password.length > 7;
  }

  String? validSecondPassword(String password, String secondPassword) {
    return password != secondPassword ? 'Incorrect second password ' : null;
    // return password == secondPassword;
  }
}
