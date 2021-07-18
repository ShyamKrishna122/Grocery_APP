import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:grocery/offers/offer_detail.dart';
import 'offer_alone_products.dart';

class OffersView extends StatefulWidget {
  @override
  _OffersViewState createState() => _OffersViewState();
}

class _OffersViewState extends State<OffersView> {
  List<Color> colors = [
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.amberAccent,
    Colors.deepOrangeAccent,
    Colors.limeAccent,
  ];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Offers")
            .limit(5)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final offers = snapshot.data.docs;
          return offers.length > 0
              ? Container(
                  height: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin:
                                EdgeInsets.only(top: 15, left: 10, bottom: 15),
                            child: Text(
                              "Offers",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                OfferAloneProducts.routeName,
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
                      Container(
                        height: 230,
                        width: MediaQuery.of(context).size.width,
                        child: CarouselSlider.builder(
                          options: CarouselOptions(
                            height: 230,
                            viewportFraction: 1,
                            aspectRatio: 1,
                            initialPage: 0,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                            autoPlay: true,
                            enableInfiniteScroll:
                                offers.length > 1 ? true : false,
                            autoPlayInterval: Duration(seconds: 2),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 500),
                            autoPlayCurve: Curves.easeInToLinear,
                          ),
                          itemCount: offers.length,
                          itemBuilder: (context, index, _) {
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
                                  margin: EdgeInsets.all(5),
                                  width: MediaQuery.of(context).size.width - 10,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: FractionalOffset.topCenter,
                                      end: FractionalOffset.bottomCenter,
                                      colors: [
                                        colors[index].withOpacity(0.5),
                                        colors[index],
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.only(left: 25, top: 25),
                                        child: Text(
                                          offers[index]["offerName"],
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(left: 25, top: 25),
                                        child: Text(
                                          offers[index]["productName"],
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(left: 25, top: 25),
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
                                          image: NetworkImage(
                                              offers[index]["imageUrls"][0]),
                                          fit: BoxFit.fill),
                                      backgroundBlendMode: BlendMode.overlay,
                                    ),
                                  ),
                                ),
                              ]),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : Container();
        });
  }
}
