import 'package:expandable_text/expandable_text.dart';
import 'package:fashion_app/component/shopping_bag_button.dart';
import 'package:flutter/material.dart';
import '../../component/image_firebase_storage.dart';
import '../search/search_bar.dart';
import '../../models/product/product.dart';
import '../../shared/const/screen_consts.dart';
import 'categories_page_bloc.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage>
    with TickerProviderStateMixin {
  //init HomePageBloc
  final _categoriesPageBloc = CategoriesPageBloc();

  @override
  void initState() {
    super.initState();
    _categoriesPageBloc.tabControllerSelectProductByGender =
        TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _categoriesPageBloc.dispose();
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
            IconButton(
                onPressed: () => showSearch(
                    context: context, delegate: MySearchBarDelegate()),
                icon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                )),
            const ShoppingBagButton(),
          ],
          //build TabBar Select to Gender
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(25),
            child: SizedBox(
              height: 25,
              child: TabBar(
                  onTap: (index) =>
                      _categoriesPageBloc.setIndexForTabBar(index),
                  controller:
                      _categoriesPageBloc.tabControllerSelectProductByGender,
                  // isScrollable: true,
                  indicatorColor: Colors.black,
                  indicatorWeight: 2,
                  labelPadding: const EdgeInsets.only(right: 18),
                  labelColor: Colors.black,
                  //color when not selected
                  unselectedLabelColor: Colors.grey,
                  //color when selected
                  tabs: const [
                    Text(
                      'Women',
                      style: TextStyle(fontSize: 17),
                    ),
                    Text(
                      'Man',
                      style: TextStyle(fontSize: 17),
                    ),
                    Text(
                      'Kid',
                      style: TextStyle(fontSize: 17),
                    ),
                  ]),
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 1.5),
          width: double.maxFinite,
          height: 800,
          child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller:
                  _categoriesPageBloc.tabControllerSelectProductByGender,
              children: [
                //build TabBarView Women
                _buildTabBarView(
                  _categoriesPageBloc.categorySelectedStream,
                  _categoriesPageBloc.handleSelectedProductByCategory,
                ),
                //build TabBarView Men
                _buildTabBarView(
                  _categoriesPageBloc.categorySelectedStream,
                  _categoriesPageBloc.handleSelectedProductByCategory,
                ),
                //build TabBarView Kid
                _buildTabBarView(
                  _categoriesPageBloc.categorySelectedStream,
                  _categoriesPageBloc.handleSelectedProductByCategory,
                ),
              ]),
        ),
      ),
    );
  }

  Widget _buildTabBarView(
    Stream<int> streamCategory,
    Function(int index) handleSelectedProductByCategory,
  ) {
    return StreamBuilder<int>(
        stream: streamCategory,
        builder: (context, snapshot) {
          int indexCategory = snapshot.data ?? 0;
          int indexGender = _categoriesPageBloc.indexSelectedByGender;
          List<String> listCategory =
              _categoriesPageBloc.listCategoriesOfProducts[indexGender];
          List<Product> listProduct =
              _categoriesPageBloc.getListProduct(indexGender, indexCategory);
          return Column(
            children: [
              SizedBox(
                height: 30,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: listCategory.length,
                  itemBuilder: (context, index) {
                    bool isSelectedIndex = (snapshot.data ?? 0) == index;
                    return GestureDetector(
                      onTap: () => handleSelectedProductByCategory(index),
                      child: Container(
                        width: MediaQuery.of(context).size.width /
                            listCategory.length,
                        decoration: BoxDecoration(
                          color: isSelectedIndex
                              ? Colors.black
                              : Colors.grey.shade400,
                          boxShadow: isSelectedIndex
                              ? [
                                  const BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 10,
                                      spreadRadius: 2)
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            listCategory[index],
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Flexible(child: _buildGridView(listProduct)),
            ],
          );
        });
  }

  Widget _buildGridView(List<Product> listProduct) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        childAspectRatio: 4 / 7,
      ),
      itemCount: listProduct.length,
      itemBuilder: (context, index) {
        final product = listProduct[index];
        return InkWell(
          onTap: () => Navigator.pushNamed(context, RouteName.productInfoScreen,
              arguments: product),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 900),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Product Image
                Flexible(
                  flex: 65,
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: ImagesFireBaseStore(
                      urlImage: product.urlPhoto.first,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                //Product Info
                Flexible(
                  flex: 35,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade200,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ExpandableText(
                          product.name,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                          expandText: '',
                          linkColor: Colors.black,
                          maxLines: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 20,
                              constraints: const BoxConstraints(maxWidth: 50),
                              child: Text(
                                '${product.price} \$',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            Text(
                              product.sizes.join('  '),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
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
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
