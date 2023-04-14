import 'package:fashion_app/ui/auth/sign_in/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'user_setting_bloc.dart';

class UserSettingPage extends StatefulWidget {
  const UserSettingPage({super.key});

  @override
  State<UserSettingPage> createState() => _UserSettingPageState();
}

class _UserSettingPageState extends State<UserSettingPage> {
  //init HomePageBloc
  final _userSettingPageBloc = UserSettingPageBloc();

  @override
  void dispose() {
    _userSettingPageBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final heightScreen = MediaQuery.of(context).size.height;
    final widthScreen = MediaQuery.of(context).size.width;
    final user = _userSettingPageBloc.getCurrentUser();
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      body: SingleChildScrollView(
        child: SizedBox(
          width: widthScreen,
          height: 1000,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                child: Container(
                  height: 250,
                  width: widthScreen,
                  decoration: const BoxDecoration(
                    color: Color(0xff868585),
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
                          fontWeight: FontWeight.w500,
                          height: 1.185,
                          letterSpacing: 0.875,
                          color: Color(0xffffffff),
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //avatar and name
                      Row(
                        children: [
                          SizedBox(
                            width: 58,
                            height: 56,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                user!.photoURL ?? '',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            '${user.displayName}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              height: 1.185,
                              color: Color(0xff000000),
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.grey,
                        height: 30,
                        thickness: 1,
                      ),
                      //Account Settings
                      SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 30),
                              child: const Text(
                                'Account Settings',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  height: 1.185,
                                  color: Color(0xffadadad),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    "Edit profile",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Icon(Icons.navigate_next_sharp),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    "Change password",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Icon(Icons.navigate_next_sharp),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    "Add a payment method",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Icon(Icons.add),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Push notifications",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  StreamBuilder<bool>(
                                      stream: _userSettingPageBloc
                                          .isSwitchedPushNotiStream,
                                      builder: (context, snapshot) {
                                        final isSwitchedPushNoti =
                                            snapshot.data ?? false;
                                        return Switch(
                                          onChanged: (value) {
                                            value = !value;
                                            _userSettingPageBloc
                                                .handleClickSwitchedPushNoti();
                                          },
                                          value: isSwitchedPushNoti,
                                          activeColor: Colors.white,
                                          activeTrackColor: Colors.grey,
                                          inactiveThumbColor: Colors.white,
                                          inactiveTrackColor:
                                              Colors.grey.shade300,
                                        );
                                      }),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Dark mode",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  StreamBuilder<bool>(
                                      stream: _userSettingPageBloc
                                          .isSwitchedDarkModeStream,
                                      builder: (context, snapshot) {
                                        final isSwitchedDarkMode =
                                            snapshot.data ?? false;
                                        return Switch(
                                          onChanged: (value) {
                                            value = !value;
                                            _userSettingPageBloc
                                                .handleClickSwitchedDarkMode();
                                          },
                                          value: isSwitchedDarkMode,
                                          activeColor: Colors.white,
                                          activeTrackColor: Colors.grey,
                                          inactiveThumbColor: Colors.white,
                                          inactiveTrackColor:
                                              Colors.grey.shade300,
                                        );
                                      }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                        height: 30,
                        thickness: 1,
                      ),
                      //More Settings
                      SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 30),
                              child: const Text(
                                'More',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  height: 1.185,
                                  color: Color(0xffadadad),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    "About us",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Icon(Icons.navigate_next_sharp),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    "Privacy policy",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Icon(Icons.navigate_next_sharp),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    "Terms and conditions",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Icon(Icons.navigate_next_sharp),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                        height: 30,
                        thickness: 1,
                      ),
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
                            style: TextStyle(fontSize: 18, color: Colors.black),
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
}
/*InkWell(
onTap: () {
_userSettingPageBloc.signOut();
},
child: Container(
width: double.maxFinite,
padding: const EdgeInsets.all(5),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(10),
),
child: const Text(
'Sign out',
style: TextStyle(color: Colors.black, fontSize: 20),
)),
)*/
