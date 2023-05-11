import 'dart:async';

import 'package:flutter/material.dart';

import '../../base/bloc/bloc.dart';
import '../../models/product.dart';
import '../../shared/fake_data/fake_product.dart';

class CategoriesPageBloc extends Bloc {
  late TabController tabControllerSelectProductByGender;
  final _listProduct = FakeProduct().listProduct;
  List<String> listGenderToSelected = ['Women', 'Man', 'Kid'];
  List<List<String>> listCategoriesOfProducts = [
    ['T-Shirt', 'Jacket', 'Short', 'Dress'],
    ['T-Shirt', 'Jacket', 'Short'],
    ['T-Shirt', 'Jacket', 'Short'],
  ];
  String selectedGender = '';
  String selectedCategory = '';
  int indexSelectedByGender = 0;
  int indexSelectedByCategory = 0;

  final _tabBarStreamController = StreamController<int>.broadcast();
  final _categorySelectedStreamController =
  StreamController<int>.broadcast();


  Stream<int> get tabBarStream =>
      _tabBarStreamController.stream;
  Stream<int> get categorySelectedStream =>
      _categorySelectedStreamController.stream;

  StreamSink get _tabBarSink =>
      _tabBarStreamController.sink;
  StreamSink get _categorySelectedSink =>
      _categorySelectedStreamController.sink;

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
  handleSelectedProductByCategory(int index) {
    indexSelectedByCategory = index;
    _categorySelectedSink
        .add(indexSelectedByCategory);
  }
  setIndexForTabBar(int index) {
    indexSelectedByGender = index;
    //sau khi chọn index cho tabar thì set lại index cho Product Selected By Category để tránh bị lưu index đã chọn trong tabbar khác
    indexSelectedByCategory = 0;
    _tabBarSink.add(index);
  }

  @override
  void dispose() {
    tabControllerSelectProductByGender.dispose();
    super.dispose();
  }
}
