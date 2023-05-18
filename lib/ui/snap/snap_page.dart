import 'package:fashion_app/shared/const/screen_consts.dart';
import 'package:flutter/material.dart';
import 'package:fashion_app/shared/const/images.dart';

class SnapPage extends StatefulWidget {
  const SnapPage({super.key});

  @override
  State<SnapPage> createState() => _SnapPageState();
}

class _SnapPageState extends State<SnapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              height: 500,
              child: Image.asset(
                MyImages.snapPicture,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                'Explore the app',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Text(
                "Welcome to our Fashion App, where you can discover, rate, and purchase the latest fashion products. Our easy-to-use interface allows you to browse a wide range of items and connect with other fashion lovers to get inspiration and advice. Whether you're looking for new outfits, accessories, or beauty products, our app has got you covered. Let's start exploring the world of fashion like never before!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff000000),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context, RouteName.signInScreen, (route) => false),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xff0e0d0d),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    "Let's Start",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xfffcf9f9),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
