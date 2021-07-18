import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

import 'package:grocery/models/userModel.dart';
import 'package:grocery/models/cartModel.dart';
import 'package:grocery/cart/cart_screen.dart';
import 'package:grocery/orders/order_detail_screen.dart';

class MyOrders extends StatefulWidget {
  static const routeName = "/my_orders";
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  CollectionReference myOrderSnapshot =
      FirebaseFirestore.instance.collection("Orders");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "My Orders",
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
      ),
      body: StreamBuilder(
        stream: myOrderSnapshot
            .where("userPhone", isEqualTo: AppUser.phone)
            .orderBy("fulFilled")
            .orderBy("orderDate")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final myOrders = snapshot.data.docs;
          return myOrders.length > 0
              ? ListView.builder(
                  itemCount: myOrders.length,
                  itemBuilder: (context, index) {
                    var date = myOrders[index]["orderDate"].toDate();
                    final orderDate = DateFormat.yMMMd().format(date);
                    var deliveryDate;
                    if (myOrders[index]["deliveryDate"] != null) {
                      var date = myOrders[index]["deliveryDate"].toDate();
                      deliveryDate = DateFormat.yMMMd().format(date);
                    }
                    return MyOrderItem(
                      myOrders: myOrders[index],
                      orderDate: orderDate,
                      deliveryDate: deliveryDate,
                    );
                  },
                )
              : Center(
                  child: Text("No Orders"),
                );
        },
      ),
    );
  }
}

class MyOrderItem extends StatefulWidget {
  const MyOrderItem({
    Key key,
    @required this.myOrders,
    @required this.orderDate,
    @required this.deliveryDate,
  }) : super(key: key);

  final QueryDocumentSnapshot myOrders;
  final String orderDate;
  final String deliveryDate;

  @override
  _MyOrderItemState createState() => _MyOrderItemState();
}

class _MyOrderItemState extends State<MyOrderItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(OrderDetailScreen.routeName, arguments: widget.myOrders);
      },
      child: Card(
        margin: EdgeInsets.all(10),
        child: ListTile(
          isThreeLine: true,
          title: Text('Total: Rs.${widget.myOrders["totalAmount"]}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Order Date:${widget.orderDate}"),
              if (widget.myOrders["fulFilled"] == 1)
                Text("Delivery Date:${widget.deliveryDate}"),
              widget.myOrders["fulFilled"] == 1
                  ? Text("Status: Delivered")
                  : Text("Status: Delivery Pending"),
            ],
          ),
          trailing: FlatButton(
              onPressed: () async {
                if (widget.myOrders["fulFilled"] == 1) {
                  await CartModel().buyAgain(widget.myOrders);
                  await CartModel().buyOfferAgain(widget.myOrders);
                  Navigator.of(context).popAndPushNamed(CartScreen.routeName);
                } else {
                  Toast.show(
                      "Your Previous order is yet to be delivered", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                }
              },
              child: Text("Buy Again")),
        ),
      ),
    );
  }
}
