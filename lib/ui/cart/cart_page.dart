import 'package:expandable_text/expandable_text.dart';
import 'package:fashion_app/models/product.dart';
import 'package:fashion_app/shared/const/screen_consts.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../component/image_firebase_storage.dart';
import '../../models/final_product.dart';
import 'cart_page_bloc.dart';
import 'package:input_quantity/input_quantity.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with TickerProviderStateMixin {
  //init HomePageBloc
  final _cartPageBloc = CartPageBloc();
  List<bool> listCheck = [];

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
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.grey),
          title: Text(
            "Your Cart",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          actions: [
            StreamBuilder<bool>(
                stream: _cartPageBloc.isSelectedToDeleteStream,
                builder: (context, snapshot) {
                  bool isSelectedToDeleteStream = snapshot.data ?? false;
                  return isSelectedToDeleteStream
                      ? IconButton(
                          onPressed: () {
                            _cartPageBloc.handleDelete();
                            setState(() {});
                          },
                          icon: const Icon(Icons.delete))
                      : const SizedBox();
                })
          ],
        ),
        body: Column(
          children: [
            //build TabBar
            SizedBox(
              height: 35,
              // alignment: Alignment.topLeft,
              child: TabBar(
                  onTap: (value) {
                    setState(() {});
                  },
                  controller: _cartPageBloc.tabController,
                  // isScrollable: true,
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
              ? buildTextEmptyListProduct('Your Cart is empty!')
              : buildListViewProductInCart(listProduct);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget buildTextEmptyListProduct(String string) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                string,
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
              ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () =>
                      Navigator.pushNamed(context, RouteName.homeScreen),
                  child: const Text(
                    "Let's go shopping together  ->",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ))
            ],
          ),
        ),
      );

  Widget buildListViewProductInCart(Set<FinalProduct> listProductInCart) {
    listCheck = List<bool>.filled(listProductInCart.length, false);
    return Scaffold(
      body: ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (context, index) => Container(
                color: Colors.grey.shade300,
                height: 2,
              ),
          itemCount: listProductInCart.length,
          itemBuilder: (context, index) {
            final finalProduct = listProductInCart.elementAt(index);
            Product product;
            return InkWell(
              onTap: () {
                //check ID final product to find product
                product = _cartPageBloc.findProductByID(finalProduct);
                Navigator.pushNamed(context, RouteName.productInfoScreen,
                    arguments: product);
              },
              child: Container(
                width: double.infinity,
                height: 155,
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
                    Flexible(
                      flex: 3,
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: double.infinity,
                        height: double.infinity,
                        child: ImagesFireBaseStore(
                          urlImage: finalProduct.urlPhoto,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    //Product Info
                    Flexible(
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ExpandableText(
                            finalProduct.name,
                            expandText: '',
                            maxLines: 3,
                            linkColor: Colors.black,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                      width: 30,
                                      child: Text(
                                        finalProduct.sizes,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                    Builder(builder: (context) {
                                      final color = finalProduct.colors;
                                      return Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                              color: Color(color),
                                              border: Border.all(
                                                  color: Colors.grey.shade400,
                                                  width: 1.0)));
                                    }),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Text(
                                    '${finalProduct.price} \$',
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InputQty(
                                showMessageLimit: false,
                                maxVal: 20,
                                minVal: 1,
                                btnColor1: Colors.black,
                                btnColor2: Colors.grey,
                                onQtyChanged: (value) {
                                  // finalProduct.quantity == value;
                                  _cartPageBloc.handleQuantity(
                                      value, finalProduct);
                                },
                              ),
                              //checkBox
                              buildCheckBoxInListView(index, listProductInCart),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
      bottomNavigationBar: buildBottomAppBarInCart(listProductInCart),
    );
  }

  BottomAppBar buildBottomAppBarInCart(Set<FinalProduct> listProductInCart) {
    return BottomAppBar(
      child: SizedBox(
        height: 50,
        child: StreamBuilder<bool>(
            stream: _cartPageBloc.checkAllStream,
            builder: (context, snapshot) {
              return Stack(
                children: [
                  Positioned(
                    left: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Transform.scale(
                              scale: 1.5,
                              child: Checkbox(
                                value: _cartPageBloc.isCheckedAll,
                                onChanged: (value) {
                                  listCheck = List<bool>.filled(
                                      listCheck.length, value!);
                                  _cartPageBloc.handleCheckAll(
                                      listProductInCart, value);
                                },
                              ),
                            ),
                            const Text(
                              'All',
                              style: TextStyle(fontSize: 15),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Total cost: ${_cartPageBloc.totalCost} \$',
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        if (_cartPageBloc.listSelectedIndex.isNotEmpty) {
                          _cartPageBloc.handleBuy(listProductInCart);
                          QuickAlert.show(
                              context: context,
                              title: "Added to cart",
                              type: QuickAlertType.success);
                        }
                        setState(() {});
                      },
                      child: Container(
                        color: const Color(0xffd51122),
                        height: 50,
                        width: 110,
                        child: Center(
                          child: Text(
                            'Pay (${_cartPageBloc.listSelectedIndex.length})',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }

  SizedBox buildCheckBoxInListView(
      int index, Set<FinalProduct> listProductInCart) {
    return SizedBox(
      child: StreamBuilder<bool>(
          stream: _cartPageBloc.isCheckedBoxStream,
          builder: (context, snapshot) {
            return Transform.scale(
              scale: 1.5,
              child: Checkbox(
                value: listCheck[index],
                onChanged: (value) {
                  listCheck[index] = value!;
                  _cartPageBloc.handleCheck(listProductInCart, value, index);
                },
              ),
            );
          }),
    );
  }

  Widget _buildBuyAgainProductTabBarView(BuildContext context) {
    return FutureBuilder(
      future: _cartPageBloc.getListBuyAgain(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Text('An error has occurred');
          }
          List<FinalProduct>? listProduct = snapshot.data;
          return listProduct == null || listProduct.isEmpty
              ? buildTextEmptyListProduct(
                  'You have not purchased any of our products yet!')
              : buildListViewProductPurchased(listProduct);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget buildListViewProductPurchased(List<FinalProduct> listProduct) {
    return ListView.separated(
        separatorBuilder: (context, index) => Container(
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
              Navigator.pushNamed(context, RouteName.productInfoScreen,
                  arguments: product);
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Product Image
                  Flexible(
                    flex: 5,
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: double.infinity,
                      height: double.infinity,
                      child: ImagesFireBaseStore(
                        urlImage: finalProduct.urlPhoto,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  //Product Info
                  Flexible(
                    flex: 7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          finalProduct.name,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 20,
                                  width: 30,
                                  child: Text(
                                    finalProduct.sizes,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                                Builder(builder: (context) {
                                  final color = finalProduct.colors;
                                  return Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          color: Color(color),
                                          border: Border.all(
                                              color: Colors.grey.shade400,
                                              width: 1.0)));
                                })
                              ],
                            ),
                            Text(
                              'Number: ${finalProduct.quantity}',
                              style: const TextStyle(fontSize: 15),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${finalProduct.price} \$',
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              finalProduct.purchasedTime,
                              style: const TextStyle(fontSize: 13),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
