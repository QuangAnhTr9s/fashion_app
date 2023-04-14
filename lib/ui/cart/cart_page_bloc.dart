
import 'package:fashion_app/models/final_product.dart';
import 'package:fashion_app/shared/fake_data/fake_product.dart';
import 'package:flutter/material.dart';

import '../../base/bloc/bloc.dart';
import '../../models/product.dart';
import '../../shared_preferences/shared_preferences.dart';

class CartPageBloc extends Bloc {
  //get List Product in Cart
  Future<Set<FinalProduct>> getListProductInCart() async{
    return await MySharedPreferences.getListProductInCart();
  }

  final _pageCartController = PageController();
  late TabController tabController;

  @override
  void dispose() {
    _pageCartController.dispose();
    super.dispose();
  }

  Product findProductByID(FinalProduct finalProduct) {
    return FakeProduct().listProduct.where((element) => element.id == finalProduct.id).firstWhere((element) => true);
  }
}
