import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery/cart/cart_button.dart';
import 'package:grocery/constants.dart';
import 'package:grocery/offers/offer_detail.dart';

class OfferAloneProducts extends StatefulWidget {
  static const routeName = "/offer_alone_products";
  @override
  _OfferAloneProductsState createState() => _OfferAloneProductsState();
}

class _OfferAloneProductsState extends State<OfferAloneProducts> {
  List<Color> colors = [
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.amberAccent,
    Colors.deepOrangeAccent,
    Colors.limeAccent,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Offers",
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
          CartButton(),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 5),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("Offers").snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final offers = snapshot.data.docs;
              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: offers.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return OfferDetail(offers[index]);
                          });
                    },
                    child: Stack(children: [
                      Container(
                        height: 230,
                        margin: EdgeInsets.all(5),
                        width: MediaQuery.of(context).size.width - 10,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter,
                            colors: [
                              kPrimaryColor.withOpacity(0.5),
                              kPrimaryColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 25, top: 25),
                              child: Text(
                                offers[index]["offerName"],
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 25, top: 25),
                              child: Text(
                                offers[index]["productName"],
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 25, top: 25),
                              child: Text(
                                "Avail at just Rs.${offers[index]["sellingPrice"]}",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 100,
                        right: 30,
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            image: DecorationImage(
                                image:
                                    NetworkImage(offers[index]["imageUrls"][0]),
                                fit: BoxFit.fill),
                            backgroundBlendMode: BlendMode.overlay,
                          ),
                        ),
                      ),
                    ]),
                  );
                },
              );
            }),
      ),
    );
  }
}
