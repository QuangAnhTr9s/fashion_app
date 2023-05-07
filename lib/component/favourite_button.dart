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
  Set<Product> setProduct = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    Set<Product> setProductTran = await MySharedPreferences.getListFavouriteProducts();
    print(setProductTran);
    setProduct = setProductTran.toList().reversed.toSet();
    print(setProduct);
    setState(() {
      isLiked = setProduct.contains(widget.product);
    });
  }

  Future<void> handleLike() async {
    if (setProduct.contains(widget.product)) {
      setProduct.remove(widget.product);
    } else {
      setProduct.add(widget.product);
    }
    await MySharedPreferences.saveListFavouriteProducts(setProduct);
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
