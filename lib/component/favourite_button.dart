import 'package:fashion_app/models/product.dart';
import 'package:fashion_app/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class FavouriteButton extends StatefulWidget {
  const FavouriteButton({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  State<FavouriteButton> createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton> {
  bool isLiked = false;
  List<Product> listProduct = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    Set<Product> setProduct =
        await MySharedPreferences.getListFavouriteProducts();
    listProduct = setProduct.toList();
    setState(() {
      isLiked = setProduct.contains(widget.product);
    });
  }

  Future<void> handleLike() async {
    if (listProduct.contains(widget.product)) {
      listProduct.remove(widget.product);
    } else {
      listProduct.insert(0, widget.product);
    }
    await MySharedPreferences.saveListFavouriteProducts(listProduct.toSet());
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          handleLike();
          setState(() {
            isLiked = !isLiked;
          });
        },
        icon: Icon(
          Icons.favorite,
          color: isLiked ? Colors.red : Colors.grey,
        ));
  }
}
