import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product/final_product.dart';
import '../models/product/product.dart';

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
  static Future<void> saveHistorySearch(List<String> historySearch) async {
    _sharedPreferences.setStringList('saveHistorySearch', historySearch);
  }

  static List<String> getHistorySearch() =>
      _sharedPreferences.getStringList('saveHistorySearch') ?? [];

  // Serialize the list into a JSON string:
  static String setProductsToJson(Set<FinalProduct> productSet) =>
      json.encode(List<dynamic>.from(productSet.map((x) => x.toJson())));

  // Deserialize the JSON string back into a List<User>:
  static Set<FinalProduct> setProductsFromJson(String str) =>
      Set<FinalProduct>.from(
          json.decode(str).map((x) => FinalProduct.fromJson(x)));

  //save set products in cart
  // Use the SharedPreferences API to save and retrieve the serialized JSON string:
  static Future<void> saveListProductInCart(
      Set<FinalProduct> setProduct) async {
    _sharedPreferences.setString(
        'listProductInCart', setProductsToJson(setProduct));
  }

  static Future<Set<FinalProduct>> getSetProductInCart() async {
    final setProductJson = _sharedPreferences.getString('listProductInCart');
    return setProductsFromJson(setProductJson ?? '[]');
  }

  // Serialize the list into a JSON string:
  static String listProductsToJson(List<FinalProduct> productList) =>
      json.encode(List<dynamic>.from(productList.map((x) => x.toJson())));

  // Deserialize the JSON string back into a List<User>:
  static List<FinalProduct> listProductsFromJson(String str) =>
      List<FinalProduct>.from(
          json.decode(str).map((x) => FinalProduct.fromJson(x)));

  //save List of paid products
  static Future<void> saveListBuyAgain(List<FinalProduct> listProduct) async {
    _sharedPreferences.setString(
        'ListBuyAgain', listProductsToJson(listProduct));
  }

  static Future<List<FinalProduct>> getListBuyAgain() async {
    final listProductJson = _sharedPreferences.getString('ListBuyAgain');
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
