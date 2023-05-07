import 'package:fashion_app/shared/const/screen_consts.dart';
import 'package:fashion_app/shared_preferences/shared_preferences.dart';
import 'package:fashion_app/ui/auth/sign_in/sign_in_page.dart';
import 'package:fashion_app/ui/cart/cart_page.dart';
import 'package:fashion_app/ui/favourite/favourite_page.dart';
import 'package:fashion_app/ui/featured/featured_page.dart';
import 'package:fashion_app/ui/home/home_page.dart';
import 'package:fashion_app/ui/product_info/product_info_page.dart';
import 'package:fashion_app/ui/product_showcase/product_showcase_page.dart';
import 'package:fashion_app/ui/snap/snap_page.dart';
import 'package:fashion_app/ui/user_setting/user_setting_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'models/product.dart';
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
          textTheme: const TextTheme(titleMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
      ),
      routes: {
        '/': (context) => const MainPage(),
        RouteName.homeScreen: (context) => const HomePage(),
        RouteName.signInScreen: (context) => const SignInPage(),
        RouteName.signUpScreen: (context) => const SignInPage(),
        RouteName.featuredScreen: (context) => const FeaturedPage(),
        RouteName.userSettingScreen: (context) => const UserSettingPage(),
        RouteName.cartScreen: (context) => const CartPage(),
        RouteName.favouriteScreen: (context) =>  const FavouritePage(),
        RouteName.snapScreen: (context) =>  SnapPage(),
        RouteName.productInfoScreen: (context) =>  ProductInfoPage(product: ModalRoute.of(context)!.settings.arguments as Product,),
        RouteName.productShowcase: (context) =>  const ProductShowcasePage(),
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSignIn = MySharedPreferences.getIsSaveSignIn();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            if(isSignIn == false){
              _signInWithGoogle.signOut();
              _auth.signOut();
              return const SignInPage();
            }
            return const HomePage();
          }else if(!snapshot.hasData){
            return const SignInPage();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },),
    );
  }
}

