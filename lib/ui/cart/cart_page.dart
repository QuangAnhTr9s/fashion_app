import 'package:fashion_app/models/product.dart';
import 'package:fashion_app/ui/product_info/product_info_page.dart';
import 'package:flutter/material.dart';
import '../../models/final_product.dart';
import 'cart_page_bloc.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with TickerProviderStateMixin {
  //init HomePageBloc
  final _cartPageBloc = CartPageBloc();

  @override
  void initState() {
    super.initState();
    _cartPageBloc.tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _cartPageBloc.dispose();
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
            "Your Cart",
            style: Theme.of(context).textTheme.titleLarge,
            // style: TextStyle(color: Color(0xffef1951)),
          ),
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            //build TabBar
            SizedBox(
              height: 35,
              // alignment: Alignment.topLeft,
              child: TabBar(
                  controller: _cartPageBloc.tabController,
                  // isScrollable: true,
                  //set như này thì ko thấy thanh trượt dưới nữa: indicator: const BoxDecoration(shape: BoxShape.circle)
                  indicatorColor: Colors.black,
                  // màu thanh trượt
                  indicatorWeight: 2,
                  labelPadding: const EdgeInsets.only(right: 18),
                  labelColor: Colors.black,
                  //color when not selected
                  unselectedLabelColor: Colors.grey,
                  //color when selected
                  tabs: const [
                    Text(
                      'All',
                      style: TextStyle(fontSize: 17),
                    ),
                    Text(
                      'Buy Again',
                      style: TextStyle(fontSize: 17),
                    ),
                  ]),
            ),
            //build TabView
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 5),
                width: double.maxFinite,
                child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _cartPageBloc.tabController,
                    children: [
                      _buildAllProductTabBarView(context),
                      _buildBuyAgainProductTabBarView(context),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllProductTabBarView(BuildContext context) {
    return FutureBuilder(
      future: _cartPageBloc.getListProductInCart(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Text('An error has occurred');
          }
          Set<FinalProduct>? listProduct = snapshot.data;
          return listProduct == null || listProduct.isEmpty
              ? buildTextEmptyListProduct('Your favorites list is empty!')
              : buildListViewProductInCart(listProduct);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Center buildTextEmptyListProduct(String string) => Center(
        child: Text(
          string,
          style: const TextStyle(fontSize: 20, color: Colors.black),
        ),
      );

  ListView buildListViewProductInCart(Set<FinalProduct> listProduct) {
    return ListView.separated(
        separatorBuilder: (context, index) =>  Container(
          color: Colors.grey.shade300,
              height: 2,
            ),
        itemCount: listProduct.length,
        itemBuilder: (context, index) {
          final finalProduct = listProduct.elementAt(index);
          Product product;
          return InkWell(
            onTap: () {
              //check ID final product to find product
              product = _cartPageBloc.findProductByID(finalProduct);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductInfoPage(product: product),
                  ));
            },
            child: Container(
              width: double.infinity,
              height: 150,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                // borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Product Image
                  Container(
                    padding: const EdgeInsets.only(right: 10),
                    width: 100,
                    height: 140,
                    child: Image.asset(
                      finalProduct.urlPhoto,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  //Product Info
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          finalProduct.name,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          height: 20,
                          constraints:
                          const BoxConstraints(maxWidth: 80),
                          child: Text(
                            '${finalProduct.price} \$',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 50,
                              child: Text(
                                finalProduct.sizes,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                            Container(
                              height: 20,
                              width: 20,
                              color: Color(finalProduct.colors),
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
        });
  }

  Widget _buildBuyAgainProductTabBarView(BuildContext context) {
    return FutureBuilder(
      future: _cartPageBloc.getListProductInCart(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Text('An error has occurred');
          }
          Set<FinalProduct>? listProduct = snapshot.data;
          return listProduct == null || listProduct.isEmpty
              ? buildTextEmptyListProduct('Purchased list is empty!')
              : buildListViewProductPurchased(listProduct);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
  ListView buildListViewProductPurchased(Set<FinalProduct> listProduct) {
    return ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(
          height: 5,
        ),
        itemCount: listProduct.length,
        itemBuilder: (context, index) {
          final finalProduct = listProduct.elementAt(index);
          Product product;
          return InkWell(
            onTap: () {
              //check ID final product to find product
              product = _cartPageBloc.findProductByID(finalProduct);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductInfoPage(product: product),
                  ));
            },
            child: SizedBox(
              width: double.infinity,
              height: 350,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: double.infinity,
                      height: 350,
                      child: Container(
                        decoration: const BoxDecoration(
                          // borderRadius: BorderRadius.circular(15),
                          color: Color(0xffd9d9d9),
                        ),
                      ),
                    ),
                  ),
                  //Product Image
                  Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: double.infinity,
                      height: 270,
                      child: Image.asset(
                        finalProduct.urlPhoto,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  //Product Info
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(15),
                        color: Colors.grey.shade200,
                      ),
                      child: Container(
                        constraints: const BoxConstraints(maxHeight: 80),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  constraints:
                                  const BoxConstraints(maxWidth: 280),
                                  child: Text(
                                    finalProduct.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 20,
                                  constraints:
                                  const BoxConstraints(maxWidth: 80),
                                  child: Text(
                                    '${finalProduct.price} \$',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  SizedBox(
                                    height: 20,
                                    width: 25,
                                    child: Text(
                                      finalProduct.sizes,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 20,
                                    width: 20,
                                    color: Color(finalProduct.colors),
                                  ),
                                ],),
                                const SizedBox(
                                  height: 20,
                                  width: 100,
                                  child: Text('Purchased on: '),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

}
