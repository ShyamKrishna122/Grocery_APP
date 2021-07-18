import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:grocery/cart/quantity_offer_button.dart';
import 'package:grocery/offers/offer_detail_page.dart';
import 'package:grocery/models/cartModel.dart';

class CartOfferItem extends StatelessWidget {
  const CartOfferItem({
    Key key,
    @required this.cartOffer,
  }) : super(key: key);

  final List<QueryDocumentSnapshot> cartOffer;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: cartOffer.length,
      itemBuilder: (context, index) {
        var saving = int.parse(cartOffer[index]["price"]) -
            int.parse(cartOffer[index]["sellingPrice"]);
        return Column(
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () async {
                    final doc = await FirebaseFirestore.instance
                        .collection("Offers")
                        .doc(cartOffer[index]["id"])
                        .get();
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return OfferDetail2(doc, 0);
                        });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                left: 5,
                                top: 5,
                              ),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  cartOffer[index]["imageUrl"],
                                ),
                                radius: 25,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Container(
                              width:
                                  cartOffer[index]["brand"].toString().length >
                                          7
                                      ? 100
                                      : null,
                              margin: EdgeInsets.only(left: 5),
                              alignment: Alignment.center,
                              child: FittedBox(
                                child: Text(
                                  "${cartOffer[index]["brand"]}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Container(
                              width: cartOffer[index]["productName"]
                                          .toString()
                                          .length >
                                      15
                                  ? 100
                                  : null,
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  "${cartOffer[index]["productName"]}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      //fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 130,
                        child: ListTile(
                          title: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cartOffer[index]["offerName"],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(cartOffer[index]["category"]),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    "\u{20B9}${cartOffer[index]["sellingPrice"]}"),
                                SizedBox(
                                  height: 5,
                                ),
                                if (saving > 0)
                                  Text(
                                    "You Save \u{20B9}${saving.toString()}",
                                    style: TextStyle(color: Colors.red),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 20, top: 25),
                        alignment: Alignment.centerRight,
                        child: QuantityOfferButton(
                          cart: cartOffer[index],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          showDeleteDialog(context, cartOffer[index].id);
                        }),
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.grey,
            ),
          ],
        );
      },
    );
  }

  void showDeleteDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Delete Product From cart?"),
        content: Text("Are you sure?"),
        actions: [
          FlatButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
              },
              child: Text("Cancel")),
          FlatButton(
              onPressed: () async {
                await CartModel().deleteCartOffer(id);
                Navigator.of(ctx).pop();
              },
              child: Text("OK")),
        ],
      ),
    );
  }
}
