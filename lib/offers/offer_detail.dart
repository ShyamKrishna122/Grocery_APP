import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toast/toast.dart';

import 'package:grocery/models/cartModel.dart';

class OfferDetail extends StatefulWidget {
  final DocumentSnapshot doc;
  OfferDetail(
    this.doc,
  );
  @override
  _OfferDetailState createState() => _OfferDetailState();
}

class _OfferDetailState extends State<OfferDetail> {
  int a = 1;
  List<String> images = [];
  var isInit = true;

  void didChangeDependencies() async {
    if (isInit) {
      try {
        images = List.from(widget.doc['imageUrls']);
      } catch (e) {}
      setState(() {
        isInit = false;
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return isInit
        ? Center(child: CircularProgressIndicator())
        : AlertDialog(
            title: Center(
              child: Container(
                child: Center(
                  child: Text(
                    widget.doc.get('brand') +
                        ' ' +
                        widget.doc.get('productName'),
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            content: Card(
              elevation: 10,
              child: Container(
                height: 450,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(images[0]),
                                fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.black)),
                        padding: EdgeInsets.all(2),
                      ),
                      Container(
                          margin: const EdgeInsets.all(5),
                          alignment: Alignment.topLeft,
                          child: Text(
                            widget.doc['offerName'],
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.all(5),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Description: ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                child: Text(
                                  widget.doc.get('description'),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                ),
                              )
                            ]),
                      ),
                      Container(
                        height: 50,
                        padding: EdgeInsets.all(5),
                        margin: const EdgeInsets.all(5),
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                              text: 'MRP:',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                                TextSpan(
                                  text: ' \u{20B9}' + widget.doc['mrp'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal),
                                )
                              ]),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        margin: const EdgeInsets.all(5),
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                              text: 'Offer Price:',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      ' \u{20B9}' + widget.doc['sellingPrice'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal),
                                )
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 7,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Text(
                            "Qty:",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          height: 28,
                          width: 28,
                          child: FloatingActionButton(
                              child: Icon(Icons.remove),
                              onPressed: () {
                                if (a > 1) {
                                  setState(() {
                                    a--;
                                  });
                                }
                              }),
                        ),
                        Text(
                          a.toString(),
                          style: TextStyle(fontSize: 17),
                        ),
                        Container(
                          height: 28,
                          width: 28,
                          child: FloatingActionButton(
                              child: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  a++;
                                });
                              }),
                        ),
                        Container(
                            child: RaisedButton(
                                color: Colors.white,
                                elevation: 7,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.black)),
                                child: Text(
                                  'Add To Cart',
                                  style: TextStyle(color: Colors.black),
                                ),
                                onPressed: () async {
                                  await CartModel()
                                      .addToCartOffer(
                                          cart: CartModel(
                                    id: widget.doc.id,
                                    brand: widget.doc.get("brand"),
                                    category: widget.doc.get("category"),
                                    productName: widget.doc.get("productName"),
                                    imageUrl: widget.doc.get("imageUrls")[0],
                                    price: widget.doc['mrp'],
                                    sp: widget.doc['sellingPrice'],
                                    quantity: a.toString(),
                                    offerName: widget.doc["offerName"],
                                    description: widget.doc["description"],
                                  ))
                                      .then((value) {
                                    Toast.show("Added to cart", context,
                                        duration: Toast.LENGTH_SHORT,
                                        gravity: Toast.BOTTOM);
                                  });
                                  Navigator.of(context).pop();
                                })),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
  }
}
