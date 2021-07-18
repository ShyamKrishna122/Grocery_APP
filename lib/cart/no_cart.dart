import 'package:flutter/material.dart';

class NoCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.shopping_cart,
          size: 150,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Add Products to Cart",
          style: TextStyle(
            fontSize: 30,
          ),
        ),
      ],
    );
  }
}
