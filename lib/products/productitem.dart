import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'product_detail.dart';

class ProductItem extends StatefulWidget {
  final QueryDocumentSnapshot doc;
  ProductItem(this.doc);
  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15,left: 15,right: 15,),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GridTile(
          child: GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return ProductDetail(widget.doc);
                  });
            },
            child: Image.network(
              widget.doc.get('imageUrls')[0],
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
              title: Text(
                widget.doc['brand'] + ' ' + widget.doc.get('productName'),
                textAlign: TextAlign.center,
              ),
              subtitle: Text(widget.doc['category']),
            ),
          ),
        ),
    );
  }
}
