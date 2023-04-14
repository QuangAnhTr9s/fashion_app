import 'package:fashion_app/custom_widget/shopping_bag_button.dart';
import 'package:flutter/material.dart';
import '../../custom_widget/search_bar.dart';
import 'featured_page_bloc.dart';

class FeaturedPage extends StatefulWidget {
  const FeaturedPage({super.key});

  @override
  State<FeaturedPage> createState() => _FeaturedPageState();
}

class _FeaturedPageState extends State<FeaturedPage> {
  //init HomePageBloc
  final _homePageBloc = FeaturedPageBloc();

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
          shadowColor: Colors.transparent,
          backgroundColor: Colors.white,
          actions: const [
            ShoppingBagButton(),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildSearch(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return InkWell(
      onTap: () =>
          showSearch(context: context, delegate: MySearchBarDelegate()),
      child: Container(
        alignment: Alignment.center,
        height: 40,
        width: 450,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                blurRadius: 5,
                spreadRadius: 1,
              )
            ]),
        child: Row(children: [
          const SizedBox(
            width: 10,
          ),
          Icon(
            Icons.search,
            color: Colors.grey.shade500,
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            'Search',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
          ),
        ]),
      ),
    );
  }
}
