import 'dart:async';

import 'package:fashion_app/shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

import '../../base/bloc/bloc.dart';
import '../../models/product/final_product.dart';
import '../../models/product/product.dart';

class ProductInfoBloc extends Bloc {
  String? selectedSize;
  int? selectedColor;
  ScrollController scrollController = ScrollController();
  FinalProduct finalProduct = FinalProduct(
      id: 0,
      name: '',
      price: 0,
      urlPhoto: '',
      description: '',
      sizes: '',
      colors: 0,
      quantity: 1);

  final _selectedSizeStreamController = StreamController<String>.broadcast();
  final _selectedColorStreamController = StreamController<int>.broadcast();
  final _selectedProductByColorStreamController =
      StreamController<int>.broadcast();
  final _isAddToCartStreamController = StreamController<bool>.broadcast();

  Stream<String> get selectedSizeStream => _selectedSizeStreamController.stream;

  Stream<int> get selectedColorStream => _selectedColorStreamController.stream;

  Stream<int> get selectedProductByColorStream =>
      _selectedProductByColorStreamController.stream;

  Stream<bool> get isAddToCartStream => _isAddToCartStreamController.stream;

  StreamSink get _selectedSizeSink => _selectedSizeStreamController.sink;

  StreamSink get _selectedColorSink => _selectedColorStreamController.sink;

  StreamSink get _selectedProductByColorSink =>
      _selectedProductByColorStreamController.sink;

  StreamSink get _isAddToCartSink => _isAddToCartStreamController.sink;

  void handleChooseSize(String size) {
    selectedSize = size;
    finalProduct.sizes = size;
    _selectedSizeSink.add(selectedSize);
  }

  void handleChooseColor(int color, int index) {
    selectedColor = color;
    finalProduct.colors = color;
    _selectedColorSink.add(selectedColor);
    _selectedProductByColorSink.add(index);
  }

  Future<void> addProductToCart(Product product) async {
    finalProduct.id = product.id;
    finalProduct.name = product.name;
    finalProduct.price = product.price;
    finalProduct.urlPhoto = product.urlPhoto.first;
    finalProduct.colors = selectedColor ?? product.colors.first;
    finalProduct.sizes = selectedSize ?? product.sizes.first;
    var listProduct = await MySharedPreferences.getSetProductInCart();
    listProduct.add(finalProduct);
    MySharedPreferences.saveListProductInCart(listProduct);
    _isAddToCartSink.add(true);
  }

  //kiểm tra xem có product này trong cart không
  Future<bool> hasProductInCart(int productID) async {
    Set<FinalProduct> setProduct =
        await MySharedPreferences.getSetProductInCart();
    bool hasProduct = setProduct.any((element) => element.id == productID);
    return hasProduct;
  }

  void handleScrollToBottom() {
    Future.delayed(const Duration(seconds: 2), () {
      if (scrollController.hasClients) {
        final position = scrollController.position.maxScrollExtent;
        scrollController.animateTo(
          position,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _selectedSizeStreamController.close();
    _isAddToCartStreamController.close();
    _selectedColorStreamController.close();
    _selectedProductByColorStreamController.close();
    super.dispose();
  }
}
