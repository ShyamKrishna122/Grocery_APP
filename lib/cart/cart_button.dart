import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'package:grocery/cart/badge.dart';
import 'package:grocery/cart/cart_screen.dart';
import 'package:grocery/models/userModel.dart';

class CartButton extends StatelessWidget {
  const CartButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("User")
            .doc(AppUser.phone)
            .collection("Cart")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final doc = snapshot.data.docs;
          var sum1 = 0;
          for (var data in doc.toList()) {
            sum1 = sum1 + int.parse(data["quantity"]);
          }
          var total1 = sum1;

          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("User")
                  .doc(AppUser.phone)
                  .collection("CartOffer")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final doc1 = snapshot.data.docs;
                var sum2 = 0;
                for (var data in doc1.toList()) {
                  sum2 = sum2 + int.parse(data["quantity"]);
                }
                var total2 = sum2;
                var total3 = total1 + total2;
                return Badge(
                    child: IconButton(
                      icon: Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (total3 > 0) {
                          Navigator.of(context).pushNamed(
                            CartScreen.routeName,
                          );
                        } else {
                          Toast.show("Add Items to cart", context,
                              duration: Toast.LENGTH_SHORT,
                              gravity: Toast.BOTTOM);
                        }
                      },
                    ),
                    value: total3.toString());
              });
        });
  }
}
