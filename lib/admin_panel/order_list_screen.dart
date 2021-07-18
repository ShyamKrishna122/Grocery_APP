import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

import 'package:grocery/models/orderModel.dart';
import 'package:grocery/admin_panel/admin_order_detail_screen.dart';

class OrderListScreen extends StatefulWidget {
  static const routeName = "/order_list_screen";
  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  CollectionReference orderSnapshot =
      FirebaseFirestore.instance.collection("Orders");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Order List"),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        )),
      ),
      body: StreamBuilder(
          stream: orderSnapshot
              .orderBy(
                "fulFilled",
              )
              .orderBy("orderDate")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            final orders = snapshot.data.docs;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                var date = orders[index]["orderDate"].toDate();
                final orderDate = DateFormat.yMMMd().format(date);
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          AdminOrderDetailScreen.routeName,
                          arguments: {
                            "order": orders[index],
                            "orderDate": orderDate
                          });
                    },
                    title: Text(orders[index]["userName"]),
                    subtitle: Text(orderDate),
                    trailing: FullFillButton(order: orders[index]),
                  ),
                );
              },
            );
          }),
    );
  }
}

class FullFillButton extends StatefulWidget {
  const FullFillButton({
    Key key,
    @required this.order,
  }) : super(key: key);

  final QueryDocumentSnapshot order;

  @override
  _FullFillButtonState createState() => _FullFillButtonState();
}

class _FullFillButtonState extends State<FullFillButton> {
  var isOnce = false;
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? CircularProgressIndicator()
        : FlatButton(
            onPressed: widget.order["fulFilled"] == 0 && isOnce == false
                ? () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await OrderModel().fulFillOrder(
                        id: widget.order.id,
                        revenue: widget.order.get("totalAmount"));
                    Toast.show("Order Delivered", context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                    setState(() {
                      isOnce = true;
                      _isLoading = false;
                    });
                  }
                : () {
                    Toast.show("Order Already delivered", context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  },
            child: isOnce == true || widget.order["fulFilled"] == 1
                ? Text("Fulfilled")
                : Text("Fulfill"),
          );
  }
}
