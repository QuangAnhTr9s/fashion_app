import 'package:fashion_app/component/text_field_valid.dart';
import 'package:fashion_app/network/fire_base/firestore.dart';
import 'package:fashion_app/shared/const/images.dart';
import 'package:fashion_app/shared/const/screen_consts.dart';
import 'package:fashion_app/ui/auth/sign_up/sign_up_screen_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fashion_app/models/user/user.dart';
import 'package:intl/intl.dart';
import '../../../network/fire_base/fire_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _signUpPageBloc = SignUpPageBloc();

  //init fire auth
  final Auth _auth = Auth();

  bool value = false;
  String _wrongLogin = '';
  final DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    //set giá trị mặc định cho birthday là thời điểm hiện tại
    _signUpPageBloc.birthDayController.text =
        DateFormat('MM/dd/yyyy').format(_now);
  }

  @override
  void dispose() {
    _signUpPageBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Sign Up"),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //input first and last name
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //input First name
                      Expanded(
                        child: TextFieldWithValid(
                          stream: _signUpPageBloc.firstNameStream,
                          textEditingController:
                              _signUpPageBloc.firstNameController,
                          validText: _signUpPageBloc.validFirstName,
                          placeHolder: 'First Name',
                          obscureText: false,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFieldWithValid(
                          stream: _signUpPageBloc.lastNameStream,
                          textEditingController:
                              _signUpPageBloc.lastNameController,
                          validText: _signUpPageBloc.validLastName,
                          placeHolder: 'Last Name',
                          obscureText: false,
                        ),
                      ),
                    ],
                  ),
                ),
                //input birthday
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                          child: TextFieldWithValid(
                        stream: _signUpPageBloc.birthDayStream,
                        textEditingController:
                            _signUpPageBloc.birthDayController,
                        validText: _signUpPageBloc.validBirthDay,
                        placeHolder: 'month/day/year',
                        obscureText: false,
                      )),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 55,
                        height: 55,
                        child: GestureDetector(
                          onTap: () async {
                            DateTime? pickDateResult = await _pickDate();
                            _signUpPageBloc.birthDayController.text =
                                DateFormat('MM/dd/yyyy')
                                    .format(pickDateResult ?? _now);
                          },
                          child: Image.asset(
                            MyImages.circleIconsCalendar,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //input phone number
                /* _buildTextFieldWithValid(
                  stream: _signUpPageBloc.phoneNumberStream,
                  textEditingController: _phoneNumberController,
                  validText: _signUpPageBloc.validPhoneNumber,
                  placeHolder: 'Enter Phone Number',
                  obscureText: false,
                ),*/

                //input email
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFieldWithValid(
                    stream: _signUpPageBloc.emailStream,
                    textEditingController: _signUpPageBloc.emailController,
                    validText: _signUpPageBloc.validEmail,
                    placeHolder: 'Enter email: a12...@gmail.com',
                    obscureText: false,
                  ),
                ),
                //Text Wrong Login
                _wrongLogin == ''
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 8),
                        child: Text(
                          _wrongLogin,
                          style:
                              const TextStyle(fontSize: 14, color: Colors.red),
                        ),
                      ),

                //input password
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: buildInputPassword(
                    isShowPasswordStream: _signUpPageBloc.isShowPasswordStream,
                    changeShowPassword: _signUpPageBloc.changeShowPassword,
                    passwordStream: _signUpPageBloc.passwordStream,
                    placeHolder: 'Enter password: longer than 7 characters',
                    textEditingController: _signUpPageBloc.passwordController,
                    validText: _signUpPageBloc.validPassword,
                  ),
                ),

                //input second password
                buildInputPassword(
                  isShowPasswordStream:
                      _signUpPageBloc.isShowSecondPasswordStream,
                  changeShowPassword: _signUpPageBloc.changeShowSecondPassword,
                  passwordStream: _signUpPageBloc.isCorrectPasswordStream,
                  placeHolder: 'Enter the password again',
                  textEditingController:
                      _signUpPageBloc.secondPasswordController,
                  validText: _signUpPageBloc.validSecondPassword,
                ),

                //button Sign up
                GestureDetector(
                  onTap: () {
                    createUser();
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 50),
                    height: 48,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black),
                    child: const Center(
                        child: Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputPassword({
    required Stream<bool> isShowPasswordStream,
    required Function() changeShowPassword,
    required Stream<String> passwordStream,
    required String placeHolder,
    required TextEditingController textEditingController,
    required Function validText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: StreamBuilder<bool>(
          // stream: _signUpScreenBloc.isShowPasswordStream,
          stream: isShowPasswordStream,
          builder: (context, snapshotIsShowPassword) {
            final isShowPassword = snapshotIsShowPassword.data ?? false;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //build Show/Hide Password
                    GestureDetector(
                      onTap: () {
                        // _signUpScreenBloc.changeShowPassword();
                        changeShowPassword();
                      },
                      child: Text(
                        isShowPassword ? 'Hide password' : 'Show password',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                TextFieldWithValid(
                  stream: passwordStream,
                  textEditingController: textEditingController,
                  validText: validText,
                  placeHolder: placeHolder,
                  obscureText: !isShowPassword,
                )
              ],
            );
          }),
    );
  }

  Future<DateTime?> _pickDate() => showDatePicker(
        context: context,
        initialDate: _now,
        firstDate: DateTime(1900),
        lastDate: _now,
      );

  Future<void> createUser() async {
    if (_signUpPageBloc.isValidSignUp()) {
      try {
        /*//lấy max id của user trên firestore
      int maxID = await FireStore().getMaxIDUser();*/
        await _auth
            .createUserWithEmailAndPassword(
                firstName: _signUpPageBloc.firstNameController.text.trim(),
                lastName: _signUpPageBloc.lastNameController.text.trim(),
                email: _signUpPageBloc.emailController.text.trim(),
                password: _signUpPageBloc.passwordController.text.trim())
            .then(
          (value) {
            if (value != null) {
              showDialog(
                context: context,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                ),
              );
              //lưu thông tin user lên Firestore
              MyUser user = MyUser(
                id: value.uid,
                firstName: _signUpPageBloc.firstNameController.text.trim(),
                lastName: _signUpPageBloc.lastNameController.text.trim(),
                birthday: _signUpPageBloc.birthDayController.text,
                email: _signUpPageBloc.emailController.text.trim(),
                password: _signUpPageBloc.passwordController.text.trim(),
              );
              FireStore().addUserToFirestore(user);
              Navigator.pushNamedAndRemoveUntil(
                  context, RouteName.signInScreen, (route) => false);
            }
            return null;
          },
        );
      } on FirebaseAuthException catch (e) {
        print('error in sign up: $e code: ${e.code}');
        if (e.code == 'email-already-in-use') {
          setState(() {
            _wrongLogin = 'Email already exists!';
          });
        }
      }
    }
  }
}
