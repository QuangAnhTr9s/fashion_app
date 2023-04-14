import 'dart:async';

import 'package:fashion_app/network/fire_base/fire_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../base/bloc/bloc.dart';
import '../../network/google/google_sign_in.dart';

class UserSettingPageBloc extends Bloc {
  final _auth = Auth();
  final _signInWithGoogle = SignInWithGoogle();
  bool _isSwitchedPushNoti = false;
  bool _isSwitchedDarkMode = false;

  final _isSwitchedPushNotiStreamController = StreamController<bool>.broadcast();
  final _isSwitchedDarkModeStreamController = StreamController<bool>.broadcast();
  Stream<bool> get isSwitchedPushNotiStream => _isSwitchedPushNotiStreamController.stream;
  Stream<bool> get isSwitchedDarkModeStream => _isSwitchedDarkModeStreamController.stream;
  StreamSink<bool> get _isSwitchedPushNotiSink =>_isSwitchedPushNotiStreamController.sink;
  StreamSink<bool> get _isSwitchedDarkModeSink =>_isSwitchedDarkModeStreamController.sink;

  User? getCurrentUser (){
    return _auth.currentUser;
  }
  Future<void> signOut() async {
    try {
      _signInWithGoogle.signOut();
      _auth.signOut();
    } catch (e) {
      print('error in user setting Sc: $e');
    }
  }
  void handleClickSwitchedPushNoti() async{
    _isSwitchedPushNoti = !_isSwitchedPushNoti;
    _isSwitchedPushNotiSink.add(_isSwitchedPushNoti);
  }
  void handleClickSwitchedDarkMode() async{
    _isSwitchedDarkMode = !_isSwitchedDarkMode;
    _isSwitchedDarkModeSink.add(_isSwitchedDarkMode);
  }


  bool get isSwitchedPushNoti => _isSwitchedPushNoti;

  set isSwitchedPushNoti(bool value) {
    _isSwitchedPushNoti = value;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
