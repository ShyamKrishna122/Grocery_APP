import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery/cart/cart_button.dart';

import 'package:grocery/widgets/search_products.dart';
import 'package:grocery/offers/offers_product.dart';
import 'package:grocery/products/productitem.dart';

class ProductsCategory extends StatefulWidget {
  static const routeName = "products-cat";
  @override
  _ProductsCategoryState createState() => _ProductsCategoryState();
}

class _ProductsCategoryState extends State<ProductsCategory> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final value =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    var cat = value["category"];

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          cat,
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
                showSearch(context: context, delegate: Search());
              }),
          CartButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: db
                .collection("Offers")
                .where("category", isEqualTo: cat)
                .snapshots(),
            builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              var offer = snapshot.data.docs;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (offer.length > 0)
                    Container(
                      margin: EdgeInsets.only(top: 15, left: 10, bottom: 15),
                      child: Text(
                        "Offers",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                  if (offer.length > 0)
                    Container(
                      height: 220,
                      child: CarouselSlider.builder(
                        options: CarouselOptions(
                          height: 250,
                          viewportFraction: 1,
                          aspectRatio: 1,
                          initialPage: 0,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                          autoPlay: true,
                          enableInfiniteScroll: false,
                          autoPlayInterval: Duration(seconds: 2),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 500),
                          autoPlayCurve: Curves.bounceIn,
                        ),
                        itemCount: offer.length,
                        itemBuilder: (context, index, _) {
                          var singleOffer = offer[index];
                          return OfferProductScreen(
                            singleOffer,
                          );
                        },
                      ),
                    ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15, left: 10, bottom: 15),
                    child: Text(
                      "Feature Products",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  StreamBuilder(
                    stream: db
                        .collection("Products")
                        .where("category", isEqualTo: cat)
                        .snapshots(),
                    builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      var length = snapshot.data.docs.length;
                      return length == 0
                          ? Center(
                              child: Text('No Products'),
                            )
                          : Container(
                              height: MediaQuery.of(context).size.height,
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 250,
                                        childAspectRatio: 0.7,
                                        crossAxisSpacing: 20,
                                        mainAxisSpacing: 20),
                                itemCount: length,
                                itemBuilder: (_, index) {
                                  var doc = snapshot.data.docs[index];
                                  return ProductItem(doc);
                                },
                              ),
                            );
                    },
                  ),
                ],
              );
            }),
      ),
    );
  }
}
