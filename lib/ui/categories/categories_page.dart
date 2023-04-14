import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'categories_page_bloc.dart';


class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {

  //init HomePageBloc
  final _homePageBloc = CategoriesPageBloc();
  @override
  void dispose() {
    _homePageBloc.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // drawer: const Drawer(child: Center(child: Text("It's My Drawer"),)),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Cate",
            style: Theme.of(context).textTheme.titleMedium,
            // style: TextStyle(color: Color(0xffef1951)),
          ),
          shadowColor: Colors.transparent,
          backgroundColor: Colors.white,
          actions: [
            // search icon is on the right side of the appbar
            IconButton(onPressed: () {},
                icon: const Icon(Icons.shopping_bag, color: Colors.grey,)),
          ],
          // leading: Builder(
          //   builder: (context) {
          //     return IconButton(
          //       color: Colors.grey,
          //       onPressed: () {
          //         //press to open Drawer
          //         Scaffold.of(context).openDrawer();
          //       },
          //       icon: const Icon(Icons.menu,),
          //     );
          //   }
          // ),
        ),
        body: Container(
          padding: const EdgeInsets.all(15),
        ),

      ),
    );
  }
}

