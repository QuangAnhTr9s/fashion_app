import 'package:fashion_app/network/fire_base/firestore.dart';
import 'package:fashion_app/shared/const/screen_consts.dart';
import 'package:fashion_app/shared/fake_data/fake_product.dart';
import 'package:fashion_app/shared_preferences/shared_preferences.dart';
import 'package:fashion_app/ui/auth/sign_in/sign_in_page.dart';
import 'package:fashion_app/ui/auth/sign_up/sign_up_screen.dart';
import 'package:fashion_app/ui/cart/cart_page.dart';
import 'package:fashion_app/ui/favourite/favourite_page.dart';
import 'package:fashion_app/ui/featured/featured_page.dart';
import 'package:fashion_app/ui/home/home_page.dart';
import 'package:fashion_app/ui/product_info/product_info_page.dart';
import 'package:fashion_app/ui/product_showcase/product_showcase_page.dart';
import 'package:fashion_app/ui/snap/snap_page.dart';
import 'package:fashion_app/ui/user_setting/addProductToFireStore/add_product_to_fire_store_page.dart';
import 'package:fashion_app/ui/user_setting/user_profile/user_profile_page.dart';
import 'package:fashion_app/ui/user_setting/user_setting_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'models/product/product.dart';
import 'network/fire_base/fire_auth.dart';
import 'network/google/google_sign_in.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MySharedPreferences.initSharedPreferences();
  //lock screen rotation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          iconTheme: const IconThemeData(color: Colors.grey),
          buttonTheme: const ButtonThemeData(buttonColor: Colors.grey),
          textTheme: const TextTheme(
              titleMedium:
                  TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
      routes: {
        '/': (context) => const MainPage(),
        RouteName.homeScreen: (context) => const HomePage(
              firstIndex: 2,
            ),
        RouteName.signInScreen: (context) => const SignInPage(),
        RouteName.signUpScreen: (context) => const SignUpScreen(),
        RouteName.featuredScreen: (context) => const FeaturedPage(),
        RouteName.userSettingScreen: (context) => const UserSettingPage(),
        RouteName.userProfileScreen: (context) => const UserProfilePage(),
        RouteName.cartScreen: (context) => const CartPage(),
        RouteName.favouriteScreen: (context) => const FavouritePage(),
        RouteName.snapScreen: (context) => const SnapPage(),
        RouteName.productInfoScreen: (context) => ProductInfoPage(
              product: ModalRoute.of(context)!.settings.arguments as Product,
            ),
        RouteName.productShowcaseScreen: (context) =>
            const ProductShowcasePage(),
        RouteName.addProductToFireStoreScreen: (context) =>
            const AddProductToFireStore(),
      },
      initialRoute: '/',
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //isSignIn
  bool isSignIn = false;

  //init Auth
  final Auth _auth = Auth();

  //init Google Login
  final SignInWithGoogle _signInWithGoogle = SignInWithGoogle();
  final _fireStore = FireStore();

  @override
  void initState() {
    super.initState();
    isSignIn = MySharedPreferences.getIsSaveSignIn();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<Product>> fetchData() async {
    await Future.delayed(const Duration(seconds: 2));
    await _fireStore.getAllProductsFromFirestore();
    return FakeProduct.listProduct;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: FutureBuilder<List<Product>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Text('Error in fetchData: ${snapshot.error}'));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildScreenWhenLoadingData();
            } else {
              return StreamBuilder(
                stream: Auth().authStateChanges,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.white,
                    ));
                  } else if (snapshot.hasData) {
                    if (isSignIn) {
                      return const HomePage(
                        firstIndex: 2,
                      );
                    } else {
                      _signInWithGoogle.signOut();
                      _auth.signOut();
                      return const SignInPage();
                    }
                  } else {
                    Future.delayed(const Duration(seconds: 1));
                    return const SnapPage();
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildScreenWhenLoadingData() {
    return Center(
      child: SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                  constraints: const BoxConstraints(maxWidth: 210),
                  child: const Text(
                    'Welcome to the Fashion App',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  )),
            ),
            const CircularProgressIndicator(
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

/* //Press back 2 time to exit
  Future<bool> _onWillPop() async {
    final difference = DateTime.now().difference(timeBackPressed);
    final isExitWarning = difference >= const Duration(seconds: 2);

    timeBackPressed = DateTime.now();
    if (isExitWarning) {
      const message = ' Press back again to exit ';
      await Fluttertoast.showToast(
          msg: message,
          textColor: Colors.white,
          fontSize: 16,
          backgroundColor: Colors.grey);
      return false;
    } else {
      Fluttertoast.cancel();
      return true;
    }
  }*/
}
