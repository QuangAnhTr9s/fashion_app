import 'package:fashion_app/ui/categories/categories_page.dart';
import 'package:fashion_app/ui/favourite/favourite_page.dart';
import 'package:fashion_app/ui/featured/featured_page.dart';
import 'package:fashion_app/ui/product_showcase/product_showcase_page.dart';
import 'package:fashion_app/ui/user_setting/user_setting_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'home_page_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.firstIndex});

  final int firstIndex;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //init HomePageBloc
  final _homePageBloc = HomePageBloc();
  int firstIndex = 2;

  //DateTime
  DateTime timeBackPressed = DateTime.now();

  @override
  void initState() {
    super.initState();
    firstIndex = widget.firstIndex;
    _homePageBloc.pageController = PageController(initialPage: firstIndex);
  }

  @override
  void dispose() {
    _homePageBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: Container(
            color: Colors.grey,
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _homePageBloc.pageController,
              children: const [
                FeaturedPage(),
                CategoriesPage(),
                ProductShowcasePage(),
                FavouritePage(),
                UserSettingPage(),
              ],
            ),
          ),
          bottomNavigationBar: StreamBuilder<int>(
              initialData: firstIndex,
              stream: _homePageBloc.currentPageStream,
              builder: (context, snapshot) {
                final currentPage = snapshot.data ?? firstIndex;
                return BottomNavigationBar(
                  backgroundColor:
                      currentPage == 2 ? Colors.black : Colors.white,
                  type: BottomNavigationBarType.fixed,
                  onTap: (value) => _homePageBloc.changePageIndex(value),
                  currentIndex: currentPage,
                  // hide label of BottomNavigationBarItem
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  //BottomNavigationBarItem will change color to red when cliked (on Tap)
                  selectedItemColor:
                      currentPage == 2 ? Colors.white : Colors.black,
                  unselectedItemColor: currentPage == 2
                      ? Colors.grey.shade700
                      : Colors.grey.shade300,
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(
                          Icons.local_fire_department,
                        ),
                        label: ''),
                    BottomNavigationBarItem(
                        icon: Icon(
                          Icons.dashboard_rounded,
                        ),
                        label: ''),
                    // BottomNavigationBarItem(icon: Container(height: 32, width: 32,child: Image.asset(Images.thumb_up_filled, fit: BoxFit.fill,)), label: ''),
                    BottomNavigationBarItem(
                        icon: Icon(
                          Icons.explore,
                        ),
                        label: ''),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.favorite), label: ''),

                    BottomNavigationBarItem(
                        icon: Icon(
                          Icons.account_circle,
                        ),
                        label: ''),
                  ],
                );
              }),
        ),
      ),
    );
  }

  //Press back 2 time to exit
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
  }
}
