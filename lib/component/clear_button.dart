import 'package:fashion_app/models/product.dart';
import 'package:flutter/material.dart';

class ClearButton extends StatefulWidget {
  const ClearButton({
    super.key,
    required this.listProduct,
  });

  final List<Product>? listProduct;

  @override
  State<ClearButton> createState() => _ClearButtonState();
}

class _ClearButtonState extends State<ClearButton> {
  bool _isDeleted = false;
  List<Product>? listProduct;

  @override
  void initState() {
    super.initState();
    listProduct = widget.listProduct;
    _isDeleted = listProduct == null || listProduct!.isEmpty;
  }

  Future<void> handleTap() async {
    if(listProduct != null ){
      listProduct!.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        handleTap();
        setState(() {
          _isDeleted = !_isDeleted;
        });
      },
      icon: _isDeleted
          ? const Icon(
              Icons.delete_outline,
            )
          : const Icon(
              Icons.delete,
            ),
    );
  }
}
