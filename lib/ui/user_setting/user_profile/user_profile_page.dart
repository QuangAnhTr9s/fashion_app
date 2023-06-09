import 'dart:io';

import 'package:fashion_app/component/custom_text_field.dart';
import 'package:fashion_app/models/user/user.dart';
import 'package:fashion_app/network/fire_base/firestore.dart';
import 'package:fashion_app/ui/user_setting/user_profile/user_profile_page_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';

import '../../../component/text_field_valid.dart';
import '../../../network/fire_base/fire_auth.dart';
import '../../../network/fire_base/fire_storage.dart';
import '../../../shared/const/images.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _userProfilePageBloc = UserProfilePageBloc();
  final DateTime _now = DateTime.now();
  FilePickerResult? _resultFilePicker;
  File? _fileImageUserAvatar;
  String? _filePath;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _userProfilePageBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Your Profile",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          iconTheme: const IconThemeData(color: Colors.grey),
          shadowColor: Colors.transparent,
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<MyUser?>(
            future: FireStore().getUserData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: Text('Error when getUserData: ${snapshot.error}'));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(
                  color: Colors.transparent,
                );
              } else {
                MyUser? user = snapshot.data;
                _userProfilePageBloc.firstNameController.text =
                    user?.firstName ?? '';
                _userProfilePageBloc.lastNameController.text =
                    user?.lastName ?? '';
                _userProfilePageBloc.birthDayController.text =
                    user?.birthday ?? '';
                _userProfilePageBloc.phoneNumberController.text =
                    user?.phoneNumber ?? '';
                _userProfilePageBloc.emailController.text = user?.email ?? '';
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      //Avatar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            height: 150,
                            width: 150,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: ClipOval(
                                    child: _fileImageUserAvatar != null
                                        ? Image.file(
                                            _fileImageUserAvatar!,
                                            fit: BoxFit.cover,
                                          )
                                        : SizedBox(
                                            child: user?.photoURL?.isNotEmpty ==
                                                    true
                                                ? Image.network(
                                                    user!.photoURL!,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.asset(
                                                    MyImages.circleUserAvatar,
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: GestureDetector(
                                    onTap: () => _handlePickImage(context),
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Image.asset(
                                        MyImages.editIcon,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //input First name
                            Expanded(
                              child: TextFieldWithValid(
                                labelText: 'First Name',
                                stream: _userProfilePageBloc.firstNameStream,
                                textEditingController:
                                    _userProfilePageBloc.firstNameController,
                                validText: _userProfilePageBloc.validFirstName,
                                placeHolder: 'First Name',
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFieldWithValid(
                                labelText: 'Last Name',
                                stream: _userProfilePageBloc.lastNameStream,
                                textEditingController:
                                    _userProfilePageBloc.lastNameController,
                                validText: _userProfilePageBloc.validLastName,
                                placeHolder: 'Last Name',
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
                              labelText: 'Your Birthday',
                              stream: _userProfilePageBloc.birthDayStream,
                              textEditingController:
                                  _userProfilePageBloc.birthDayController,
                              validText: _userProfilePageBloc.validBirthDay,
                              placeHolder: 'month/day/year',
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
                                  _userProfilePageBloc.birthDayController.text =
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
                      TextFieldWithValid(
                        labelText: 'Phone Number',
                        stream: _userProfilePageBloc.phoneNumberStream,
                        textEditingController:
                            _userProfilePageBloc.phoneNumberController,
                        validText: _userProfilePageBloc.validPhoneNumber,
                        placeHolder: '',
                      ),

                      //email
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: MyTextField(
                          labelText: 'Email',
                          enabled: false,
                          placeHolder: '',
                          textEditingController:
                              _userProfilePageBloc.emailController,
                          errorText: null,
                        ),
                      ),
                      //button Sign up
                      GestureDetector(
                        onTap: () => _handleSaveUserInfo(user!),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 50),
                          height: 48,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black),
                          child: const Center(
                              child: Text(
                            "Save",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          )),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Future<void> _handlePickImage(BuildContext context) async {
    {
      await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg'],
      ).then(
        (value) {
          if (value == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                width: 170,
                backgroundColor: Colors.grey.shade600,
                content: const Center(
                  child: Text(
                    'No file selected',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
            return null;
          }
          _resultFilePicker = value;
          _filePath = value.files.single.path;
          _fileImageUserAvatar = File(_filePath!);
          setState(() {});
          return null;
        },
      );
    }
  }

  Future<DateTime?> _pickDate() => showDatePicker(
        context: context,
        initialDate: _now,
        firstDate: DateTime(1900),
        lastDate: _now,
      );

  _handleSaveUserInfo(MyUser user) async {
    if (_resultFilePicker != null) {
      User? currentUser = Auth().currentUser;
      await FireStorage()
          .uploadUserAvatar(fileName: currentUser!.uid, filePath: _filePath!);
      user.photoURL =
          await FireStorage().downloadURL('/user/avatar/${currentUser.uid}');
    }
    MyUser myUser = MyUser(
      id: user.id,
      firstName: _userProfilePageBloc.firstNameController.text.trim(),
      lastName: _userProfilePageBloc.lastNameController.text.trim(),
      birthday: _userProfilePageBloc.birthDayController.text.trim(),
      phoneNumber: _userProfilePageBloc.phoneNumberController.text.trim(),
      email: user.email,
      password: user.password,
      photoURL: user.photoURL,
    );
    await FireStore().updateUserInFirestore(myUser).then(
          (value) => QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Updated Successfully',
            title: '',
          ),
        );
  }
}
