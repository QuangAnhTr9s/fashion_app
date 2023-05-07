import 'package:expandable_text/expandable_text.dart';
import 'package:fashion_app/shared/const/screen_consts.dart';
import 'package:fashion_app/ui/product_showcase/product_showscase_page_bloc.dart';
import 'package:flutter/material.dart';
import '../../component/image_firebase_storage.dart';
import '../../models/product.dart';

class ProductShowcasePage extends StatefulWidget {
  const ProductShowcasePage({super.key});

  @override
  State<ProductShowcasePage> createState() => _ProductShowcasePageState();
}

class _ProductShowcasePageState extends State<ProductShowcasePage> {
  //init HomePageBloc
  final _productShowcasePageBloc = ProductShowcasePageBloc();
  List<Product> listProduct = [];

  @override
  void initState() {
    super.initState();
    listProduct = _productShowcasePageBloc.getListProduct();
  }

  @override
  void dispose() {
    _productShowcasePageBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: listProduct.length,
        itemBuilder: (context, index) {
          Product product = listProduct[index];
          return InkWell(
            onTap: () => Navigator.pushNamed(
                context, RouteName.productInfoScreen,
                arguments: product),
            child: Container(
              color: Colors.black,
              width: width,
              height: height - kBottomNavigationBarHeight,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: ImagesFireBaseStore(
                      urlImage: product.urlPhoto.last,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 100,
                    bottom: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${product.price} \$',
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        ExpandableText(
                          product.description,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.white),
                          expandText: 'show more',
                          collapseText: 'show less',
                          maxLines: 2,
                          expandOnTextTap: true,
                          collapseOnTextTap: true,
                          linkColor: Colors.white,
                          linkStyle: const TextStyle(fontSize: 17),
                        ),
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
