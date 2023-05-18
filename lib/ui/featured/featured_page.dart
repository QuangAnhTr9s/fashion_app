import 'package:fashion_app/shared/const/screen_consts.dart';
import 'package:fashion_app/shared/fake_data/fake_news.dart';
import 'package:flutter/material.dart';
import '../../component/image_firebase_storage.dart';
import '../../component/search_bar.dart';
import '../../component/shopping_bag_button.dart';
import '../../models/product/product.dart';
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
    _featuredPageBloc.tabControllerNewProduct =
        TabController(vsync: this, length: 3);
    _featuredPageBloc.tabControllerFeaturedProduct =
        TabController(vsync: this, length: 3);
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
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.white,
          actions: const [
            ShoppingBagButton(),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearch(),
              _buildNew(),
              //build New Products
              StreamBuilder<int>(
                  stream: _featuredPageBloc.newProductTabBarStream,
                  builder: (context, snapshot) {
                    return _buildListProducts(
                      'New Products',
                      _featuredPageBloc.setIndexForTabBarInNewProducts,
                      _featuredPageBloc.tabControllerNewProduct,
                      _featuredPageBloc.categorySelectedInNewProductStream,
                      _featuredPageBloc.handleSelectedNewProductByCategory,
                      _featuredPageBloc.indexNewProductSelectedByGender,
                    );
                  }),
              //build Featured Products
              StreamBuilder<int>(
                  stream: _featuredPageBloc.featuredProductTabBarStream,
                  builder: (context, snapshot) {
                    return _buildListProducts(
                      'Featured Products',
                      _featuredPageBloc.setIndexForTabBarInFeaturedProducts,
                      _featuredPageBloc.tabControllerFeaturedProduct,
                      _featuredPageBloc.categorySelectedInFeaturedProductStream,
                      _featuredPageBloc.handleSelectedFeaturedProductByCategory,
                      _featuredPageBloc.indexFeaturedProductSelectedByGender,
                    );
                  }),
            ],
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
        margin: const EdgeInsets.symmetric(horizontal: 16),
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

  Widget _buildNew() {
    List<String> listNews = FakeNews().listNew;
    return Container(
        color: Colors.white,
        margin: const EdgeInsets.only(top: 10, bottom: 5),
        padding: const EdgeInsets.only(top: 5),
        height: 200,
        width: double.infinity,
        child: PageView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: listNews.length,
          itemBuilder: (context, index) {
            return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ImagesFireBaseStore(
                    urlImage: listNews[index], fit: BoxFit.fill));
          },
        ));
  }

  Widget _buildListProducts(
    String string,
    Function(int index) setIndexForTabBarInNewProduct,
    TabController controller,
    Stream<int> streamCategory,
    Function(int index) handleSelectedProductByCategory,
    int indexGender,
  ) {
    return SizedBox(
      height: 716,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              string,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          //build TabBar Select to Gender
          SizedBox(
            height: 35,
            // alignment: Alignment.topLeft,
            child: TabBar(
                onTap: (index) => setIndexForTabBarInNewProduct(index),
                controller: controller,
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
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Man',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Kid',
                    style: TextStyle(fontSize: 16),
                  ),
                ]),
          ),
          //build TabView
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 1.5),
              width: double.maxFinite,
              child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: controller,
                  children: [
                    //build TabBarView Women
                    _buildTabBarView(
                      string,
                      streamCategory,
                      handleSelectedProductByCategory,
                      indexGender,
                    ),
                    //build TabBarView Men
                    _buildTabBarView(
                      string,
                      streamCategory,
                      handleSelectedProductByCategory,
                      indexGender,
                    ),
                    //build TabBarView Kid
                    _buildTabBarView(
                      string,
                      streamCategory,
                      handleSelectedProductByCategory,
                      indexGender,
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBarView(
    String stringTitle,
    Stream<int> streamCategory,
    Function(int index) handleSelectedProductByCategory,
    int indexGender,
  ) {
    return StreamBuilder<int>(
        stream: streamCategory,
        builder: (context, snapshot) {
          int indexCategory = snapshot.data ?? 0;
          List<String> listCategory =
              _featuredPageBloc.listCategoriesOfProducts[indexGender];
          List<Product> listProduct = _featuredPageBloc.getListProducts(
              stringTitle, indexGender, indexCategory);
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
                                fontSize: 15, color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              _buildGridView(listProduct),
            ],
          );
        });
  }

  Widget _buildGridView(List<Product> listProduct) {
    return SizedBox(
      height: 602,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
          childAspectRatio: 7 / 5,
        ),
        itemCount: listProduct.length,
        itemBuilder: (context, index) {
          final product = listProduct[index];
          return InkWell(
            onTap: () => Navigator.pushNamed(
                context, RouteName.productInfoScreen,
                arguments: product),
            child: SizedBox(
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
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                height: 20,
                                constraints: const BoxConstraints(maxWidth: 50),
                                child: Text(
                                  '${product.price} \$',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
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
}
