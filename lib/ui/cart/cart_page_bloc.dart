import 'dart:async';

import 'package:fashion_app/models/final_product.dart';
import 'package:fashion_app/shared/fake_data/fake_product.dart';
import 'package:flutter/material.dart';

import '../../base/bloc/bloc.dart';
import '../../models/product.dart';
import '../../shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class CartPageBloc extends Bloc {
  final _pageCartController = PageController();
  late TabController tabController;
  bool isCheckedAll = false;
  Set<int> listSelectedIndex = {};
  List<FinalProduct> listPurchasedProduct = [];
  int totalCost = 0;

  //get List Product in Cart
  Future<Set<FinalProduct>> getListProductInCart() async {
    Set<FinalProduct> setProduct =
        await MySharedPreferences.getSetProductInCart();
    return setProduct.toList().reversed.toSet();
  }

  //get List Buy Again
  Future<List<FinalProduct>> getListBuyAgain() async {
    List<FinalProduct> listProduct =
        await MySharedPreferences.getListBuyAgain();
    listProduct.sort((a, b) {
      DateTime dateA = DateTime(0);
      DateTime dateB = DateTime(0);
      if (a.purchasedTime != '') {
        dateA = DateFormat('HH:mm:ss dd/MM/yyyy').parse(a.purchasedTime);
        dateB = DateFormat('HH:mm:ss dd/MM/yyyy').parse(b.purchasedTime);
      }
      return dateB.compareTo(dateA);
    });
    return listProduct;
  }

  final StreamController<bool> _isSelectedToDeleteStreamController =
      StreamController<bool>.broadcast();
  final StreamController<bool> _isCheckedBoxStreamController =
      StreamController<bool>.broadcast();
  final StreamController<bool> _checkAllStreamController =
      StreamController<bool>.broadcast();

  Stream<bool> get isSelectedToDeleteStream =>
      _isSelectedToDeleteStreamController.stream;

  Stream<bool> get isCheckedBoxStream => _isCheckedBoxStreamController.stream;

  Stream<bool> get checkAllStream => _checkAllStreamController.stream;

  StreamSink<bool> get _isSelectedToDeleteSink =>
      _isSelectedToDeleteStreamController.sink;

  StreamSink<bool> get _isCheckedBoxSink => _isCheckedBoxStreamController.sink;

  StreamSink<bool> get _checkAllSink => _checkAllStreamController.sink;

  @override
  void dispose() {
    _pageCartController.dispose();
    super.dispose();
  }

  Product findProductByID(FinalProduct finalProduct) {
    return FakeProduct()
        .listProduct
        .where((element) => element.id == finalProduct.id)
        .firstWhere((element) => true);
  }

  void handleCheck(
      Set<FinalProduct> listProductInCart, bool value, int newIndex) {
    if (value) {
      listSelectedIndex.add(newIndex);
    } else {
      listSelectedIndex.remove(newIndex);
    }
    totalCost = totalCostCheckAll(listProductInCart);

    _isCheckedBoxSink.add(value);
    //if all check box in listview are choose, check box in bottom will be chose
    isCheckedAll = listSelectedIndex.length == listProductInCart.length;
    _checkAllSink.add(isCheckedAll);
    _isSelectedToDeleteSink.add(listSelectedIndex.isNotEmpty);
  }

  void handleCheckAll(Set<FinalProduct> listProductInCart, bool newValue) {
    // cost calculation
    if (newValue == true) {
      listSelectedIndex = {
        for (var i = 0; i < listProductInCart.length; i++) i
      };
      totalCost = totalCostCheckAll(listProductInCart);
    } else {
      listSelectedIndex.clear();
      totalCost = 0;
    }
    isCheckedAll = newValue;
    _isCheckedBoxSink.add(isCheckedAll);
    _checkAllSink.add(isCheckedAll);
    _isSelectedToDeleteSink.add(listSelectedIndex.isNotEmpty);
  }

  int totalCostCheckAll(Set<FinalProduct> listProductInCart) {
    int sum = 0;
    for (var element in listSelectedIndex) {
      FinalProduct finalProduct = listProductInCart.elementAt(element);
      sum += finalProduct.price * finalProduct.quantity;
    }
    return sum;
  }

  handleBuy(Set<FinalProduct> setProductInCart) async {
    //get Time when press button Buy (paid for the product)
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('HH:mm:ss dd/MM/yyyy').format(now);
    //save list Buy Again
    listPurchasedProduct = await getListBuyAgain();
    for (var element in listSelectedIndex) {
      FinalProduct finalProduct = setProductInCart.elementAt(element);
      finalProduct.purchasedTime = formattedDate;
      listPurchasedProduct.add(finalProduct);
    }
    await MySharedPreferences.saveListBuyAgain(listPurchasedProduct);
    //refresh listProductInCart
    await updateListProductInCart(setProductInCart);
    listSelectedIndex.clear();
    _isSelectedToDeleteSink.add(false);
  }

  Future<void> updateListProductInCart(
      Set<FinalProduct> setProductInCart) async {
    Set<FinalProduct> setProductInCartFinal = {};
    for (var element in listSelectedIndex) {
      FinalProduct finalProduct = setProductInCart.elementAt(element);
      setProductInCartFinal.add(finalProduct);
    }

    for (var element in setProductInCartFinal) {
      setProductInCart.remove(element);
    }
    await MySharedPreferences.saveListProductInCart(setProductInCart);
  }

  void handleQuantity(num? value, FinalProduct finalProduct) {
    // finalProduct.quantity = value?.toInt() ?? 1;
    _checkAllSink.add(true);
  }

  Future<void> handleDelete() async {
    Set<FinalProduct> setProductInCart = await getListProductInCart();
    updateListProductInCart(setProductInCart);
    listSelectedIndex.clear();
    _isSelectedToDeleteSink.add(false);
  }
}
