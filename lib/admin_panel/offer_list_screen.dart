import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery/constants.dart';

import 'add_offer_screen.dart';

class OfferListScreen extends StatefulWidget {
  static const routeName = "/offer_list_screen";
  @override
  _OfferListScreenState createState() => _OfferListScreenState();
}

class _OfferListScreenState extends State<OfferListScreen> {
  CollectionReference offerSnapshot =
      FirebaseFirestore.instance.collection("Offers");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Offers List"),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        )),
      ),
      body: Stack(
        children: [
          StreamBuilder(
              stream: offerSnapshot.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final offers = snapshot.data.docs;

                return offers.length > 0
                    ? ListView.builder(
                        itemCount: offers.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onLongPress: () {
                              Navigator.of(context).pushNamed(
                                  AddOfferScreen.routeName,
                                  arguments: {
                                    "id": offers[index].id,
                                    "offer": offers[index],
                                    "edit": 1
                                  });
                            },
                            onTap: () async {
                              // await OfferModel().deleteOffer(
                              //   id: offers[index].id,
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
                                      offers[index]['imageUrls'][0]),
                                  radius: 20,
                                ),
                                title: Text(offers[index]['offerName']),
                                subtitle: Text(offers[index]['description']),
                                trailing: Text("Rs.${offers[index]['mrp']}"),
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
                Navigator.of(context).pushNamed(AddOfferScreen.routeName,
                    arguments: {"edit": 0});
              },
            ),
          ),
        ],
      ),
    );
  }
}
