import 'package:fashion_app/component/custom_divider.dart';
import 'package:fashion_app/component/text_field_valid.dart';
import 'package:fashion_app/network/fire_base/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../network/fire_base/fire_auth.dart';
import '../../../network/google/google_sign_in.dart';
import '../../../shared/const/images.dart';
import '../../../shared/const/screen_consts.dart';
import '../../../shared_preferences/shared_preferences.dart';
import 'sign_in_page_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  //init bloc
  final SigInPageBloc _loginScreenBloc = SigInPageBloc();

  //
  String _wrongLogin = '';

  //fire auth
  final Auth _auth = Auth();

  //google sign in
  final SignInWithGoogle _signInWithGoogle = SignInWithGoogle();

  //DateTime
  DateTime timeBackPressed = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _loginScreenBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Image.asset(
                    MyImages.backgroundLogin,
                    fit: BoxFit.fill,
                  )),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSignInBox(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell _buildButtonGoogleSignIn() {
    return InkWell(
      onTap: () => _handleGoogleSignIn(),
      child: Container(
        height: 50,
        width: 195,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(30),
            color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                height: 40,
                width: 40,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      MyImages.googleAvatar,
                      fit: BoxFit.fill,
                    ))),
            const Text(
              "Sign in with Google",
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }

  Container _buildSignInBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              blurRadius: 10,
              spreadRadius: 5,
            )
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'SIGN IN',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          //nhập tài khoản
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Email',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                TextFieldWithValid(
                  stream: _loginScreenBloc.userNameStream,
                  textEditingController: _loginScreenBloc.usernameController,
                  validText: _loginScreenBloc.validEmail,
                  placeHolder: 'Enter email: a12...@gmail.com',
                  obscureText: false,
                )
              ],
            ),
          ),
          //nhập mật khẩu
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: StreamBuilder<bool>(
                stream: _loginScreenBloc.isShowPasswordStream,
                builder: (context, snapshotIsShowPassword) {
                  final isShowPassword = snapshotIsShowPassword.data ?? false;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Password',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          //build Show/Hide Password
                          InkWell(
                            onTap: () {
                              _loginScreenBloc.changeShowPassword();
                            },
                            child: Text(
                              isShowPassword
                                  ? 'Hide Password'
                                  : 'Show Password',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextFieldWithValid(
                        stream: _loginScreenBloc.passwordStream,
                        textEditingController:
                            _loginScreenBloc.passwordController,
                        validText: _loginScreenBloc.validPassword,
                        placeHolder: 'Enter password: longer than 7 characters',
                        obscureText: !isShowPassword,
                      ),
                    ],
                  );
                }),
          ),

          //Text Wrong Login
          _wrongLogin == ''
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _wrongLogin,
                        style: const TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    ],
                  ),
                ),

          //Save login
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: StreamBuilder<bool>(
                stream: _loginScreenBloc.isCheckedWordStream,
                builder: (context, snapshot) {
                  bool isChecked = snapshot.data ?? false;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (value) async {
                          _loginScreenBloc.isCheckedBox(value);
                          //lưu biến isChecked vào Shared Preferences
                          await MySharedPreferences.setSaveSignIn(
                              value ?? false);
                        },
                      ),
                      Text(isChecked ? "Don't save sign in" : "Save sign in"),
                    ],
                  );
                }),
          ),

          // nút đăng nhập
          _buildButtonSignIn('SIGN IN'),

          //Text Create new account? SIGN UP
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RouteName.signUpScreen);
                    },
                    child: const Text(
                      "Sign up!",
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    )),
              ],
            ),
          ),
          const MyDivider(text: 'OR'),
          // Sign in with other frame work
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButtonGoogleSignIn(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButtonSignIn(String label) {
    return GestureDetector(
      onTap: () {
        handleSignInWithEmail();
      },
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> handleSignInWithEmail() async {
    try {
      await _auth
          .signInWithEmailAndPassword(
        email: _loginScreenBloc.usernameController.text.trim(),
        password: _loginScreenBloc.passwordController.text.trim(),
      )
          .then(
        (value) async {
          if (value != null) {
            showDialog(
              context: context,
              builder: (context) => const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              RouteName.homeScreen,
              (route) => false,
            );
          }
          return null;
        },
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          _wrongLogin = 'Email is incorrect!';
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          _wrongLogin = 'Wrong password!';
        });
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      await _signInWithGoogle.signInWithGoogle().then((value) async {
        if (value != null) {
          showDialog(
            context: context,
            builder: (context) => const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          );
          FireStore().saveGoogleUserDataToFirestore(value);
          //lưu biến isChecked vào Shared Preferences
          await MySharedPreferences.setSaveSignIn(true).then(
            (value) {
              Navigator.pushNamedAndRemoveUntil(
                  context, RouteName.homeScreen, (route) => false);
            },
          );
        }
        return null;
      });
    } catch (error) {
      print('error in _handleGoogleSignIn: $error');
    }
  }

  //Press back 2 time to exit
  Future<bool> _onWillPop() async {
    final difference = DateTime.now().difference(timeBackPressed);
    final isExitWarning = difference >= const Duration(seconds: 2);

    timeBackPressed = DateTime.now();
    if (isExitWarning) {
      const message = ' Press back again to exit ';
      await Fluttertoast.showToast(msg: message, fontSize: 16);
      return false;
    } else {
      Fluttertoast.cancel();
      return true;
    }
  }
}
