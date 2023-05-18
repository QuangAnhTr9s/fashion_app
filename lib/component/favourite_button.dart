import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_app/network/fire_base/firestore.dart';
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
  bool _isLiked = false;

  // final List<Product> _listProduct = [];
  List<String> _listID = [];
  int _iD = 0;

  @override
  void initState() {
    super.initState();
    _iD = widget.product.id;
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    /*Set<Product> setProduct =
        await MySharedPreferences.getListFavouriteProducts();*/
    _listID = await FireStore().getListFavoriteProductIDs();
    // listProduct = setProduct.toList();
    setState(() {
      // isLiked = setProduct.contains(widget.product);
      _isLiked = _listID.contains(_iD.toString());
    });
  }

  Future<void> handleLike() async {
    if (_listID.contains(_iD.toString())) {
      // _listProduct.remove(_iD);
      _listID.remove(_iD.toString());
      await _decreaseFavoriteCount(_iD);
    } else {
      // _listProduct.insert(0, widget.product);
      _listID.insert(0, _iD.toString());
      await _incrementFavoriteCount(_iD);
    }
    await FireStore().updateFavoriteProductIDs(_listID);
    // await MySharedPreferences.saveListFavouriteProducts(_listProduct.toSet());
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
            _isLiked = !_isLiked;
          });
        },
        icon: Icon(
          Icons.favorite,
          color: _isLiked ? Colors.red : widget.colorWhenNotSelected,
          size: widget.size,
        ));
  }
}
