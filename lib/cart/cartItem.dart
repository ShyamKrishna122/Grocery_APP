import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:grocery/products/product_detail_page.dart';
import 'quantityButton.dart';
import 'package:grocery/models/cartModel.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final List<QueryDocumentSnapshot> cart;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: cart.length,
      itemBuilder: (context, index) {
        var saving = double.parse(cart[index]["price"]) -
            double.parse(cart[index]["sellingPrice"]);
        return Column(
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () async {
                    final doc = await FirebaseFirestore.instance
                        .collection("Products")
                        .doc(cart[index]["id"])
                        .get();
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return ProductDetail2(doc, 0);
                        });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
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
                                    cart[index]["imageUrl"],
                                  ),
                                  radius: 25,
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Container(
                                width:
                                    cart[index]["brand"].toString().length > 7
                                        ? 100
                                        : null,
                                margin: EdgeInsets.only(left: 5),
                                alignment: Alignment.center,
                                child: FittedBox(
                                  child: Text(
                                    "${cart[index]["brand"]}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                width: cart[index]["productName"]
                                            .toString()
                                            .length >
                                        15
                                    ? 100
                                    : null,
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    "${cart[index]["productName"]}",
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
                                    cart[index]["category"],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    "${cart[index]["variant"]},${cart[index]["size"]} ${cart[index]["unit"]}",
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "\u{20B9}${cart[index]["sellingPrice"]}",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3,
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
                          child: QuantityButton(
                            cart: cart[index],
                          ),
                        ),
                      ],
                    ),
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
                          showDeleteDialog(context, cart[index].id);
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
                await CartModel().deleteCartProduct(id);
                Navigator.of(ctx).pop();
              },
              child: Text("OK")),
        ],
      ),
    );
  }
}
