import 'package:expandable_text/expandable_text.dart';
import 'package:fashion_app/models/product.dart';
import 'package:fashion_app/ui/product_info/product_info_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

import '../../component/favourite_button.dart';
import '../../component/image_firebase_storage.dart';
import '../../component/shopping_bag_button.dart';

class ProductInfoPage extends StatefulWidget {
  const ProductInfoPage({super.key, required this.product});

  final Product product;

  @override
  State<ProductInfoPage> createState() => _ProductInfoPageState();
}

class _ProductInfoPageState extends State<ProductInfoPage> {
  final _productInfoBloc = ProductInfoBloc();
  late final Product product;

  @override
  void initState() {
    super.initState();
    product = widget.product;
  }

  @override
  void dispose() {
    _productInfoBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.grey),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        actions: [
          FavouriteButton(
            product: product,
          ),
          const ShoppingBagButton(),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //Product Image
                    StreamBuilder<int>(
                        stream: _productInfoBloc.selectedProductByColorStream,
                        initialData: 0,
                        builder: (context, snapshot) {
                          var index = snapshot.data ?? 0;
                          return SizedBox(
                            width: double.infinity,
                            height: 380,
                            child: ImagesFireBaseStore(urlImage: product.urlPhoto[index], fit: BoxFit.cover,),
                          );
                        }),
                    //Name and price
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 25,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8,),
                          Text(
                            "${product.price}\$",
                            style: const TextStyle(
                              fontSize: 25,
                              color: Color(0xffe71717),
                            ),
                          )
                        ],
                      ),
                    ),
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Choose size',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff000000),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                //sizes
                                SizedBox(
                                  height: 48,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: product.sizes.length,
                                    itemBuilder: (context, index) {
                                      final sizes = product.sizes[index];
                                      return StreamBuilder<String>(
                                          stream: _productInfoBloc
                                              .selectedSizeStream,
                                          initialData: product.sizes[0],
                                          builder: (context, snapshot) {
                                            var selectedSize = snapshot.data;
                                            return InkWell(
                                              onTap: () {
                                                _productInfoBloc
                                                    .handleChooseSize(sizes);
                                              },
                                              child: Container(
                                                width: 44,
                                                height: 44,
                                                decoration: BoxDecoration(
                                                  color: selectedSize == sizes
                                                      ? const Color(0xff000000)
                                                      : const Color(0xffffffff),
                                                  border: Border.all(
                                                    color: Colors.grey.shade400,
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    sizes,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          selectedSize == sizes
                                                              ? const Color(
                                                                  0xffffffff)
                                                              : const Color(
                                                                  0xff000000),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                      width: 10,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.only(top: 15, bottom: 5),
                                  child: const Text(
                                    'Description',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                ExpandableText(
                                  product.description,
                                  style: const TextStyle(fontSize: 17),
                                  expandText: 'show more',
                                  collapseText: 'show less',
                                  maxLines: 4,
                                  expandOnTextTap: true,
                                  collapseOnTextTap: true,
                                  linkColor: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                          //Product Color
                          Container(
                            padding: const EdgeInsets.all(5),
                              width: 60,
                              child: ListView.separated(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: product.colors.length,
                                itemBuilder: (context, index) {
                                  final productColor = product.colors[index];
                                  bool isBorder = (productColor == 0xffffffff);
                                  return StreamBuilder<int>(
                                      stream:
                                          _productInfoBloc.selectedColorStream,
                                      initialData: product.colors[0],
                                      builder: (context, snapshot) {
                                        var selectedColor = snapshot.data;
                                        return GestureDetector(
                                          onTap: () {
                                            _productInfoBloc.handleChooseColor(
                                                productColor, index);
                                          },
                                          child: Container(
                                              width:
                                                  selectedColor == productColor
                                                      ? 55
                                                      : 40,
                                              height:
                                                  selectedColor == productColor
                                                      ? 55
                                                      : 40,
                                              decoration: BoxDecoration(
                                                color: Color(productColor),
                                                shape: BoxShape.circle,
                                                border: isBorder ? Border.all(color: Colors.grey.shade400, width: 1.0) : null,
                                              )),
                                        );
                                      });
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  height: 10,
                                ),
                              ))
                        ],
                      ),
                    ),
                    const SizedBox(height: 60,)
                  ],
                ),
              ),
            ),
          ),
          //Add to cart
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () {
                _productInfoBloc.addProductToCart(product);
                QuickAlert.show(
                    context: context,
                    title: "Added to cart",
                    type: QuickAlertType.success);
              },
              child: Container(
                width: 230,
                height: 48,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: const Color(0xffd51122),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                        width: 21,
                        height: 18,
                        child: Icon(
                          Icons.shopping_cart,
                          color: Color(0xffffffff),
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Add to Cart',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
