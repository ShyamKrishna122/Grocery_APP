import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery/constants.dart';

import 'product_detail.dart';
import 'single_product.dart';

class FeatureProduct extends StatefulWidget {
  @override
  _FeatureProductState createState() => _FeatureProductState();
}

class _FeatureProductState extends State<FeatureProduct> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Products")
              .limit(5)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            final products = snapshot.data.docs;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (products.length > 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 15, left: 10, bottom: 15),
                        child: Text(
                          "Feature Products",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            SingleProduct.routeName,
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 15, left: 10, bottom: 15, right: 10),
                          child: Text(
                            "See All",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return ProductDetail(products[index]);
                                    });
                              },
                              child: Container(
                                height: 200,
                                width: 120,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        kPrimaryColor.withOpacity(0.6),
                                        kPrimaryColor,
                                      ],
                                      begin: Alignment.bottomRight,
                                      end: Alignment.topLeft,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 120,
                                        margin: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(products[index]
                                                ["imageUrls"][0]),
                                            fit: BoxFit.fill,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.all(5),
                                        child: Text(
                                          "${products[index]["brand"]} ${products[index]["productName"]}",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Text(
                                        products[index]["category"],
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }),
    );
  }
}
