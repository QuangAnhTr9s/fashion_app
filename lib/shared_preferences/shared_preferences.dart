import 'dart:convert';
import 'package:fashion_app/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/final_product.dart';

class MySharedPreferences {
  static late SharedPreferences _sharedPreferences;

  static Future<void> initSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }
  static Future<void> clearSharedPreferences() async {
    _sharedPreferences.clear();
  }

  static Future<void> setSaveSignIn(bool isSaveSignIn) async {
    _sharedPreferences.setBool('isSaveSignIn', isSaveSignIn);
  }

  static bool getIsSaveSignIn() =>
      _sharedPreferences.getBool('isSaveSignIn') ?? false;

  //save history Search
  static Future<void> setSaveHistorySearch(List<String> historySearch) async {
    _sharedPreferences.setStringList('saveHistorySearch', historySearch);
  }

  static List<String> getHistorySearch() =>
      _sharedPreferences.getStringList('saveHistorySearch') ?? [];

  // Serialize the list into a JSON string:
  static String listProductsToJson(Set<FinalProduct> productList) =>
      json.encode(List<dynamic>.from(productList.map((x) => x.toJson())));

  // Deserialize the JSON string back into a List<User>:
  static Set<FinalProduct> listProductsFromJson(String str) =>
      Set<FinalProduct>.from(
          json.decode(str).map((x) => FinalProduct.fromJson(x)));

  //save list products in cart
  // Use the SharedPreferences API to save and retrieve the serialized JSON string:
  static Future<void> saveListProductInCart(
      Set<FinalProduct> listProduct) async {
    _sharedPreferences.setString(
        'listProductInCart', listProductsToJson(listProduct));
  }

  static Future<Set<FinalProduct>> getListProductInCart() async {
    final listProductJson = _sharedPreferences.getString('listProductInCart');
    return listProductsFromJson(listProductJson ?? '[]');
  }

  //save list favourite products
  // Serialize the list into a JSON string:
  static String listFavouriteProductsToJson(Set<Product> productList) =>
      json.encode(List<dynamic>.from(productList.map((x) => x.toJson())));

  // Deserialize the JSON string back into a List<User>:
  static Set<Product> listFavouriteProductsFromJson(String str) =>
      Set<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

  // Use the SharedPreferences API to save and retrieve the serialized JSON string:
  static Future<void> saveListFavouriteProducts(
      Set<Product> listProduct) async {
    _sharedPreferences.setString(
        'ListFavouriteProducts', listFavouriteProductsToJson(listProduct));
  }

  static Future<Set<Product>> getListFavouriteProducts() async {
    final listFavouriteProductJson =
        _sharedPreferences.getString('ListFavouriteProducts');
    return listFavouriteProductsFromJson(listFavouriteProductJson ?? '[]');
  }
}
