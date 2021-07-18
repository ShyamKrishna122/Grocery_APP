import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'package:grocery/orders/my_orders.dart';
import 'package:grocery/models/cartModel.dart';
import 'package:grocery/models/orderModel.dart';
import 'package:grocery/models/userModel.dart';

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    this.cart,
    this.cartOffer,
    this.total,
  }) : super(key: key);

  final List<QueryDocumentSnapshot> cart;
  final List<QueryDocumentSnapshot> cartOffer;
  final int total;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Orders")
            .where("userPhone", isEqualTo: AppUser.phone)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final currentOrders = snapshot.data.docs;
          var check = 0;
          if (currentOrders.length >= 1) {
            check = currentOrders.lastIndexWhere((element) {
              return element["fulFilled"] == 0;
            });
          }
          return FlatButton(
            child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW',style:TextStyle(fontWeight: FontWeight.bold,color: Colors.white,),),
            onPressed: () async {
              if (currentOrders.length == 0 && widget.total > 0) {
                await showOrderDialog();
              } else if (widget.total > 0) {
                if (check == -1 || currentOrders[check]["fulFilled"] == 1) {
                  await showOrderDialog();
                } else if (currentOrders[check]["fulFilled"] == 0 ||
                    widget.total > 0 ||
                    widget.total != null) {
                  Toast.show("You can have only one Order in progress", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                }
              } else {
                Toast.show("Add items to cart", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              }
            },
            textColor: Colors.black,
          );
        });
  }

  // ignore: missing_return
  Future<void> showOrderDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Do you want to place order?"),
        content: Text("Are you sure?"),
        actions: [
          FlatButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
              },
              child: Text("Cancel")),
          FlatButton(
              onPressed: (widget.total <= 0 || _isLoading)
                  ? null
                  : () async {
                      setState(() {
                        _isLoading = true;
                      });
                      List<Map<String, dynamic>> cartItem =
                          widget.cart.map((cart) {
                        return CartModel().toMap(cartItem: cart);
                      }).toList();
                      List<Map<String, dynamic>> cartOfferItem =
                          widget.cartOffer.map((cartOffer) {
                        return CartModel().offerToMap(cartItem: cartOffer);
                      }).toList();
                      await OrderModel().addOrder(
                          order: OrderModel(
                        cartItem: cartItem,
                        cartOfferItem: cartOfferItem,
                        total: widget.total.toString(),
                        userPhone: AppUser.phone,
                        userName: AppUser.name,
                        userDoorNo: AppUser.doorNo,
                        userStreet: AppUser.streetName,
                        userCity: AppUser.cityName,
                        userPincode: AppUser.pincode,
                      ));
                      Navigator.of(ctx).pop();
                      setState(() {
                        _isLoading = false;
                      });
                      CartModel().clearCart();
                      CartModel().clearCartOffer();
                      Navigator.of(context)
                          .pushReplacementNamed(MyOrders.routeName);
                    },
              child: Text("OK")),
        ],
      ),
    );
  }
}
