import 'package:fashion_app/custom_widget/favourite_button.dart';
import 'package:fashion_app/custom_widget/shopping_bag_button.dart';
import 'package:fashion_app/models/product.dart';
import 'package:fashion_app/ui/product_info/product_info_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

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
                            height: 350,
                            child: Image.asset(
                              product.urlPhoto[index],
                              fit: BoxFit.cover,
                            ),
                          );
                        }),
                    //Name and price
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            constraints: const BoxConstraints(
                              maxWidth: 250,
                            ),
                            child: Text(
                              product.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Text(
                            "${product.price}\$",
                            style: const TextStyle(
                              fontSize: 25,
                              color: Color(0xffe71717),
                              fontWeight: FontWeight.w600,
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
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Choose size',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff000000),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                //sizes
                                SizedBox(
                                  height: 60,
                                  child: ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: product.sizes.length,
                                    itemBuilder: (context, index) {
                                      final sizes = product.sizes[index];
                                      return StreamBuilder<String>(
                                          stream: _productInfoBloc
                                              .selectedSizeStream,
                                          initialData: 'S',
                                          builder: (context, snapshot) {
                                            var selectedSize = snapshot.data;
                                            return InkWell(
                                              onTap: () {
                                                _productInfoBloc
                                                    .handleChooseSize(sizes);
                                              },
                                              child: Container(
                                                width: 60,
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
                                      const EdgeInsets.only(top: 10, bottom: 5),
                                  child: const Text(
                                    'Description',
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),
                                Text(
                                  product.description,
                                  style: const TextStyle(fontSize: 17),
                                ),
                              ],
                            ),
                          ),
                          //Product Color
                          SizedBox(
                              width: 60,
                              child: ListView.separated(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: product.colors.length,
                                itemBuilder: (context, index) {
                                  final productColor = product.colors[index];
                                  return StreamBuilder<int>(
                                      stream:
                                          _productInfoBloc.selectedColorStream,
                                      initialData: product.colors.first,
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
                setState(() {});
              },
              child: Container(
                width: 230,
                height: 48,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: const Color(0xffd51212),
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
