import 'package:expandable_text/expandable_text.dart';
import 'package:fashion_app/component/favourite_product_button.dart';
import 'package:fashion_app/network/fire_base/firestore.dart';
import 'package:fashion_app/shared/const/images.dart';
import 'package:fashion_app/shared/const/screen_consts.dart';
import 'package:fashion_app/ui/product_showcase/modal_bottom_sheet_comment.dart';
import 'package:fashion_app/ui/product_showcase/product_showscase_page_bloc.dart';
import 'package:flutter/material.dart';
import '../../component/image_firebase_storage.dart';
import '../../models/product/product.dart';

class ProductShowcasePage extends StatefulWidget {
  const ProductShowcasePage({super.key});

  @override
  State<ProductShowcasePage> createState() => _ProductShowcasePageState();
}

class _ProductShowcasePageState extends State<ProductShowcasePage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  final _productShowcasePageBloc = ProductShowcasePageBloc();
  Set<Product> listProduct = {};

  // final TextEditingController _controller = TextEditingController();
  bool _isRefreshing = false;
  double height = 0;
  double width = 0;
  bool hasScreenSize = false;

  @override
  void initState() {
    super.initState();
    listProduct = _productShowcasePageBloc.getListProducts();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached) {
      print('detached');
      //nếu ko chọn lưu đăng nhập thì sau khi tắt app => đăng xuất trên firebase luôn
    } else if (state == AppLifecycleState.inactive) {
      print("inactive");
    } else if (state == AppLifecycleState.paused) {
      print("paused");
    } else if (state == AppLifecycleState.resumed) {
      print("resumed");
    }
  }

  @override
  void dispose() {
    _productShowcasePageBloc.dispose();
    super.dispose();
  }

  Future<void> _refreshPage() async {
    // Gọi các hàm cần thực hiện để làm mới dữ liệu trên trang
    listProduct = _productShowcasePageBloc.getListProducts();
    _isRefreshing = !_isRefreshing;
    // Set state để cập nhật UI sau khi làm mới dữ liệu
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print('build Product show case');
    super.build(context);
    if (!hasScreenSize) {
      final screenSize = MediaQuery.of(context).size;
      height = screenSize.height;
      width = screenSize.width;
      hasScreenSize = true;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: RefreshIndicator(
          onRefresh: _refreshPage,
          color: Colors.white,
          backgroundColor: Colors.grey,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: height - kBottomNavigationBarHeight - 20,
            ),
            // height: height - kBottomNavigationBarHeight,
            child: PageView.builder(
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
                      Positioned.fill(
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
                        child: _buildProductInfo(product),
                      ),
                      //like and comments
                      Positioned(
                          top: 0,
                          right: 0,
                          bottom: 0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildLikeAndComment(product, context),
                            ],
                          )),
                      /*Positioned(
                        top: 200,
                        child: SizedBox(
                          height: 50,
                          width: 100,
                          child: TextField(
                            controller: _controller,
                            decoration: const InputDecoration(),
                          ),
                        ),
                      ),*/
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLikeAndComment(Product product, BuildContext context) {
    return Container(
      width: 50,
      margin: const EdgeInsets.only(right: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
            width: 40,
            child: Center(
              child: Transform.scale(
                scale: 1.8,
                child: FavouriteProductButton(
                  product: product,
                  colorWhenNotSelected: Colors.white,
                  handleLike2: () {
                    _productShowcasePageBloc.handleLikeProduct();
                  },
                ),
              ),
            ),
          ),
          //Text showing number of likes
          _buildTextShowTextShowingNumber(
              productID: product.id,
              stream: _productShowcasePageBloc.isLikedProductStream,
              future: FireStore().getFavoriteProductCount,
              size: 20,
              color: Colors.white),
          const SizedBox(
            height: 10,
          ),
          //comment
          IconButton(
            onPressed: () {
              // _isShowModalBottomSheet = false;
              showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20))),
                isScrollControlled: true,
                // set isScrollControlled để ModalBottomSheet có thể cuộn và có thể set height cho nó
                context: context,
                builder: (context) => DraggableScrollableSheet(
                  initialChildSize: 0.7,
                  maxChildSize: 1,
                  minChildSize: 0.4,
                  builder: (context, scrollController) =>
                      ModalBottomSheetComment(
                    product: product,
                  ),
                ),
              ).then((value) => _productShowcasePageBloc.getNumberOfComments());
            },
            icon: SizedBox(
                height: 55,
                width: 55,
                child: Image.asset(
                  MyImages.commentIcon,
                  color: Colors.white,
                  fit: BoxFit.fill,
                )),
            color: Colors.white,
          ),
          //Text showing number of comments
          _buildTextShowTextShowingNumber(
              productID: product.id,
              stream: _productShowcasePageBloc.isTapCommentsProductStream,
              future: FireStore().getCommentProductCount,
              size: 20,
              color: Colors.white),
        ],
      ),
    );
  }

  Column _buildProductInfo(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w700,
            // shadows: [
            //   BoxShadow(
            //     color: Colors.grey.shade300,
            //     blurRadius: 2,
            //   )
            // ],
          ),
        ),
        Text(
          '${product.price} \$',
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        const SizedBox(height: 10),
        ExpandableText(
          product.description,
          style: const TextStyle(fontSize: 15, color: Colors.white),
          expandText: 'show more',
          collapseText: 'show less',
          maxLines: 2,
          expandOnTextTap: true,
          collapseOnTextTap: true,
          linkColor: Colors.grey,
          linkStyle: const TextStyle(fontSize: 17),
        ),
      ],
    );
  }

  Widget _buildTextShowTextShowingNumber(
      {required Future<int> Function(int) future,
      required int productID,
      required Stream<bool> stream,
      required double? size,
      required Color? color}) {
    return StreamBuilder<bool>(
        stream: stream,
        builder: (context, snapshot) {
          print('stream');
          return FutureBuilder<int>(
            future: future(productID),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final count = snapshot.data!;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      count.toString(),
                      style: TextStyle(fontSize: size, color: color),
                    ),
                  ],
                );
              } else {
                return const SizedBox();
              }
            },
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}
