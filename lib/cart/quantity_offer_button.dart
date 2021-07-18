import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery/constants.dart';

import 'package:grocery/models/cartModel.dart';

class QuantityOfferButton extends StatefulWidget {
  const QuantityOfferButton({
    Key key,
    this.cart,
  }) : super(key: key);

  final QueryDocumentSnapshot cart;

  @override
  _QuantityOfferButtonState createState() => _QuantityOfferButtonState();
}

class _QuantityOfferButtonState extends State<QuantityOfferButton> {
  var count;
  @override
  Widget build(BuildContext context) {
    count = int.parse(widget.cart["quantity"]);
    return Container(
      height: 40,
      width: 100,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            child: count == 1 ? Icon(Icons.delete,color: Colors.white) : Icon(Icons.remove,color: Colors.white),
            onTap: () {
              setState(() {
                count--;
              });
              CartModel().minusOfferQuantity(
                  cart: CartModel(
                      id: widget.cart.id, quantity: count.toString()));
            },
          ),
          Text(count.toString(),style: TextStyle(color: Colors.white),),
          GestureDetector(
            child: Icon(Icons.add,color: Colors.white),
            onTap: () {
              setState(() {
                count++;
              });
              CartModel().addOfferQuantity(
                  cart: CartModel(
                      id: widget.cart.id, quantity: count.toString()));
            },
          ),
        ],
      ),
    );
  }
}
