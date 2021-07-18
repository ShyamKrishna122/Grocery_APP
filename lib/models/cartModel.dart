import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:grocery/models/userModel.dart';

class CartModel {
  String id;
  String brand;
  String category;
  String productName;
  String price;
  String size;
  String unit;
  String quantity;
  String imageUrl;
  String variant;
  String description;
  String offerName;
  String sp;

  CartModel({
    this.id,
    this.brand,
    this.category,
    this.productName,
    this.price,
    this.quantity,
    this.imageUrl,
    this.variant,
    this.size,
    this.unit,
    this.description,
    this.offerName,
    this.sp,
  });

  Map<String, dynamic> toMap({QueryDocumentSnapshot cartItem}) {
    Map<String, dynamic> cartMap = Map();
    cartMap["productId"] = cartItem["id"];
    cartMap["brand"] = cartItem["brand"];
    cartMap["category"] = cartItem["category"];
    cartMap["productName"] = cartItem["productName"];
    cartMap["productImage"] = cartItem["imageUrl"];
    cartMap["variant"] = cartItem["variant"];
    cartMap["price"] = cartItem["price"];
    cartMap["sellingPrice"] = cartItem["sellingPrice"];
    cartMap["quantity"] = cartItem["quantity"];
    cartMap["size"] = cartItem["size"];
    cartMap["unit"] = cartItem["unit"];
    return cartMap;
  }

  Map<String, dynamic> offerToMap({QueryDocumentSnapshot cartItem}) {
    Map<String, dynamic> cartMap = Map();
    cartMap["productId"] = cartItem["id"];
    cartMap["brand"] = cartItem["brand"];
    cartMap["category"] = cartItem["category"];
    cartMap["productName"] = cartItem["productName"];
    cartMap["productImage"] = cartItem["imageUrl"];
    cartMap["price"] = cartItem["price"];
    cartMap["quantity"] = cartItem["quantity"];
    cartMap["offerName"] = cartItem["offerName"];
    cartMap["description"] = cartItem["description"];
    cartMap["sellingPrice"] = cartItem["sellingPrice"];
    return cartMap;
  }

  Future<void> addToCart({CartModel cart}) async {
    Map<String, dynamic> data = {
      'id': cart.id,
      'brand': cart.brand,
      'category': cart.category,
      'productName': cart.productName,
      'price': cart.price,
      'quantity': cart.quantity,
      'imageUrl': cart.imageUrl,
      'variant': cart.variant,
      'size': cart.size,
      'unit': cart.unit,
      'sellingPrice': cart.sp,
    };

    await FirebaseFirestore.instance
        .collection("User")
        .doc(AppUser.phone)
        .collection("Cart")
        .where("id", isEqualTo: cart.id)
        .where("size", isEqualTo: cart.size)
        .get()
        .then((value) async {
      if (value.docs.length == 1) {
        await FirebaseFirestore.instance
            .collection("User")
            .doc(AppUser.phone)
            .collection("Cart")
            .doc(value.docs[0].id)
            .update({
          "quantity":
              (int.parse(value.docs[0]["quantity"]) + int.parse(cart.quantity))
                  .toString(),
        });
      } else {
        await FirebaseFirestore.instance
            .collection("User")
            .doc(AppUser.phone)
            .collection("Cart")
            .add(data);
      }
    });
  }

  Future<void> addQuantity({CartModel cart}) async {
    await FirebaseFirestore.instance
        .collection("User")
        .doc(AppUser.phone)
        .collection("Cart")
        .doc(cart.id)
        .update({"quantity": cart.quantity});
  }

  Future<void> minusQuantity({CartModel cart}) async {
    if (int.parse(cart.quantity) < 1) {
      await FirebaseFirestore.instance
          .collection("User")
          .doc(AppUser.phone)
          .collection("Cart")
          .doc(cart.id)
          .delete();
    } else {
      await FirebaseFirestore.instance
          .collection("User")
          .doc(AppUser.phone)
          .collection("Cart")
          .doc(cart.id)
          .update({"quantity": cart.quantity});
    }
  }

  Future<void> clearCart() async {
    await FirebaseFirestore.instance
        .collection("User")
        .doc(AppUser.phone)
        .collection("Cart")
        .get()
        .then((value) {
      for (DocumentSnapshot ds in value.docs) {
        ds.reference.delete();
      }
    });
  }

  Future<void> deleteCartProduct(String id) async {
    await FirebaseFirestore.instance
        .collection("User")
        .doc(AppUser.phone)
        .collection("Cart")
        .doc(id)
        .delete();
  }

  Future<void> buyAgain(QueryDocumentSnapshot order) async {
    for (var data in order.get("products")) {
      Map<String, dynamic> singleProduct = {
        "brand": data["brand"],
        "category": data["category"],
        "id": data["productId"],
        "imageUrl": data["productImage"],
        "price": data["price"],
        "sellingPrice": data["sellingPrice"],
        "productName": data["productName"],
        "quantity": data["quantity"],
        "variant": data["variant"],
        "size": data["size"],
        "unit": data["unit"],
      };
      await FirebaseFirestore.instance
          .collection("User")
          .doc(AppUser.phone)
          .collection("Cart")
          .where("id", isEqualTo: data["productId"])
          .where("size", isEqualTo: data["unit"])
          .get()
          .then((value) async {
        if (value.docs.length == 1) {
          await FirebaseFirestore.instance
              .collection("User")
              .doc(AppUser.phone)
              .collection("Cart")
              .doc(value.docs[0].id)
              .update({
            "quantity": (int.parse(value.docs[0]["quantity"]) +
                    int.parse(data["quantity"]))
                .toString(),
          });
        } else {
          await FirebaseFirestore.instance
              .collection("User")
              .doc(AppUser.phone)
              .collection("Cart")
              .add(singleProduct);
        }
      });
    }
  }

  Future<void> addToCartOffer({CartModel cart}) async {
    Map<String, dynamic> data = {
      'id': cart.id,
      'brand': cart.brand,
      'category': cart.category,
      'productName': cart.productName,
      'price': cart.price,
      'quantity': cart.quantity,
      'imageUrl': cart.imageUrl,
      'description': cart.description,
      'offerName': cart.offerName,
      'sellingPrice': cart.sp,
    };

    await FirebaseFirestore.instance
        .collection("User")
        .doc(AppUser.phone)
        .collection("CartOffer")
        .where("id", isEqualTo: cart.id)
        .get()
        .then((value) async {
      if (value.docs.length == 1) {
        await FirebaseFirestore.instance
            .collection("User")
            .doc(AppUser.phone)
            .collection("CartOffer")
            .doc(value.docs[0].id)
            .update({
          "quantity":
              (int.parse(value.docs[0]["quantity"]) + int.parse(cart.quantity))
                  .toString(),
        });
      } else {
        await FirebaseFirestore.instance
            .collection("User")
            .doc(AppUser.phone)
            .collection("CartOffer")
            .add(data);
      }
    });
  }

  Future<void> addOfferQuantity({CartModel cart}) async {
    await FirebaseFirestore.instance
        .collection("User")
        .doc(AppUser.phone)
        .collection("CartOffer")
        .doc(cart.id)
        .update({"quantity": cart.quantity});
  }

  Future<void> minusOfferQuantity({CartModel cart}) async {
    if (int.parse(cart.quantity) < 1) {
      await FirebaseFirestore.instance
          .collection("User")
          .doc(AppUser.phone)
          .collection("CartOffer")
          .doc(cart.id)
          .delete();
    } else {
      await FirebaseFirestore.instance
          .collection("User")
          .doc(AppUser.phone)
          .collection("CartOffer")
          .doc(cart.id)
          .update({"quantity": cart.quantity});
    }
  }

  Future<void> deleteCartOffer(String id) async {
    await FirebaseFirestore.instance
        .collection("User")
        .doc(AppUser.phone)
        .collection("CartOffer")
        .doc(id)
        .delete();
  }

  Future<void> clearCartOffer() async {
    await FirebaseFirestore.instance
        .collection("User")
        .doc(AppUser.phone)
        .collection("CartOffer")
        .get()
        .then((value) {
      for (DocumentSnapshot ds in value.docs) {
        ds.reference.delete();
      }
    });
  }

  Future<void> buyOfferAgain(QueryDocumentSnapshot order) async {
    for (var data in order.get("offers")) {
      Map<String, dynamic> singleProduct = {
        "brand": data["brand"],
        "category": data["category"],
        "id": data["productId"],
        "imageUrl": data["productImage"],
        "price": data["price"],
        "sellingPrice": data["sellingPrice"],
        "productName": data["productName"],
        "quantity": data["quantity"],
        "offerName": data["offerName"],
        "description": data["description"],
      };
      await FirebaseFirestore.instance
          .collection("User")
          .doc(AppUser.phone)
          .collection("CartOffer")
          .where("id", isEqualTo: data["productId"])
          .get()
          .then((value) async {
        if (value.docs.length == 1) {
          await FirebaseFirestore.instance
              .collection("User")
              .doc(AppUser.phone)
              .collection("CartOffer")
              .doc(value.docs[0].id)
              .update({
            "quantity": (int.parse(value.docs[0]["quantity"]) +
                    int.parse(data["quantity"]))
                .toString(),
          });
        } else {
          await FirebaseFirestore.instance
              .collection("User")
              .doc(AppUser.phone)
              .collection("CartOffer")
              .add(singleProduct);
        }
      });
    }
  }
}
