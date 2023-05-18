import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_app/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../models/product/product.dart';

class FavouriteButton extends StatefulWidget {
  const FavouriteButton({
    super.key,
    required this.product,
    required this.colorWhenNotSelected,
    this.size,
    this.handleLike2,
  });

  final Product product;
  final Color colorWhenNotSelected;
  final double? size;
  final void Function()? handleLike2;

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
      await _decreaseFavoriteCount(widget.product.id);
      if (widget.product.id > 0) {
        widget.product.favoriteCount--;
      }
    } else {
      listProduct.insert(0, widget.product);
      await _incrementFavoriteCount(widget.product.id);
      widget.product.favoriteCount++;
    }
    await MySharedPreferences.saveListFavouriteProducts(listProduct.toSet());
  }

  Future<void> _incrementFavoriteCount(int id) async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc('product_$id')
        .update({'favoriteCount': FieldValue.increment(1)});
  }

  Future<void> _decreaseFavoriteCount(int id) async {
    final productDoc =
        FirebaseFirestore.instance.collection('products').doc('product_$id');
    final snapshot = await productDoc.get();
    final currentFavoriteCount = snapshot.data()!['favoriteCount'];
    if (currentFavoriteCount > 0) {
      productDoc.update({'favoriteCount': currentFavoriteCount - 1});
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          await handleLike();
          if (widget.handleLike2 != null) {
            widget.handleLike2!();
          }
          setState(() {
            isLiked = !isLiked;
          });
        },
        icon: Icon(
          Icons.favorite,
          color: isLiked ? Colors.red : widget.colorWhenNotSelected,
          size: widget.size,
        ));
  }
}
