import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery/cart/cartItem.dart';
import 'package:grocery/constants.dart';
import 'package:grocery/models/userModel.dart';

class SearchCart extends SearchDelegate<void> {
  String get searchFieldLabel => 'Search Products';

  @override
  TextStyle get searchFieldStyle => TextStyle(
        color: Colors.white,
        fontSize: 18.0,
      );
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: kPrimaryColor,
      primaryColorBrightness: Brightness.light,
      textTheme: TextTheme(
        // ignore: deprecated_member_use
        title: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            query = "";
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    CollectionReference cartSnapshot =
        FirebaseFirestore.instance.collection("User");
    return StreamBuilder(
      stream: cartSnapshot.doc(AppUser.phone).collection("Cart").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Something went wrong"),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final cartProducts = query.isEmpty
            ? []
            : snapshot.data.docs.where((element) {
                return element
                        .get("brand")
                        .toString()
                        .toUpperCase()
                        .contains(query) ||
                    element
                        .get("brand")
                        .toString()
                        .toLowerCase()
                        .contains(query) ||
                    element
                        .get("category")
                        .toString()
                        .toUpperCase()
                        .contains(query) ||
                    element
                        .get("category")
                        .toString()
                        .toLowerCase()
                        .contains(query) ||
                    element
                        .get("productName")
                        .toString()
                        .toUpperCase()
                        .contains(query) ||
                    element
                        .get("productName")
                        .toString()
                        .toLowerCase()
                        .contains(query);
              }).toList();

        return cartProducts.length > 0
            ? CartItem(cart: cartProducts)
            : Center(
                child: Text(
                  "No Products Found",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    CollectionReference cartSnapshot =
        FirebaseFirestore.instance.collection("User");
    return StreamBuilder(
      stream: cartSnapshot.doc(AppUser.phone).collection("Cart").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Something went wrong"),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final cartProducts = query.isEmpty
            ? []
            : snapshot.data.docs.where((element) {
                return element
                        .get("brand")
                        .toString()
                        .toUpperCase()
                        .contains(query) ||
                    element
                        .get("brand")
                        .toString()
                        .toLowerCase()
                        .contains(query) ||
                    element
                        .get("category")
                        .toString()
                        .toUpperCase()
                        .contains(query) ||
                    element
                        .get("category")
                        .toString()
                        .toLowerCase()
                        .contains(query) ||
                    element
                        .get("productName")
                        .toString()
                        .toUpperCase()
                        .contains(query) ||
                    element
                        .get("productName")
                        .toString()
                        .toLowerCase()
                        .contains(query);
              }).toList();

        return cartProducts.length > 0
            ? CartItem(cart: cartProducts)
            : Center(
                child: query.isEmpty
                    ? Text(
                        "Search any Product",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      )
                    : Text(
                        "No Products Found",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
              );
      },
    );
  }
}
