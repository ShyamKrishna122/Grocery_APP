import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:grocery/cart/cart_offer_item.dart';
import 'package:grocery/cart/no_cart.dart';
import 'package:grocery/cart/search_cart.dart';
import 'package:grocery/constants.dart';
import 'cartItem.dart';
import 'orderButton.dart';
import 'package:grocery/models/userModel.dart';

class CartScreen extends StatefulWidget {
  static const routeName = "/cart_screen";

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var cartLength = 0;
  var cartOfferLength = 0;
  var total2 = 0;

  @override
  void initState() {
    FirebaseFirestore.instance.collection("Offers").snapshots().listen((event) {
      cartOfferLength = event.docs.length;
    });
    FirebaseFirestore.instance
        .collection("Products")
        .snapshots()
        .listen((event) {
      cartLength = event.docs.length;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Cart",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10))),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        actions: [
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                showSearch(context: context, delegate: SearchCart());
              }),
        ],
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("User")
                  .doc(AppUser.phone)
                  .collection("CartOffer")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Something went wrong"),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final cartOffer = snapshot.data.docs;
                cartOfferLength = cartOffer.length;

                var cartOfferHeight = 130.0;
                return cartOfferLength > 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (cartOffer.length > 0)
                            Container(
                              margin: EdgeInsets.only(
                                  top: 15, left: 10, bottom: 15),
                              child: Text(
                                "Offers",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                          Container(
                              height: cartOfferHeight * cartOffer.length,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(
                                top: 5,
                                right: 10,
                                left: 10,
                              ),
                              child: CartOfferItem(cartOffer: cartOffer)),
                        ],
                      )
                    : cartLength == 0 && cartOfferLength == 0
                        ? Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height / 2,
                            child: NoCart(),
                          )
                        : Container();
              },
            ),
            SizedBox(
              height: 5,
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("User")
                    .doc(AppUser.phone)
                    .collection("Cart")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Something went wrong"),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final cart = snapshot.data.docs;
                  cartLength = cart.length;

                  var cartHeight = 130.0;
                  return cartLength > 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (cart.length > 0)
                              Container(
                                margin: EdgeInsets.only(
                                    top: 15, left: 10, bottom: 15),
                                child: Text(
                                  "Products",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            Container(
                                height: cartHeight * cart.length,
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(
                                  top: 5,
                                  right: 10,
                                  left: 10,
                                ),
                                child: CartItem(cart: cart)),
                          ],
                        )
                      : cartLength == 0 && cartOfferLength == 0
                          ? Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height / 2,
                              child: NoCart(),
                            )
                          : Container();
                }),
          ],
        ),
      ),
      bottomNavigationBar: cartLength == 0 && cartOfferLength == 0
          ? Container(
              height: kToolbarHeight+20,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              padding: EdgeInsets.only(top: 20.0),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("User")
                      .doc(AppUser.phone)
                      .collection("Cart")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Something went wrong"),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final cart = snapshot.data.docs;

                    var total1 = 0;

                    for (var data in cart.toList()) {
                      total1 = total1 +
                          (int.parse(data["quantity"]) *
                              int.parse(data["sellingPrice"]));
                    }
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("User")
                            .doc(AppUser.phone)
                            .collection("CartOffer")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text("Something went wrong"),
                            );
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          final cartOffer = snapshot.data.docs;

                          var total = 0;

                          for (var data in cartOffer.toList()) {
                            total = total +
                                (int.parse(data["quantity"]) *
                                    int.parse(data["sellingPrice"]));
                          }
                          total2 = total1 + total;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 15, bottom: 10),
                                child: Text(
                                  'Total',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: Chip(
                                  label: Text(
                                    "Rs.${total2.toString()}",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .primaryTextTheme
                                          .title
                                          .color,
                                    ),
                                  ),
                                  backgroundColor: Colors.blue,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  bottom: 10,
                                ),
                                child: OrderButton(
                                    cart: cart.toList(),
                                    cartOffer: cartOffer.toList(),
                                    total: total2),
                              ),
                            ],
                          );
                        });
                  }))
          : Container(),
    );
  }
}
