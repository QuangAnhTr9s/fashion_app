import 'package:fashion_app/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../../component/image_firebase_storage.dart';
import '../../component/shopping_bag_button.dart';
import '../../models/product/product.dart';
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
  Set<Product>? setProduct;

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
      child: FutureBuilder(
        future: _favouritePageBloc.getSetFavoriteProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text('An error has occurred');
            }
            setProduct = snapshot.data;
            print(setProduct?.map((e) => e.id).toSet().toString());
            print(setProduct);
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  "Favourite",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                shadowColor: Colors.transparent,
                backgroundColor: Colors.white,
                actions: [
                  IconButton(
                    icon: Icon(
                      (setProduct == null || setProduct!.isEmpty)
                          ? Icons.delete_outline
                          : Icons.delete,
                    ),
                    onPressed: () async {
                      if (setProduct != null) {
                        setState(() {
                          setProduct!.clear();
                        });
                        await MySharedPreferences.saveListFavouriteProducts(
                            setProduct!);
                      }
                    },
                    color: Colors.grey,
                  ),
                  const ShoppingBagButton(),
                ],
              ),
              body: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: (setProduct == null || setProduct!.isEmpty)
                    ? buildTextEmptyListProduct()
                    : buildListViewFavouriteProduct(setProduct!),
              ),
            );
          } else {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            ));
          }
        },
      ),
    );
  }

  Widget buildTextEmptyListProduct() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Your favorites list is empty!",
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: () =>
                  Navigator.pushNamed(context, RouteName.homeScreen),
              child: const Text(
                "Let's explore together  ->",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ))
        ],
      ),
    );
  }

  ListView buildListViewFavouriteProduct(Set<Product> setProduct) {
    return ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(
              height: 5,
            ),
        itemCount: setProduct.length,
        itemBuilder: (context, index) {
          final product = setProduct.elementAt(index);
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
                    height: 300,
                    child: ImagesFireBaseStore(
                        urlImage: product.urlPhoto.first, fit: BoxFit.fill),
                  ),
                  //Product Info
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade200,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 10),
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
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 20,
                                constraints: const BoxConstraints(maxWidth: 80),
                                child: Text(
                                  '${product.price} \$',
                                  style: const TextStyle(
                                    fontSize: 18,
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
                ],
              ),
            ),
          );
        });
  }
}
