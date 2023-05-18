import 'dart:async';

import 'package:fashion_app/base/bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../validations/validations.dart';

class SigInPageBloc extends Bloc {
  //isShowPassword
  bool _isShowPassword = false;

  //checkBox
  bool isChecked = false;

  //TextEditingController
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final StreamController<String> _userNameStreamController =
      StreamController<String>.broadcast();
  final StreamController<String> _passwordStreamController =
      StreamController<String>.broadcast();
  final StreamController<bool> _isShowPasswordStreamController =
      StreamController<bool>.broadcast();
  final StreamController<bool> _isCheckedStreamController =
      StreamController<bool>.broadcast();

  Stream<String> get userNameStream => _userNameStreamController.stream;

  Stream<String> get passwordStream => _passwordStreamController.stream;

  Stream<bool> get isShowPasswordStream =>
      _isShowPasswordStreamController.stream;

  Stream<bool> get isCheckedWordStream => _isCheckedStreamController.stream;

  StreamSink get _userNameSink => _userNameStreamController.sink;

  StreamSink get _passwordSink => _passwordStreamController.sink;

  StreamSink get _isShowPasswordSink => _isShowPasswordStreamController.sink;

  StreamSink get _isCheckedWordSink => _isCheckedStreamController.sink;

  @override
  void dispose() {
    _userNameStreamController.close();
    _passwordStreamController.close();
    _isShowPasswordStreamController.close();
    _isCheckedStreamController.close();
  }

  void changeShowPassword() {
    _isShowPassword = !_isShowPassword;
    _isShowPasswordSink.add(_isShowPassword);
  }

  void isCheckedBox(bool? value) {
    isChecked = value ?? false;
    _isCheckedWordSink.add(isChecked);
  }

  validEmail(String email) {
    if (Validations().validEmail(email) != null) {
      _userNameSink.addError(Validations().validEmail(email)!);
    } else {
      _userNameSink.add('');
    }
  }

  validPassword(String passWord) {
    if (Validations().validPassword(passWord) != null) {
      _passwordSink.addError(Validations().validPassword(passWord)!);
    } else {
      _passwordSink.add('');
    }
  }
}
