import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery/constants.dart';
import 'add_product_screen.dart';

class ProductListScreen extends StatefulWidget {
  static const routeName = "/product_list_screen";
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  CollectionReference productSnapshot =
      FirebaseFirestore.instance.collection("Products");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Product List"),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        )),
      ),
      body: Stack(
        children: [
          StreamBuilder(
              stream: productSnapshot.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final products = snapshot.data.docs;

                return products.length > 0
                    ? ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onLongPress: () {
                              Navigator.of(context).pushNamed(
                                  AddProductScreen.routeName,
                                  arguments: {
                                    "id": products[index].id,
                                    "product": products[index],
                                    "edit": 1
                                  });
                            },
                            onTap: () async {
                              // await ProductModel().deleteProduct(
                              //   id: products[index].id,
                              // );
                            },
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      products[index]['imageUrls'][0]),
                                  radius: 20,
                                ),
                                title: Text(products[index]['brand']),
                                subtitle: Text(products[index]['productName']),
                                trailing: Text(products[index]['category']),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text("Add products"),
                      );
              }),
          Positioned(
            bottom: 15,
            right: 15,
            child: FloatingActionButton(
              backgroundColor: kPrimaryColor,
              elevation: 10,
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(AddProductScreen.routeName,
                    arguments: {"edit": 0});
              },
            ),
          ),
        ],
      ),
    );
  }
}
