import 'package:flutter/material.dart';
import 'package:grocery/constants.dart';
import 'package:intl/intl.dart';

class AdminOrderDetailScreen extends StatelessWidget {
  static const routeName = "/admin_order_detail_screen";
  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context).settings.arguments as dynamic;
    final orderDetail = order["order"];
    final orderDate = order["orderDate"];
    var total = 0;
    for (var data in orderDetail.data()["products"]) {
      total = total + int.parse(data["quantity"]);
    }
    for (var data in orderDetail.data()["offers"]) {
      total = total + int.parse(data["quantity"]);
    }
    var deliveryDate;
    if (orderDetail["deliveryDate"] != null) {
      var date = orderDetail["deliveryDate"].toDate();
      deliveryDate = DateFormat.yMMMd().format(date);
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Order details"),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        )),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 15, left: 10, bottom: 15),
              child: Text(
                "User Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              width: double.infinity,
              height: 220,
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
                          right: 105,
                          bottom: 25,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Customer Name:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${orderDetail["userName"][0].toString().toUpperCase()}${orderDetail["userName"].toString().substring(1)}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(left: 30, bottom: 25, right: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Customer Phone Number:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              orderDetail['userPhone'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(left: 30, bottom: 25, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Customer Address:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${orderDetail["userDoorNo"]},",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${orderDetail["userStreetName"]},",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${orderDetail["userCityName"]},",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Tamil Nadu,",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${orderDetail["userPincode"]}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (orderDetail["products"].length > 0)
              Container(
                margin: EdgeInsets.only(top: 15, left: 10, bottom: 15),
                child: Text(
                  "Product Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            if (orderDetail["products"].length > 0)
              Container(
                height: 270,
                margin: EdgeInsets.all(10),
                child: Card(
                  elevation: 5.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: orderDetail["products"].length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(left: 10, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 230,
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
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 120,
                                        margin: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              orderDetail["products"][index]
                                                  ["productImage"],
                                            ),
                                            fit: BoxFit.fill,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      Text(
                                        orderDetail["products"][index]
                                            ["category"],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        orderDetail["products"][index]["brand"],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        orderDetail["products"][index]
                                            ["productName"],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      int.parse(orderDetail["products"][index]
                                                  ["quantity"]) >
                                              1
                                          ? Text(
                                              "${orderDetail["products"][index]["quantity"]} items",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          : Text(
                                              "${orderDetail["products"][index]["quantity"]} item",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                      Text(
                                        "Rs.${orderDetail["products"][index]["sellingPrice"]}",
                                        style: TextStyle(color: Colors.white),
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
              ),
            if (orderDetail["offers"].length > 0)
              Container(
                margin: EdgeInsets.only(top: 15, left: 10, bottom: 15),
                child: Text(
                  "Offer Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            if (orderDetail["offers"].length > 0)
              Container(
                height: 270,
                margin: EdgeInsets.all(10),
                child: Card(
                  elevation: 5.0,
                  child: ListView.builder(
                    itemCount: orderDetail["offers"].length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(left: 10, right: 5, top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 230,
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
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 120,
                                        margin: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              orderDetail["offers"][index]
                                                  ["productImage"],
                                            ),
                                            fit: BoxFit.fill,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      Text(
                                        orderDetail["offers"][index]
                                            ["offerName"],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        orderDetail["offers"][index]
                                            ["category"],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        "${orderDetail["offers"][index]["brand"]} ${orderDetail["offers"][index]["productName"]}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      int.parse(orderDetail["offers"][index]
                                                  ["quantity"]) >
                                              1
                                          ? Text(
                                              "${orderDetail["offers"][index]["quantity"]} items",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          : Text(
                                              "${orderDetail["offers"][index]["quantity"]} item",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                      Text(
                                        "Rs.${orderDetail["offers"][index]["sellingPrice"]}",
                                        style: TextStyle(color: Colors.white),
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
              ),
            Container(
              margin: EdgeInsets.only(top: 15, left: 10, bottom: 15),
              child: Text(
                "Order Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              width: double.infinity,
              height: 210,
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
                            Text(
                              "Order Date:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              orderDate,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(left: 30, bottom: 25, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Order Id:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              orderDetail.id,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(left: 30, bottom: 25, right: 70),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Order Total",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Rs.${orderDetail["totalAmount"]} (${total.toString()} items)",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(left: 30, bottom: 25, right: 70),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Delivery Date:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            orderDetail["fulFilled"] == 1 &&
                                    orderDetail["deliveryDate"] != null
                                ? Text(
                                    deliveryDate,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                : Text(
                                    "Products not delivered\n,Fulfill the order first",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
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
                "Payment Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              width: double.infinity,
              height: 145,
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
                      // Container(
                      //   margin: EdgeInsets.only(
                      //     left: 20,
                      //     top: 10,
                      //     right: 15,
                      //     bottom: 25,
                      //   ),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text(
                      //         "Items:",
                      //         style: TextStyle(fontWeight: FontWeight.bold),
                      //       ),
                      //       Text(
                      //         "Rs.${orderDetail["totalAmount"]}",
                      //         style: TextStyle(fontWeight: FontWeight.bold),
                      //       ),
                      //     ],
                      //   ),
                      // ),
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
                              "Total Quantity:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              total.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
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
                            Text(
                              "Order Total",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Rs.${orderDetail["totalAmount"]}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
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
