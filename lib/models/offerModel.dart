import 'package:cloud_firestore/cloud_firestore.dart';

class OfferModel {
  String category;
  String brand;
  String productName;
  String offerName;
  List<String> imageUrl;
  String description;
  String sellingPrice;
  String mrp;

  OfferModel({
    this.brand,
    this.category,
    this.productName,
    this.offerName,
    this.imageUrl,
    this.description,
    this.sellingPrice,
    this.mrp,
  });

  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> addOffer(OfferModel offer) async {
    Map<String, dynamic> data = {
      'category': offer.category,
      'brand': offer.brand,
      'productName': offer.productName,
      'offerName': offer.offerName,
      'imageUrls': offer.imageUrl,
      'description': offer.description,
      'sellingPrice': offer.sellingPrice,
      'mrp': offer.mrp,
    };

    await db.collection("Offers").add(data);
  }

  Future<void> updateOffer(String id, OfferModel editedOffer) async {
    Map<String, dynamic> data = {
      'category': editedOffer.category,
      'brand': editedOffer.brand,
      'productName': editedOffer.productName,
      'offerName': editedOffer.offerName,
      'imageUrls': editedOffer.imageUrl,
      'description': editedOffer.description,
      'sellingPrice': editedOffer.sellingPrice,
      'mrp': editedOffer.mrp,
    };

    await db.collection("Offers").doc(id).update(data);
  }

  Future<void> deleteOffer({String id}) async {
    await db.collection("Offers").doc(id).delete();
  }
}
