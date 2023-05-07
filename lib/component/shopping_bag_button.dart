import 'package:fashion_app/ui/cart/cart_page.dart';
import 'package:flutter/material.dart';

class ShoppingBagButton extends StatelessWidget {
  const ShoppingBagButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          // Navigator.pushNamed(context, RouteName.cartScreen);
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage(),));
        },
        icon: const Icon(
          Icons.shopping_bag,
          color: Colors.grey,
        ));
  }
}
