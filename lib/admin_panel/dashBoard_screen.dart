import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:grocery/admin_panel/order_list_screen.dart';

class DashBoardScreen extends StatefulWidget {
  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  CollectionReference userSnapshot =
      FirebaseFirestore.instance.collection("User");

  CollectionReference categorySnapshot =
      FirebaseFirestore.instance.collection("Categories");

  CollectionReference productSnapshot =
      FirebaseFirestore.instance.collection("Products");

  CollectionReference offerSnapshot =
      FirebaseFirestore.instance.collection("Offers");

  CollectionReference orderSnapshot =
      FirebaseFirestore.instance.collection("Orders");

  CollectionReference revenueSnapshot =
      FirebaseFirestore.instance.collection("Revenue");

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          subtitle: StreamBuilder(
            stream: revenueSnapshot.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              final revenue = snapshot.data.docs.length;
              var totalRevenue;

              if (revenue == 1) {
                totalRevenue = snapshot.data.docs[0];
              }
              return revenue == 1
                  ? Text("\u{20B9} ${totalRevenue.data()["revenue"]}",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30.0, color: Colors.green))
                  : Center(child: Text("No Orders Sold"));
            },
          ),
          title: Text(
            'Revenue',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24.0, color: Colors.grey),
          ),
        ),
        Expanded(
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Card(
                  elevation: 5,
                  child: ListTile(
                    title: FlatButton.icon(
                        onPressed: null,
                        icon: Icon(Icons.people_outline),
                        label: Text("Users")),
                    subtitle: StreamBuilder(
                      stream: userSnapshot
                          .where("userType", isEqualTo: 0)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        final user = snapshot.data.docs;

                        return Text(
                          user.length.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.green, fontSize: 60.0),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Card(
                  elevation: 5,
                  child: ListTile(
                    title: FlatButton.icon(
                        onPressed: null,
                        icon: Icon(Icons.category),
                        label: Text("Category")),
                    subtitle:
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: categorySnapshot.doc("Categories").snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        final category = snapshot.data.data().keys.length;

                        return Text(
                          category.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.green, fontSize: 60.0),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Card(
                  elevation: 5,
                  child: ListTile(
                    title: FlatButton.icon(
                        onPressed: null,
                        icon: Icon(Icons.track_changes),
                        label: Text("Products")),
                    subtitle: StreamBuilder(
                      stream: productSnapshot.snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        final products = snapshot.data.docs;

                        return Text(
                          products.length.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.green, fontSize: 60.0),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Card(
                  elevation: 5,
                  child: ListTile(
                    title: FlatButton.icon(
                        onPressed: null,
                        icon: Icon(Icons.local_offer),
                        label: Text("Offers")),
                    subtitle: StreamBuilder(
                      stream: offerSnapshot.snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        final offers = snapshot.data.docs;

                        return Text(
                          offers.length.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.green, fontSize: 60.0),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Card(
                  elevation: 5,
                  child: StreamBuilder(
                      stream: orderSnapshot
                          .orderBy(
                            "fulFilled",
                          )
                          .orderBy("orderDate")
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        final orders = snapshot.data.docs;

                        return ListTile(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              OrderListScreen.routeName,
                            );
                          },
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.shopping_cart),
                              label: Text("Orders")),
                          subtitle: Text(
                            orders.length.toString(),
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.green, fontSize: 60.0),
                          ),
                        );
                      }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Card(
                  elevation: 5,
                  child: ListTile(
                    title: FlatButton.icon(
                        onPressed: null,
                        icon: Icon(Icons.tag_faces),
                        label: Text("Sold")),
                    subtitle: StreamBuilder(
                      stream: orderSnapshot
                          .where("fulFilled", isEqualTo: 1)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        final orders = snapshot.data.docs;
                        return Text(
                          orders.length.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.green, fontSize: 60.0),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
