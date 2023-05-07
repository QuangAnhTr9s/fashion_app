import 'package:flutter/material.dart';
import '../../component/image_firebase_storage.dart';
import '../../component/shopping_bag_button.dart';
import '../../models/product.dart';
import '../../shared/const/screen_consts.dart';
import 'favourite_page_bloc.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  //init HomePageBloc
  final _favouritePageBloc = FavouritePageBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _favouritePageBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Favourite",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          shadowColor: Colors.transparent,
          backgroundColor: Colors.white,
          actions: const [
            // search icon is on the right side of the appbar
            ShoppingBagButton(),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: FutureBuilder(
            future: _favouritePageBloc.getListMovieFavorite(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Text('An error has occurred');
                }
                Set<Product>? listProduct = snapshot.data;
                return listProduct == null || listProduct.isEmpty
                    ? buildTextEmptyListProduct()
                    : buildListViewFavouriteProduct(listProduct);
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }

  Center buildTextEmptyListProduct() => const Center(
        child: Text(
          "Your favorites list is empty!",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      );

  ListView buildListViewFavouriteProduct(Set<Product> listProduct) {
    return ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(
              height: 5,
            ),
        itemCount: listProduct.length,
        itemBuilder: (context, index) {
          final product = listProduct.elementAt(index);
          return InkWell(
            onTap: () => Navigator.pushNamed(
                context, RouteName.productInfoScreen,
                arguments: product),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  //Product Image
                  SizedBox(
                    width: double.infinity,
                    height: 320,
                    child: ImagesFireBaseStore(
                        urlImage: product.urlPhoto.first, fit: BoxFit.fill),
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
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 80),
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
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 20,
                                  constraints:
                                      const BoxConstraints(maxWidth: 80),
                                  child: Text(
                                    '${product.price} \$',
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 20,
                                child: Text(
                                  product.sizes.join('   '),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                              Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 150,
                                ),
                                height: 25,
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: product.colors.length,
                                  itemBuilder: (context, index) {
                                    var color = product.colors[index];
                                    return Container(
                                      height: 20,
                                      width: 25,
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
                  ),
                ],
              ),
            ),
          );
        });
  }
}
