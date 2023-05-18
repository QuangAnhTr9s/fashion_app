import 'dart:async';

import 'package:flutter/material.dart';
import '../../../validations/validations.dart';

class SignUpPageBloc {
  //isShowPassword
  bool _isShowPassword = false;
  bool _isShowSecondPassword = false;

  //TextEditingController
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  // final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController birthDayController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController secondPasswordController =
      TextEditingController();

  final StreamController<String> _firstNameStreamController =
      StreamController<String>.broadcast();
  final StreamController<String> _lastNameStreamController =
      StreamController<String>.broadcast();
  final StreamController<String> _birthDayStreamController =
      StreamController<String>.broadcast();
  final StreamController<String> _phoneNumberStreamController =
      StreamController<String>.broadcast();
  final StreamController<String> _emailStreamController =
      StreamController<String>.broadcast();
  final StreamController<String> _passwordStreamController =
      StreamController<String>.broadcast();
  final StreamController<String> _secondPasswordStreamController =
      StreamController<String>.broadcast();
  final StreamController<bool> _isShowPasswordStreamController =
      StreamController<bool>.broadcast();
  final StreamController<bool> _isShowSecondPasswordStreamController =
      StreamController<bool>.broadcast();

  Stream<String> get firstNameStream => _firstNameStreamController.stream;

  Stream<String> get lastNameStream => _lastNameStreamController.stream;

  Stream<String> get birthDayStream => _birthDayStreamController.stream;

  Stream<String> get phoneNumberStream => _phoneNumberStreamController.stream;

  Stream<String> get emailStream => _emailStreamController.stream;

  Stream<String> get passwordStream => _passwordStreamController.stream;

  Stream<String> get isCorrectPasswordStream =>
      _secondPasswordStreamController.stream;

  Stream<bool> get isShowPasswordStream =>
      _isShowPasswordStreamController.stream;

  Stream<bool> get isShowSecondPasswordStream =>
      _isShowSecondPasswordStreamController.stream;

  StreamSink get _firstNameSink => _firstNameStreamController.sink;

  StreamSink get _lastNameSink => _lastNameStreamController.sink;

  StreamSink get _birthDaySink => _birthDayStreamController.sink;

  StreamSink get _phoneNumberSink => _phoneNumberStreamController.sink;

  StreamSink get _emailSink => _emailStreamController.sink;

  StreamSink get _passwordSink => _passwordStreamController.sink;

  StreamSink get _isCorrectPasswordSink => _secondPasswordStreamController.sink;

  StreamSink get _isShowPasswordSink => _isShowPasswordStreamController.sink;

  StreamSink get _isShowSecondPasswordSink =>
      _isShowSecondPasswordStreamController.sink;

  void changeShowPassword() {
    _isShowPassword = !_isShowPassword;
    _isShowPasswordSink.add(_isShowPassword);
  }

  void changeShowSecondPassword() {
    _isShowSecondPassword = !_isShowSecondPassword;
    _isShowSecondPasswordSink.add(_isShowSecondPassword);
  }

  void dispose() {
    _firstNameStreamController.close();
    _lastNameStreamController.close();
    _birthDayStreamController.close();
    _emailStreamController.close();
    _passwordStreamController.close();
    _secondPasswordStreamController.close();
    _isShowPasswordStreamController.close();
    _isShowSecondPasswordStreamController.close();
  }

  bool isValidSignUp() {
    if (firstNameController.text.isEmpty) {
      print('e');
      _firstNameSink.addError('Not be empty');
    }
    if (lastNameController.text.isEmpty) _lastNameSink.addError('Not be empty');
    if (birthDayController.text.isEmpty) _birthDaySink.addError('Not be empty');
    if (emailController.text.isEmpty) _emailSink.addError('Not be empty');
    if (passwordController.text.isEmpty) _passwordSink.addError('Not be empty');
    if (secondPasswordController.text.isEmpty) {
      _secondPasswordStreamController.addError('Not be empty');
    }
    return firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        birthDayController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        secondPasswordController.text.isNotEmpty;
  }

  validFirstName(String name) {
    if (Validations().validName(name) != null) {
      _firstNameSink.addError(Validations().validName(name)!);
    } else {
      _firstNameSink.add('');
    }
  }

  validLastName(String name) {
    if (Validations().validName(name) != null) {
      _lastNameSink.addError(Validations().validName(name)!);
    } else {
      _lastNameSink.add('');
    }
  }

  validPhoneNumber(String phoneNumber) {
    if (Validations().validPhoneNumber(phoneNumber) != null) {
      _phoneNumberSink.addError(Validations().validPhoneNumber(phoneNumber)!);
    } else {
      _phoneNumberSink.add('');
    }
  }

  validBirthDay(String birthDay) {
    if (Validations().validDate(birthDay) != null) {
      _birthDaySink.addError(Validations().validDate(birthDay)!);
    } else {
      _birthDaySink.add('');
    }
  }

  validEmail(String email) {
    if (Validations().validEmail(email) != null) {
      _emailSink.addError(Validations().validEmail(email)!);
    } else {
      _emailSink.add('');
    }
  }

  validPassword(String passWord) {
    if (Validations().validPassword(passWord) != null) {
      _passwordSink.addError(Validations().validPassword(passWord)!);
    } else {
      _passwordSink.add('');
    }
  }

  validSecondPassword(String secondPassword) {
    String passWord = passwordController.text.trim();
    if (Validations().validSecondPassword(passWord, secondPassword) != null) {
      _isCorrectPasswordSink.addError(
          Validations().validSecondPassword(passWord, secondPassword)!);
    } else {
      _isCorrectPasswordSink.add('');
    }
  }
}
