import 'package:fashion_app/component/custom_text_field.dart';
import 'package:fashion_app/ui/addProductToFireStore/add_product_to_fire_store_page_bloc.dart';
import 'package:flutter/material.dart';

class AddProductToFireStore extends StatefulWidget {
  const AddProductToFireStore({super.key});

  @override
  State<AddProductToFireStore> createState() => _AddProductToFireStoreState();
}

class _AddProductToFireStoreState extends State<AddProductToFireStore> {
  final _addProductToFireStoreBloc = AddProductToFireStoreBloc();

  @override
  void dispose() {
    _addProductToFireStoreBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //input id
            MyTextField(
                placeHolder: 'ID',
                textEditingController:
                    _addProductToFireStoreBloc.textIDEditingController,
                obscureText: false,
                errorText: null),
            const SizedBox(
              height: 10,
            ),
            //input Favorite Count
            MyTextField(
                placeHolder: 'Favorite Count',
                textEditingController: _addProductToFireStoreBloc
                    .textFavoriteCountEditingController,
                obscureText: false,
                errorText: null),
            const SizedBox(
              height: 10,
            ),
            //input comments
            MyTextField(
                placeHolder: 'Comments',
                textEditingController:
                    _addProductToFireStoreBloc.textCommentEditingController,
                obscureText: false,
                errorText: null),
            const SizedBox(
              height: 50,
            ),
            _buildButton(
                text: 'Add all products',
                onTap: _addProductToFireStoreBloc.addAllProductsToFireStore),
            const SizedBox(height: 10,),
            _buildButton(
                text: 'Delete all products',
                onTap:
                    _addProductToFireStoreBloc.deleteAllProductsToFireStore),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildButton({
    required String text,
    required Function onTap,
  }) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
