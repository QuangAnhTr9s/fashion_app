import 'package:fashion_app/ui/categories/categories_page.dart';
import 'package:fashion_app/ui/favourite/favourite_page.dart';
import 'package:fashion_app/ui/featured/featured_page.dart';
import 'package:fashion_app/ui/product_showcase/product_showcase_page.dart';
import 'package:fashion_app/ui/user_setting/user_setting_page.dart';
import 'package:flutter/material.dart';
import 'home_page_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //init HomePageBloc
  final _homePageBloc = HomePageBloc();

  @override
  void dispose() {
    _homePageBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
            initialData: _homePageBloc.initCurrentPage,
            stream: _homePageBloc.currentPageStream,
            builder: (context, snapshot) {
              final currentPage =
                  snapshot.data ?? _homePageBloc.initCurrentPage;
              return BottomNavigationBar(
                backgroundColor: currentPage == 2 ? Colors.black : Colors.white,
                type: BottomNavigationBarType.fixed,
                onTap: (value) => _homePageBloc.changePageIndex(value),
                currentIndex: currentPage,
                // hide label of BottomNavigationBarItem
                showSelectedLabels: false,
                showUnselectedLabels: false,
                //BottomNavigationBarItem will change color to red when cliked (on Tap)
                selectedItemColor: currentPage == 2 ? Colors.white : Colors.black,
                unselectedItemColor: currentPage == 2 ? Colors.grey.shade700 : Colors.grey.shade300,
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
    );
  }
}
