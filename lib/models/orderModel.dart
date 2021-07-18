import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  List<Map<String, dynamic>> cartItem;
  List<Map<String, dynamic>> cartOfferItem;
  String total;
  String userName;
  String userPhone;
  String userDoorNo;
  String userStreet;
  String userCity;
  String userPincode;
  DateTime orderDate;
  DateTime deliveryDate;
  int fulFilled;
  String fcmToken;

  OrderModel({
    this.cartOfferItem,
    this.cartItem,
    this.userName,
    this.userPhone,
    this.userDoorNo,
    this.userStreet,
    this.userCity,
    this.userPincode,
    this.total,
    this.fulFilled,
    this.orderDate,
    this.deliveryDate,
    this.fcmToken,
  });

  Future<void> addOrder({OrderModel order}) async {
    final result = await FirebaseFirestore.instance
        .collection("User")
        .where("userType", isEqualTo: 1)
        .get();
    String fcmToken = result.docs[0].data()["fcmToken"];
    Map<String, dynamic> data = {
      "products": order.cartItem,
      "offers": order.cartOfferItem,
      "totalAmount": order.total,
      "userName": order.userName,
      "userPhone": order.userPhone,
      "userDoorNo": order.userDoorNo,
      "userStreetName": order.userStreet,
      "userCityName": order.userCity,
      "userPincode": order.userPincode,
      "fulFilled": 0,
      "orderDate": DateTime.now(),
      "deliveryDate": null,
      "fcmToken": fcmToken,
    };

    await FirebaseFirestore.instance.collection("Orders").add(data);
  }

  Future<void> fulFillOrder({String id, String revenue}) async {
    await FirebaseFirestore.instance
        .collection("Orders")
        .doc(id)
        .update({"deliveryDate": DateTime.now(), "fulFilled": 1});

    final result = await FirebaseFirestore.instance
        .collection("Revenue")
        .doc("Revenue")
        .get();

    if (!result.exists) {
      await FirebaseFirestore.instance
          .collection("Revenue")
          .doc("Revenue")
          .set({"revenue": revenue});
    } else {
      await FirebaseFirestore.instance
          .collection("Revenue")
          .doc("Revenue")
          .update({
        "revenue": (int.parse(result.data()["revenue"]) + int.parse(revenue))
            .toString()
      });
    }
  }
}
