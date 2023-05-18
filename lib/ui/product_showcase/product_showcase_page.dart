import 'package:expandable_text/expandable_text.dart';
import 'package:fashion_app/component/favourite_button.dart';
import 'package:fashion_app/shared/const/images.dart';
import 'package:fashion_app/shared/const/screen_consts.dart';
import 'package:fashion_app/ui/product_showcase/product_showscase_page_bloc.dart';
import 'package:flutter/material.dart';
import '../../component/image_firebase_storage.dart';
import '../../models/product/product.dart';

class ProductShowcasePage extends StatefulWidget {
  const ProductShowcasePage({super.key});

  @override
  State<ProductShowcasePage> createState() => _ProductShowcasePageState();
}

class _ProductShowcasePageState extends State<ProductShowcasePage> {
  //init HomePageBloc
  final _productShowcasePageBloc = ProductShowcasePageBloc();
  Set<Product> listProduct = {};

  @override
  void initState() {
    super.initState();
    listProduct = _productShowcasePageBloc.getListProducts();
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
          Product product = listProduct.elementAt(index);
          return Container(
            color: Colors.black,
            width: width,
            height: height - kBottomNavigationBarHeight,
            child: Stack(
              children: [
                //image
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(
                        context, RouteName.productInfoScreen,
                        arguments: product),
                    child: ImagesFireBaseStore(
                      urlImage: product.urlPhoto.last,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                //info
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
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      ExpandableText(
                        product.description,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.white),
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
                //like and comments
                Positioned(
                    right: 10,
                    bottom: MediaQuery.of(context).size.height / 3,
                    child: SizedBox(
                      width: 48,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: Center(
                              child: Transform.scale(
                                scale: 1.8,
                                child: FavouriteButton(
                                  product: product,
                                  colorWhenNotSelected: Colors.white,
                                  handleLike2: () {
                                    _productShowcasePageBloc.handleLike();
                                  },
                                ),
                              ),
                            ),
                          ),
                          //Text showing number of likes
                          StreamBuilder<bool>(
                              stream: _productShowcasePageBloc.isLikedStream,
                              builder: (context, snapshot) {
                                return _buildTextShowTextShowingNumberOfLikes(
                                    product);
                              }),
                          const SizedBox(
                            height: 10,
                          ),
                          IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                // set isScrollControlled để ModalBottomSheet có thể cuộn và có thể set height cho nó
                                context: context,
                                builder: (context) =>
                                    _buildModalBottomSheetComments(),
                              );
                            },
                            icon: Image.asset(MyImages.comment),
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextShowTextShowingNumberOfLikes(Product product) {
    return FutureBuilder<int>(
      future: _productShowcasePageBloc.getFavoriteCount(product.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final favoriteCount = snapshot.data!;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                favoriteCount.toString(),
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  _buildModalBottomSheetComments() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50), topRight: Radius.circular(50)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 3 / 4,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: const [
            Padding(
              padding: EdgeInsets.only(top: 16, bottom: 24),
              child: Text(
                'Comments',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            SizedBox(),
          ],
        ),
      ),
    );
  }
}
