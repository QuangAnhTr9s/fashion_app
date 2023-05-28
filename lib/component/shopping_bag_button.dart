import 'package:flutter/material.dart';

import '../shared/const/screen_consts.dart';

class ShoppingBagButton extends StatelessWidget {
  const ShoppingBagButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pushNamed(context, RouteName.cartScreen);
        },
        icon: const Icon(
          Icons.shopping_bag,
          color: Colors.grey,
        ));
  }
}
