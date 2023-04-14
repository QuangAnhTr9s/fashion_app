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

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          Set<Product> listProduct =
              await MySharedPreferences.getListFavouriteProducts();
          listProduct.add(widget.product);
          MySharedPreferences.saveListFavouriteProducts(listProduct);
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
