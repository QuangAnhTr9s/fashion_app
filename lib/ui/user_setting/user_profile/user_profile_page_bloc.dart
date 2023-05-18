import 'dart:async';

import 'package:fashion_app/base/bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../validations/validations.dart';

class UserProfilePageBloc extends Bloc {
  //TextEditingController
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
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

  Stream<String> get firstNameStream => _firstNameStreamController.stream;

  Stream<String> get lastNameStream => _lastNameStreamController.stream;

  Stream<String> get birthDayStream => _birthDayStreamController.stream;

  Stream<String> get phoneNumberStream => _phoneNumberStreamController.stream;

  Stream<String> get emailStream => _emailStreamController.stream;

  StreamSink get _firstNameSink => _firstNameStreamController.sink;

  StreamSink get _lastNameSink => _lastNameStreamController.sink;

  StreamSink get _birthDaySink => _birthDayStreamController.sink;

  StreamSink get _phoneNumberSink => _phoneNumberStreamController.sink;

  StreamSink get _emailSink => _emailStreamController.sink;

  @override
  void dispose() {
    _firstNameStreamController.close();
    _lastNameStreamController.close();
    _birthDayStreamController.close();
    _emailStreamController.close();
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
}
