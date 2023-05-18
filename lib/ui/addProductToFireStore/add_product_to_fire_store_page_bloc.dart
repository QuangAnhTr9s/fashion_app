import 'package:fashion_app/base/bloc/bloc.dart';
import 'package:fashion_app/network/fire_base/firestore.dart';
import 'package:flutter/cupertino.dart';

class AddProductToFireStoreBloc extends Bloc {
  TextEditingController textIDEditingController = TextEditingController();
  TextEditingController textFavoriteCountEditingController =
      TextEditingController();
  TextEditingController textCommentEditingController = TextEditingController();
  FireStore fireStore = FireStore();
  @override
  void dispose() {
    textIDEditingController.dispose();
    textFavoriteCountEditingController.dispose();
    textCommentEditingController.dispose();
    super.dispose();
  }

  addAllProductsToFireStore() {
    fireStore.addAllProductToFireStore();
  }
  deleteAllProductsToFireStore() {
    fireStore.deleteAllProductsFromFirestore();
  }
}
