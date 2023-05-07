import 'package:fashion_app/shared/const/screen_consts.dart';
import 'package:fashion_app/shared/fake_data/fake_product.dart';
import 'package:flutter/material.dart';
import '../../component/image_firebase_storage.dart';
import '../../component/search_bar.dart';
import '../../component/shopping_bag_button.dart';
import 'featured_page_bloc.dart';

class FeaturedPage extends StatefulWidget {
  const FeaturedPage({super.key});

  @override
  State<FeaturedPage> createState() => _FeaturedPageState();
}

class _FeaturedPageState extends State<FeaturedPage>
    with TickerProviderStateMixin {
  //init HomePageBloc
  final _featuredPageBloc = FeaturedPageBloc();

  @override
  void initState() {
    super.initState();
    _featuredPageBloc.tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _featuredPageBloc.dispose();
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
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearch(),
                _buildNew(),
                _buildGridView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return GestureDetector(
      onTap: () =>
          showSearch(context: context, delegate: MySearchBarDelegate()),
      child: Container(
        alignment: Alignment.center,
        height: 40,
        width: 450,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
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

  Widget _buildGridView() {
    final listProduct = FakeProduct().listProduct;
    return Container(
      height: 625,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
          childAspectRatio: 4 / 3,
        ),
        itemCount: listProduct.length,
        itemBuilder: (context, index) {
          final product = listProduct[index];
          return InkWell(
            onTap: () => Navigator.pushNamed(
                context, RouteName.productInfoScreen,
                arguments: product),
            child: SizedBox(
              width: 500,
              child: Column(
                children: [
                  //Product Image
                  SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: ImagesFireBaseStore(
                      urlImage: product.urlPhoto.first,
                      fit: BoxFit.fill,
                    ),
                  ),
                  //Product Info
                  Container(
                    width: double.infinity,
                    height: 100,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade200,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                height: 20,
                                constraints: const BoxConstraints(maxWidth: 50),
                                child: Text(
                                  '${product.price} \$',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                product.sizes.join('  '),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(
                                maxWidth: 150,
                              ),
                              height: 20,
                              child: ListView.separated(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: product.colors.length,
                                itemBuilder: (context, index) {
                                  var color = product.colors[index];
                                  return Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Color(color),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  width: 5,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _buildNew() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 10, bottom: 5),
      padding: const EdgeInsets.only(top: 5),
      height: 200,
      width: double.infinity,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'New',
              style: TextStyle(fontSize: 16),
            ),
            Divider(
              color: Colors.grey,
              height: 2,
            )
          ]),
    );
  }
}
