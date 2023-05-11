import 'dart:async';

import 'package:fashion_app/models/product.dart';
import 'package:fashion_app/shared_preferences/shared_preferences.dart';

import '../../base/bloc/bloc.dart';
import '../../models/final_product.dart';

class ProductInfoBloc extends Bloc {
  String? selectedSize;
  int? selectedColor;
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

  Stream<String> get selectedSizeStream => _selectedSizeStreamController.stream;

  StreamSink get _selectedSizeSink => _selectedSizeStreamController.sink;

  final _selectedColorStreamController = StreamController<int>.broadcast();

  Stream<int> get selectedColorStream => _selectedColorStreamController.stream;

  StreamSink get _selectedColorSink => _selectedColorStreamController.sink;
  final _selectedProductByColorStreamController =
      StreamController<int>.broadcast();

  Stream<int> get selectedProductByColorStream =>
      _selectedProductByColorStreamController.stream;

  StreamSink get _selectedProductByColorSink =>
      _selectedProductByColorStreamController.sink;

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
  }

  @override
  void dispose() {
    _selectedSizeStreamController.close();
    super.dispose();
  }
}
