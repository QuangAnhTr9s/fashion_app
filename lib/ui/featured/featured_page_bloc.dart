import 'dart:async';

import 'package:flutter/material.dart';

import '../../base/bloc/bloc.dart';
import '../../models/product.dart';
import '../../shared/fake_data/fake_product.dart';

class FeaturedPageBloc extends Bloc {
  late TabController tabControllerNewProduct;
  late TabController tabControllerFeaturedProduct;
  final _listProduct = FakeProduct().listProduct;
  int indexNewProductSelectedByGender = 0;
  int indexFeaturedProductSelectedByGender = 0;
  int indexNewProductSelectedByCategory = 0;
  int indexFeaturedProductSelectedByCategory = 0;
  List<String> listGenderToSelected = ['Women', 'Man', 'Kid'];
  List<List<String>> listCategoriesOfProducts = [
    ['T-Shirt', 'Jacket', 'Short', 'Dress'],
    ['T-Shirt', 'Jacket', 'Short'],
    ['T-Shirt', 'Jacket', 'Short'],
  ];
  String selectedGender = '';
  String selectedCategory = '';

  final _newProductTabBarStreamController = StreamController<int>.broadcast();
  final _featuredProductTabBarStreamController =
      StreamController<int>.broadcast();

  final _categorySelectedInNewProductStreamController =
      StreamController<int>.broadcast();

  final _categorySelectedInFeaturedProductStreamController =
      StreamController<int>.broadcast();

  Stream<int> get newProductTabBarStream =>
      _newProductTabBarStreamController.stream;

  Stream<int> get featuredProductTabBarStream =>
      _featuredProductTabBarStreamController.stream;

  Stream<int> get categorySelectedInNewProductStream =>
      _categorySelectedInNewProductStreamController.stream;

  Stream<int> get categorySelectedInFeaturedProductStream =>
      _categorySelectedInFeaturedProductStreamController.stream;

  StreamSink get _newProductTabBarSink =>
      _newProductTabBarStreamController.sink;

  StreamSink get _featuredProductTabBarSink =>
      _featuredProductTabBarStreamController.sink;

  StreamSink get _categorySelectedInNewProductSink =>
      _categorySelectedInNewProductStreamController.sink;

  StreamSink get _categorySelectedInFeaturedProductSink =>
      _categorySelectedInFeaturedProductStreamController.sink;

  List<Product> getListProduct(int indexGender, int indexCategory) {
    selectedGender = listGenderToSelected[indexGender];
    selectedCategory = listCategoriesOfProducts[indexGender][indexCategory];
    List<Product> listResult = [];
    for (var element in _listProduct) {
      if (element.typeByGender
              .trim()
              .toLowerCase()
              .contains(selectedGender.trim().toLowerCase()) &&
          element.category
              .trim()
              .toLowerCase()
              .contains(selectedCategory.trim().toLowerCase())) {
        listResult.add(element);
      }
    }
    return listResult;
  }

  handleSelectedFeaturedProductByCategory(int index) {
    indexFeaturedProductSelectedByCategory = index;
    _categorySelectedInFeaturedProductSink
        .add(indexFeaturedProductSelectedByCategory);
  }

  handleSelectedNewProductByCategory(int index) {
    indexNewProductSelectedByCategory = index;
    _categorySelectedInNewProductSink.add(indexNewProductSelectedByCategory);
  }

  void setIndexForTabBarInNewProducts(int index) {
    indexNewProductSelectedByGender = index;
    //sau khi chọn index cho tabar thì set lại index cho Product Selected By Category để tránh bị lưu index đã chọn trong tabbar khác
    indexNewProductSelectedByCategory = 0;
    _newProductTabBarSink.add(index);
  }

  void setIndexForTabBarInFeaturedProducts(int index) {
    indexFeaturedProductSelectedByGender = index;
    //sau khi chọn index cho tabar thì set lại index cho Product Selected By Category để tránh bị lưu index đã chọn trong tabbar khác
    indexFeaturedProductSelectedByCategory = 0;
    _featuredProductTabBarSink.add(index);
  }

  @override
  void dispose() {
    tabControllerNewProduct.dispose();
    tabControllerFeaturedProduct.dispose();
    super.dispose();
  }
}
