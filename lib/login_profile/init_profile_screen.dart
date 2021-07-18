import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:grocery/models/userModel.dart';

class InitProfileScreen extends StatefulWidget {
  static const routeName = '/profile-init';

  @override
  _InitProfileScreenState createState() => _InitProfileScreenState();
}

class _InitProfileScreenState extends State<InitProfileScreen> {
  DateTime selectedDate;
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final doorController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final pincodeController = TextEditingController();
  final nameFocusNode = FocusNode();
  final doorFocusNode = FocusNode();
  final streetFocusNode = FocusNode();
  final cityFocusNode = FocusNode();
  final pincodeFocusNode = FocusNode();
  bool isLoading = false;

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseMessaging fbm = FirebaseMessaging.instance;

  @override
  void dispose() {
    nameController.dispose();
    dobController.dispose();
    doorController.dispose();
    streetController.dispose();
    cityController.dispose();
    pincodeController.dispose();
    nameFocusNode.dispose();
    doorFocusNode.dispose();
    streetFocusNode.dispose();
    cityFocusNode.dispose();
    pincodeFocusNode.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "Profile",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: size.width * 1 / 5,
                              horizontal: size.width * 1 / 20),
                          child: Form(
                            key: _formKey,
                            child: Card(
                              elevation: 15,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: nameController,
                                      focusNode: nameFocusNode,
                                      onFieldSubmitted: (value) {
                                        doorFocusNode.requestFocus();
                                      },
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.name,
                                      autovalidate: true,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.person),
                                        hintText: 'What do people call you?',
                                        border: OutlineInputBorder(),
                                        labelText: 'Name *',
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    TextFormField(
                                      controller: doorController,
                                      focusNode: doorFocusNode,
                                      onFieldSubmitted: (value) {
                                        streetFocusNode.requestFocus();
                                      },
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.streetAddress,
                                      autovalidate: true,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter some text';
                                        }

                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.my_location),
                                        labelText: 'Address Line 1',
                                        hintText: "doorNo,areaName",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    TextFormField(
                                      controller: streetController,
                                      focusNode: streetFocusNode,
                                      onFieldSubmitted: (value) {
                                        cityFocusNode.requestFocus();
                                      },
                                      autovalidate: true,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.streetAddress,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter some text';
                                        }

                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.my_location),
                                        labelText: 'Address Line 2',
                                        hintText: "streetName",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    TextFormField(
                                      controller: cityController,
                                      autovalidate: true,
                                      focusNode: cityFocusNode,
                                      onFieldSubmitted: (value) {
                                        pincodeFocusNode.requestFocus();
                                      },
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.streetAddress,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter some text';
                                        }

                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.my_location),
                                        labelText: 'City Name',
                                        hintText: "cityName",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    TextFormField(
                                      controller: pincodeController,
                                      focusNode: pincodeFocusNode,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                      autovalidate: true,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter some text';
                                        }

                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.my_location),
                                        labelText: 'PinCode',
                                        hintText: "Eg:641011",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    TextFormField(
                                      controller: dobController,
                                      autovalidate: true,
                                      onTap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1965),
                                          lastDate: DateTime.now(),
                                        ).then((value) {
                                          if (value == null) return;
                                          setState(() {
                                            selectedDate = value;
                                            dobController.text = selectedDate
                                                .toString()
                                                .substring(0, 10);
                                          });
                                        });
                                      },
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.date_range),
                                        labelText: 'Date of birth *',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: isLoading
          ? null
          : FloatingActionButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  setState(() {
                    isLoading = true;
                  });
                  String fcmToken = await fbm.getToken();
                  AppUser.update(
                    name: nameController.text,
                    dob: selectedDate,
                    doorNo: doorController.text,
                    streetName: streetController.text,
                    cityName: cityController.text,
                    pincode: pincodeController.text,
                    isLoggedIn: true,
                    fcmToken: fcmToken,
                    userType: 0,
                  );

                  db
                      .collection("User")
                      .doc(AppUser.phone)
                      .set(AppUser().getMap)
                      .then((value) =>
                          Navigator.of(context).pushReplacementNamed("/"))
                      .catchError((error) {
                    print(error);
                  });
                }
              },
              child: Icon(Icons.navigate_next),
            ),
    );
  }
}
