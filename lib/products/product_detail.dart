import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toast/toast.dart';

import 'package:grocery/models/cartModel.dart';

class ProductDetail extends StatefulWidget {
  final DocumentSnapshot doc;
  ProductDetail(
    this.doc,
  );
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int a = 1;
  int i, j;

  String selectedsize;
  String mrp = 'Choose Size';
  String sp = '';
  String unit;
  List<String> images = [];
  List<String> size = [];
  List<String> price = [];
  List<String> mprice = [];
  var isInit = true;
  FirebaseFirestore db = FirebaseFirestore.instance;

  void didChangeDependencies() {
    if (isInit) {
      try {
        images = List.from(widget.doc.get('imageUrls'));
        size = List.from(widget.doc.get('size'));
        price = List.from(widget.doc.get('sellingPrice'));
        mprice = List.from(widget.doc.get('mrp'));
        unit = widget.doc.get('unit');
      } catch (e) {}
      setState(() {
        isInit = false;
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return isInit
        ? Center(child: CircularProgressIndicator())
        : AlertDialog(
            title: Container(
              child: Center(
                child: Text(
                  widget.doc.get('brand') + ' ' + widget.doc.get('productName'),
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            content: Card(
              elevation: 10,
              child: Container(
                height: 550,
                width: 270,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(images[0]),
                                fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.black)),
                        padding: EdgeInsets.all(2),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: RichText(
                            text: TextSpan(
                                text: 'Variant:',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: widget.doc.get('variant'),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal),
                                  )
                                ]),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(3),
                        alignment: Alignment.centerLeft,
                        child: DropdownButton(
                          elevation: 15,
                          icon: Icon(Icons.expand_more_rounded),
                          hint: Text(
                            'Choose Size:',
                            style: TextStyle(color: Colors.black),
                          ),
                          value: selectedsize,
                          onChanged: (newValue) {
                            for (i = 0; i < size.length; i++) {
                              if (size[i] == newValue) {
                                j = i;
                                setState(() {
                                  mrp = mprice[j];
                                  sp = price[j];
                                  selectedsize = newValue;
                                });
                              }
                            }
                          },
                          items: size.map((size) {
                            return DropdownMenuItem(
                              child: new Text(
                                'Size: ' + size + ' ' + unit,
                                style: TextStyle(color: Colors.black),
                              ),
                              value: size,
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 10),
                      Column(
                        children: [
                          Container(
                              margin: const EdgeInsets.all(5),
                              alignment: Alignment.centerLeft,
                              child: Text('Price List:',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))),
                          Container(
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(2),
                            height: 100,
                            width: 210,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: size.length,
                                itemBuilder: (ctx, index) {
                                  return Container(
                                      child: Row(
                                    children: [
                                      Text(size[index] +
                                          " " +
                                          widget.doc.get('unit') +
                                          ' = '),
                                      Text(
                                        '\u{20B9}' + mprice[index],
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.red),
                                      ),
                                      Text(
                                        " \u{20B9}" + price[index],
                                      ),
                                    ],
                                  ));
                                }),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        margin: const EdgeInsets.all(5),
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                              text: 'Price:',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                                TextSpan(
                                  text: selectedsize != null
                                      ? ' \u{20B9}' + mrp
                                      : mrp,
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      decoration: selectedsize != null
                                          ? TextDecoration.lineThrough
                                          : null),
                                ),
                                TextSpan(
                                    text: " \u{20B9}" + sp,
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                      fontSize: 18,
                                    )),
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 7,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Text(
                            "Qty:",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          height: 28,
                          width: 28,
                          child: FloatingActionButton(
                              child: Icon(Icons.remove),
                              onPressed: () {
                                if (a > 1) {
                                  setState(() {
                                    a--;
                                  });
                                }
                              }),
                        ),
                        Text(
                          a.toString(),
                          style: TextStyle(fontSize: 17),
                        ),
                        Container(
                          height: 28,
                          width: 28,
                          child: FloatingActionButton(
                              child: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  a++;
                                });
                              }),
                        ),
                        Container(
                            child: RaisedButton(
                                color: Colors.white,
                                elevation: 7,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.black)),
                                child: Text(
                                  'Add To Cart',
                                  style: TextStyle(color: Colors.black),
                                ),
                                onPressed: () async {
                                  if (selectedsize == null) {
                                    Toast.show('Choose size', context);
                                  } else if (a <= 0) {
                                    Toast.show('Choose Quantity', context);
                                  } else if (selectedsize != null && a > 0) {
                                    await CartModel()
                                        .addToCart(
                                            cart: CartModel(
                                      id: widget.doc.id,
                                      brand: widget.doc.get("brand"),
                                      category: widget.doc.get("category"),
                                      productName:
                                          widget.doc.get("productName"),
                                      imageUrl: widget.doc.get("imageUrls")[0],
                                      price: mrp,
                                      sp: sp,
                                      quantity: a.toString(),
                                      variant: widget.doc.get("variant"),
                                      unit: widget.doc.get('unit'),
                                      size: selectedsize,
                                    ))
                                        .then((value) {
                                      Toast.show("Added to cart", context,
                                          duration: Toast.LENGTH_SHORT,
                                          gravity: Toast.BOTTOM);
                                    });
                                    Navigator.of(context).pop();
                                  }
                                })),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
