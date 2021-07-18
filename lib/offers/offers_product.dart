import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery/constants.dart';
import '../offers/offer_detail.dart';

class OfferProductScreen extends StatefulWidget {
  static const routeName = "/offers_product_screen";
  final QueryDocumentSnapshot doc;
  OfferProductScreen(this.doc,);
  @override
  _OfferProductScreenState createState() => _OfferProductScreenState();
}

class _OfferProductScreenState extends State<OfferProductScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (ctx) {
              return OfferDetail(widget.doc);
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
                  widget.doc["offerName"],
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Container(
                margin: EdgeInsets.only(left: 25, top: 25),
                child: Text(
                  widget.doc["productName"],
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 25, top: 25),
                child: Text(
                  "Avail at just Rs.${widget.doc["sellingPrice"]}",
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
                  image: NetworkImage(widget.doc["imageUrls"][0]),
                  fit: BoxFit.fill),
              backgroundBlendMode: BlendMode.overlay,
            ),
          ),
        ),
      ]),
    );
  }
}
