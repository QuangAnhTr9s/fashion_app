import 'dart:async';

import '../../base/bloc/bloc.dart';
import '../../models/product.dart';
import '../../shared_preferences/shared_preferences.dart';

class FavouritePageBloc extends Bloc{

  //get ListFavorite from
  Future<Set<Product>> getListMovieFavorite() async{
    return await MySharedPreferences.getListFavouriteProducts();
  }
  @override
  void dispose() {
    super.dispose();
  }
}