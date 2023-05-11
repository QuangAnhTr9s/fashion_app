import 'package:fashion_app/shared/fake_data/fake_product.dart';

import '../../base/bloc/bloc.dart';
import '../../models/product.dart';

class ProductShowcasePageBloc extends Bloc {
  //get ListFavorite from
  List<Product> getListProduct() {
    List<Product> listProduct = FakeProduct().listProduct;
    listProduct.sort(
      (a, b) => a.favoriteCount.compareTo(b.favoriteCount),
    );
    return listProduct;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
