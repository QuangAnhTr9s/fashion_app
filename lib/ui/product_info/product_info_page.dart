import 'package:expandable_text/expandable_text.dart';
import 'package:fashion_app/ui/product_info/product_info_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

import '../../component/favourite_product_button.dart';
import '../../component/image_firebase_storage.dart';
import '../../component/shopping_bag_button.dart';
import '../../models/product/product.dart';

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
          FavouriteProductButton(
            product: product,
            colorWhenNotSelected: Colors.grey,
          ),
          const ShoppingBagButton(),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _productInfoBloc.scrollController,
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildProductImage(),
                    _buildRowNameAndPrice(),
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildColumnChooseSizeAndDescription(),
                          ),
                          _buildChooseColor()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          //Add to cart
          Positioned(
            top: 20,
            right: 8,
            child: _buildButtonAddToCart(context),
          ),
        ],
      ),
    );
  }

  Container _buildChooseColor() {
    return Container(
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
                stream: _productInfoBloc.selectedColorStream,
                initialData: product.colors[0],
                builder: (context, snapshot) {
                  var selectedColor = snapshot.data;
                  return GestureDetector(
                    onTap: () {
                      _productInfoBloc.handleChooseColor(productColor, index);
                    },
                    child: Container(
                        width: selectedColor == productColor ? 55 : 40,
                        height: selectedColor == productColor ? 55 : 40,
                        decoration: BoxDecoration(
                          color: Color(productColor),
                          shape: BoxShape.circle,
                          border: isBorder
                              ? Border.all(
                                  color: Colors.grey.shade400, width: 1.0)
                              : null,
                        )),
                  );
                });
          },
          separatorBuilder: (context, index) => const SizedBox(
            height: 10,
          ),
        ));
  }

  Column _buildColumnChooseSizeAndDescription() {
    return Column(
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
        Container(
          width: 220,
          padding: const EdgeInsets.only(right: 8),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: product.sizes.length,
            itemBuilder: (context, index) {
              final sizes = product.sizes[index];
              return StreamBuilder<String>(
                  stream: _productInfoBloc.selectedSizeStream,
                  initialData: product.sizes[0],
                  builder: (context, snapshot) {
                    var selectedSize = snapshot.data;
                    return InkWell(
                      onTap: () {
                        _productInfoBloc.handleChooseSize(sizes);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
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
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: selectedSize == sizes
                                  ? const Color(0xffffffff)
                                  : const Color(0xff000000),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15, bottom: 5),
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
          style: const TextStyle(fontSize: 16),
          expandText: 'show more',
          collapseText: 'show less',
          maxLines: 5,
          expandOnTextTap: true,
          collapseOnTextTap: true,
          linkColor: Colors.grey,
        ),
      ],
    );
  }

  Container _buildRowNameAndPrice() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              product.name,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            "${product.price}\$",
            style: const TextStyle(
              fontSize: 20,
              color: Color(0xffe71717),
            ),
          )
        ],
      ),
    );
  }

  StreamBuilder<int> _buildProductImage() {
    return StreamBuilder<int>(
        stream: _productInfoBloc.selectedProductByColorStream,
        initialData: 0,
        builder: (context, snapshot) {
          var index = snapshot.data ?? 0;
          return Container(
            padding: const EdgeInsets.only(top: 10),
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 2,
            child: ImagesFireBaseStore(
              urlImage: product.urlPhoto[index],
              fit: BoxFit.fill,
            ),
          );
        });
  }

  GestureDetector _buildButtonAddToCart(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _productInfoBloc.addProductToCart(product);
        QuickAlert.show(
            context: context,
            title: "Added to cart",
            type: QuickAlertType.success);
      },
      child: FutureBuilder<bool>(
          future: _productInfoBloc.hasProductInCart(product.id),
          builder: (context, snapshot) {
            bool isAddToCart = snapshot.data ?? false;
            return ClipOval(
              child: StreamBuilder<bool>(
                  stream: _productInfoBloc.isAddToCartStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      isAddToCart = snapshot.data!;
                    }
                    return Container(
                      width: 44,
                      height: 44,
                      color: isAddToCart ? Colors.red : Colors.grey,
                      child: const Icon(
                        Icons.add_shopping_cart,
                        color: Color(0xffffffff),
                      ),
                    );
                  }),
            );
          }),
    );
  }
}
