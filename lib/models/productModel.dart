import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String category;
  String brand;
  String productName;
  List<String> imageUrl;
  String variant;
  String unit;
  List<String> sellingPrice;
  List<String> mrp;
  List<String> size;

  ProductModel({
    this.category,
    this.brand,
    this.productName,
    this.imageUrl,
    this.variant,
    this.unit,
    this.sellingPrice,
    this.mrp,
    this.size,
  });

  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> addProduct(ProductModel product) async {
    Map<String, dynamic> data = {
      'category': product.category,
      'brand': product.brand,
      'productName': product.productName,
      'imageUrls': product.imageUrl,
      'variant': product.variant,
      'mrp': product.mrp,
      'sellingPrice': product.sellingPrice,
      'size': product.size,
      'unit': product.unit,
    };
    await db.collection("Products").add(data);
  }

  Future<void> updateProduct(String id, ProductModel editedProduct) async {
    Map<String, dynamic> data = {
      'category': editedProduct.category,
      'brand': editedProduct.brand,
      'productName': editedProduct.productName,
      'imageUrls': editedProduct.imageUrl,
      'variant': editedProduct.variant,
      'mrp': editedProduct.mrp,
      'sellingPrice': editedProduct.sellingPrice,
      'size': editedProduct.size,
      'unit': editedProduct.unit,
    };

    await db.collection("Products").doc(id).update(data);
  }

  Future<void> deleteProduct({String id}) async {
    await db.collection("Products").doc(id).delete();
  }
}
