import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery/constants.dart';
import 'package:intl/intl.dart';

import 'package:grocery/offers/offer_detail_page.dart';
import 'package:grocery/products/product_detail_page.dart';

class OrderDetailScreen extends StatelessWidget {
  static const routeName = "/order_detail_screen";
  @override
  Widget build(BuildContext context) {
    final orderDetails =
        ModalRoute.of(context).settings.arguments as QueryDocumentSnapshot;
    var date = orderDetails["orderDate"].toDate();
    final orderDate = DateFormat.yMMMd().format(date);
    var deliveryDate;
    if (orderDetails["deliveryDate"] != null) {
      var date = orderDetails["deliveryDate"].toDate();
      deliveryDate = DateFormat.yMMMd().format(date);
    }
    var total = 0;
    for (var data in orderDetails.get("products")) {
      total = total + int.parse(data["quantity"]);
    }
    for (var data in orderDetails.get("offers")) {
      total = total + int.parse(data["quantity"]);
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Order Details"),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10))),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 15, left: 10, bottom: 15),
              child: Text(
                "View Order Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              width: double.infinity,
              height: 170,
              child: Card(
                elevation: 5.0,
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          left: 30,
                          top: 20,
                          right: 105,
                          bottom: 25,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Order Date:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(orderDate,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(left: 30, bottom: 25, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Order Id:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(orderDetails.id,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(left: 30, bottom: 25, right: 73),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Order Total:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            total > 1
                                ? Text(
                                    "Rs.${orderDetails["totalAmount"]} (${total.toString()} items)",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
                                : Text(
                                    "Rs.${orderDetails["totalAmount"]} (${total.toString()} item)",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15, left: 10, bottom: 15),
              child: Text(
                "Shippment Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child: Card(
                elevation: 5.0,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          left: 30,
                          top: 20,
                        ),
                        child: orderDetails["fulFilled"] == 1
                            ? Text(
                                "Delivered",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              )
                            : Text(
                                "On the Way",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: 30,
                          top: 10,
                          right: 70,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Delivery Date:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            orderDetails["fulFilled"] == 1 &&
                                    orderDetails["deliveryDate"] != null
                                ? Text(deliveryDate,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
                                : Text("Products not delivered",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      if (orderDetails.get("products").length > 0)
                        Divider(
                          color: Colors.grey,
                        ),
                      if (orderDetails.get("products").length > 0)
                        Container(
                          height: 20,
                          margin: EdgeInsets.only(
                            left: 30,
                            top: 10,
                            right: 70,
                          ),
                          child: Text(
                            "Products",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      if (orderDetails.get("products").length > 0)
                        Container(
                          height: 230,
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(
                            left: 30,
                            top: 10,
                            right: 30,
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: orderDetails.get("products").length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(left: 5, right: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        final doc = await FirebaseFirestore
                                            .instance
                                            .collection("Products")
                                            .doc(orderDetails["products"][index]
                                                ["productId"])
                                            .get();
                                        showDialog(
                                            context: context,
                                            builder: (ctx) {
                                              return ProductDetail2(doc, 1);
                                            });
                                      },
                                      child: Container(
                                        height: 250,
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
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 120,
                                                  margin: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        orderDetails["products"]
                                                                [index]
                                                            ["productImage"],
                                                      ),
                                                      fit: BoxFit.fill,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                ),
                                                Text(
                                                  orderDetails["products"]
                                                      [index]["category"],
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  orderDetails["products"]
                                                      [index]["brand"],
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  orderDetails["products"]
                                                      [index]["productName"],
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                int.parse(orderDetails[
                                                                    "products"]
                                                                [index]
                                                            ["quantity"]) >
                                                        1
                                                    ? Text(
                                                        "${orderDetails["products"][index]["quantity"]} items",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )
                                                    : Text(
                                                        "${orderDetails["products"][index]["quantity"]} item",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                Text(
                                                  "Rs.${orderDetails["products"][index]["sellingPrice"]}",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
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
                      if (orderDetails.get("offers").length != 0)
                        Divider(
                          color: Colors.grey,
                        ),
                      if (orderDetails.get("offers").length > 0)
                        Container(
                          height: 20,
                          margin: EdgeInsets.only(
                            left: 30,
                            top: 10,
                            right: 70,
                          ),
                          child: Text(
                            "Offers",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      if (orderDetails.get("offers").length > 0)
                        Container(
                          height: 260,
                          margin: EdgeInsets.only(
                            left: 30,
                            top: 10,
                            right: 30,
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: orderDetails.get("offers").length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(left: 5, right: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        final doc = await FirebaseFirestore
                                            .instance
                                            .collection("Offers")
                                            .doc(orderDetails["offers"][index]
                                                ["productId"])
                                            .get();
                                        showDialog(
                                            context: context,
                                            builder: (ctx) {
                                              return OfferDetail2(doc, 1);
                                            });
                                      },
                                      child: Container(
                                        //height: 250,
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
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 120,
                                                  margin: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        orderDetails["offers"]
                                                                [index]
                                                            ["productImage"],
                                                      ),
                                                      fit: BoxFit.fill,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                ),
                                                Text(
                                                  orderDetails["offers"][index]
                                                      ["offerName"],
                                                      textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  orderDetails["offers"][index]
                                                      ["category"],
                                                      textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  orderDetails["offers"][index]
                                                      ["brand"],
                                                      textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  orderDetails["offers"][index]
                                                      ["productName"],
                                                      textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                int.parse(orderDetails["offers"]
                                                                [index]
                                                            ["quantity"]) >
                                                        1
                                                    ? Text(
                                                        "${orderDetails["offers"][index]["quantity"]} items",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                                textAlign: TextAlign.center,
                                                      )
                                                    : Text(
                                                        "${orderDetails["offers"][index]["quantity"]} item",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                                textAlign: TextAlign.center,
                                                      ),
                                                Text(
                                                  "Rs.${orderDetails["offers"][index]["sellingPrice"]}",
                                                  style: TextStyle(
                                                      color: Colors.white),
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
                  ),
                ),
              ),
              margin: const EdgeInsets.all(10),
              width: double.infinity,
              height: orderDetails[
                "offers"].length > 0 && orderDetails["products"].length > 0
                    ? 690
                    : 400,
            ),
            Container(
              margin: EdgeInsets.only(top: 15, left: 10, bottom: 15),
              child: Text(
                "Shippment Address",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              width: double.infinity,
              height: 150,
              child: Card(
                elevation: 5.0,
                child: Container(
                  height: 35,
                  margin: EdgeInsets.only(
                    left: 30,
                    top: 10,
                    right: 70,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        orderDetails["userName"],
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${orderDetails["userDoorNo"]},",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text("${orderDetails["userStreetName"]},",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 5,
                      ),
                      Text("${orderDetails["userCityName"]},",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 5,
                      ),
                      Text("${orderDetails["userPincode"]}",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15, left: 10, bottom: 15),
              child: Text(
                "Order Summary",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              width: double.infinity,
              height: 180,
              child: Card(
                elevation: 5.0,
                child: Container(
                  height: 35,
                  margin: EdgeInsets.only(
                    left: 30,
                    top: 10,
                    right: 70,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          left: 20,
                          top: 10,
                          right: 15,
                          bottom: 25,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Items:",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            Text("Rs.${orderDetails["totalAmount"]}",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: 20,
                          top: 10,
                          right: 15,
                          bottom: 25,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Quantity:",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold)),
                            Text(total.toString(),
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: 20,
                          top: 10,
                          right: 15,
                          bottom: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Order Total:",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold)),
                            Text("Rs.${orderDetails["totalAmount"]}",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
