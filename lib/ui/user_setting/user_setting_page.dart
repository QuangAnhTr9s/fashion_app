import 'package:fashion_app/shared/const/images.dart';
import 'package:fashion_app/shared/const/screen_consts.dart';
import 'package:fashion_app/ui/auth/sign_in/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/user/user.dart';
import '../../network/fire_base/firestore.dart';
import 'user_setting_bloc.dart';

class UserSettingPage extends StatefulWidget {
  const UserSettingPage({super.key});

  @override
  State<UserSettingPage> createState() => _UserSettingPageState();
}

class _UserSettingPageState extends State<UserSettingPage> {
  final _userSettingPageBloc = UserSettingPageBloc();
  User? user;

  @override
  void initState() {
    super.initState();
    user = _userSettingPageBloc.getCurrentUser();
  }

  @override
  void dispose() {
    _userSettingPageBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      body: SingleChildScrollView(
        child: SizedBox(
          width: widthScreen,
          height: 800,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                child: Container(
                  height: 250,
                  width: widthScreen,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      SizedBox(
                        height: 70,
                      ),
                      Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 120,
                child: Container(
                  width: widthScreen - 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //avatar and name
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, RouteName.userProfileScreen),
                        child: FutureBuilder<MyUser?>(
                          future: FireStore().getUserData(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text(
                                      'Error in getUserData from Firestore: ${snapshot.error}'));
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator(
                                color: Colors.transparent,
                              );
                            } else {
                              MyUser? user = snapshot.data;
                              return user == null
                                  ? const SizedBox()
                                  : Row(
                                      children: [
                                        SizedBox(
                                          width: 58,
                                          height: 56,
                                          child: ClipOval(
                                            child: user.photoURL?.isNotEmpty ==
                                                    true
                                                ? Image.network(
                                                    user.photoURL ?? '',
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.asset(
                                                    MyImages.circleUserAvatar,
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          '${user.firstName} ${user.lastName}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            height: 1.185,
                                            color: Color(0xff000000),
                                          ),
                                        ),
                                      ],
                                    );
                            }
                          },
                        ),
                      ),
                      _buildDivider(),
                      //Account Settings
                      SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitle(title: 'Account Settings'),
                            _buildRowControl(
                              stringText: 'Edit profile',
                              stringRouteName: RouteName.userProfileScreen,
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'Add a payment method',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Padding(
                                    //chèn thêm 1 đoạn ngắn bên phải cho đều với Switch
                                    padding: EdgeInsets.only(right: 6),
                                    child: Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ),
                            _buildRowWithSwitch(
                                title: 'Push notifications',
                                switchStream: _userSettingPageBloc
                                    .isSwitchedPushNotiStream,
                                handleSwitch: _userSettingPageBloc
                                    .handleSwitchedPushNoti),
                            _buildRowWithSwitch(
                              title: 'Dark mode',
                              switchStream:
                                  _userSettingPageBloc.isSwitchedDarkModeStream,
                              handleSwitch:
                                  _userSettingPageBloc.handleSwitchedDarkMode,
                            ),
                          ],
                        ),
                      ),
                      _buildDivider(),
                      //More Settings
                      SizedBox(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitle(title: 'More'),
                            _buildRowControl(
                                stringText: 'About us', stringRouteName: ''),
                            _buildRowControl(
                              stringText: 'Privacy policy',
                              stringRouteName: '',
                            ),
                            _buildRowControl(
                              stringText: 'Terms and conditions',
                              stringRouteName: '',
                            ),
                            _buildRowControl(
                              stringText: 'Add product to FireStore',
                              stringRouteName:
                                  RouteName.addProductToFireStoreScreen,
                            ),
                          ],
                        ),
                      ),
                      _buildDivider(),
                      //Log out
                      InkWell(
                        onTap: () {
                          _userSettingPageBloc.signOut();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const SignInPage(),
                            ),
                            (route) => false,
                          );
                        },
                        child: const SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Sign out",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      )
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

  Divider _buildDivider() {
    return const Divider(
      color: Colors.grey,
      height: 30,
      thickness: 1,
    );
  }

  Widget _buildRowWithSwitch({
    required String title,
    required Stream<bool> switchStream,
    required Function handleSwitch,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        StreamBuilder<bool>(
            stream: switchStream,
            builder: (context, snapshot) {
              final isSwitchedDarkMode = snapshot.data ?? false;
              return Switch(
                onChanged: (value) {
                  value = !value;
                  handleSwitch();
                },
                value: isSwitchedDarkMode,
                activeColor: Colors.white,
                activeTrackColor: Colors.grey,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey.shade300,
              );
            }),
      ],
    );
  }

  Container _buildTitle({required String title}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          height: 1.185,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildRowControl({
    required String stringText,
    required String stringRouteName,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => stringRouteName != ''
          ? Navigator.pushNamed(context, stringRouteName)
          : null,
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              stringText,
              style: const TextStyle(fontSize: 16),
            ),
            const Padding(
              //chèn thêm 1 đoạn ngắn bên phải cho đều với Switch
              padding: EdgeInsets.only(right: 6),
              child: Icon(Icons.navigate_next_sharp),
            ),
          ],
        ),
      ),
    );
  }
}
