import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_app/network/fire_base/firestore.dart';
import 'package:flutter/material.dart';

import '../models/product/product.dart';

class FavouriteProductButton extends StatefulWidget {
  const FavouriteProductButton({
    super.key,
    required this.product,
    required this.colorWhenNotSelected,
    this.size,
    this.handleLike2,
    this.listShadows,
  });

  final Product product;
  final Color colorWhenNotSelected;
  final double? size;
  final void Function()? handleLike2;
  final List<Shadow>? listShadows;
  @override
  State<FavouriteProductButton> createState() => _FavouriteProductButtonState();
}

class _FavouriteProductButtonState extends State<FavouriteProductButton> {
  bool _isLiked = false;
  List<String> _listID = [];
  int _iD = 0;

  @override
  void initState() {
    super.initState();
    _iD = widget.product.id;
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
        .doc(id.toString())
        .update({'favoriteCount': FieldValue.increment(1)});
  }

  Future<void> _decreaseFavoriteCount(int id) async {
    final productDoc =
        FirebaseFirestore.instance.collection('products').doc(id.toString());
    final snapshot = await productDoc.get();
    final currentFavoriteCount = snapshot.data()!['favoriteCount'];
    if (currentFavoriteCount > 0) {
      productDoc.update({'favoriteCount': currentFavoriteCount - 1});
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: FireStore().getListFavoriteProductIDs(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text(
                    'Error in get List Favorite Product ID from Firestore: ${snapshot.error}'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Icon(
              Icons.favorite,
              color: widget.colorWhenNotSelected,
              size: widget.size,
            );
          } else {
            _listID = snapshot.data ?? [];
            _isLiked = _listID.contains(_iD.toString());
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
                  shadows: widget.listShadows,
                ));
          }
        });
  }
}
