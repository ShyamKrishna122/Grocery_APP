import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery/constants.dart';

import 'package:grocery/login_profile/change_address.dart';
import 'package:grocery/models/userModel.dart';

class UserProfile extends StatefulWidget {
  static const routeName = "/userProfile";
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String door;
  String street;
  String city;
  String pin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            "User Profile",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        body: StreamBuilder(
            stream: db.collection("User").doc(AppUser.phone).snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Something went wrong"),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              door = snapshot.data["doorNo"];
              street = snapshot.data["streetName"];
              city = snapshot.data["cityName"];
              pin = snapshot.data["pincode"];
              return Stack(
                children: [
                  Container(
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 10.0,
                    color: Colors.white,
                    margin: EdgeInsets.only(
                        top: 30, bottom: 30, left: 30, right: 30),
                    child: Container(
                      margin: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                              hintText: AppUser.name,
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            enabled: true,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.call),
                              border: OutlineInputBorder(),
                              hintText: AppUser.phone,
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            enabled: true,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.home),
                              border: OutlineInputBorder(),
                              hintText: door,
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            enabled: true,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.add_road),
                              border: OutlineInputBorder(),
                              hintText: street,
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            enabled: true,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.location_city),
                              border: OutlineInputBorder(),
                              hintText: city,
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            enabled: true,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.location_history),
                              border: OutlineInputBorder(),
                              hintText: "Tamil Nadu",
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            enabled: true,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.pin_drop),
                              border: OutlineInputBorder(),
                              hintText: pin,
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            enabled: true,
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          RaisedButton.icon(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return ChangeAddress();
                                    });
                              },
                              icon: Icon(Icons.edit),
                              label: Text("Edit")),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }));
  }
}
