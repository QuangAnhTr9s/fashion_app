import 'dart:async';

import '../../base/bloc/bloc.dart';
import '../../models/product/product.dart';
import '../../network/fire_base/firestore.dart';
import '../../shared/fake_data/fake_product.dart';

class FavouritePageBloc extends Bloc {
  //get ListFavorite from
  /* Future<Set<Product>> getListProductFavorite() async{
    return await MySharedPreferences.getListFavouriteProducts();
  }*/
  Future<Set<Product>> getSetFavoriteProducts() async {
    List<String> listFavoriteProductID =
        await FireStore().getListFavoriteProductIDs();
    List<Product> listProduct = FakeProduct.listProduct;
    Set<Product> setProductByID = {};
    for (var id in listFavoriteProductID) {
      for (var product in listProduct) {
        if (product.id.toString() == id) {
          setProductByID.add(product);
          break;
        }
      }
    }
    return setProductByID;
  }
}
