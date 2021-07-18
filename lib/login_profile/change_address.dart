import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:grocery/models/userModel.dart';

class ChangeAddress extends StatefulWidget {
  @override
  _ChangeAddressState createState() => _ChangeAddressState();
}

class _ChangeAddressState extends State<ChangeAddress> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  var doornoController = TextEditingController();
  var streetController = TextEditingController();
  var cityController = TextEditingController();
  var pincodeController = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    doornoController.dispose();
    streetController.dispose();
    cityController.dispose();
    pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Change Address"),
      content: Container(
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: doornoController,
                  autovalidateMode: AutovalidateMode.always,
                  decoration: InputDecoration(
                    labelText: "Door No:",
                    icon: Icon(Icons.home
                        //color: mFieldIcon,
                        ),
                  ),
                  validator: (val) {
                    if (val.trim().isEmpty) return "Enter Door No";
                    return null;
                  },
                ),
                TextFormField(
                  controller: streetController,
                  autovalidateMode: AutovalidateMode.always,
                  // keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Street Name",
                    icon: Icon(
                      Icons.add_road,
                      //color: mFieldIcon,
                    ),
                  ),
                  validator: (val) {
                    if (val.trim().isEmpty) return "Enter Street Name";
                    return null;
                  },
                ),
                TextFormField(
                  controller: cityController,
                  autovalidateMode: AutovalidateMode.always,
                  decoration: InputDecoration(
                    labelText: "City",
                    icon: Icon(
                      Icons.location_city,
                      //color: mFieldIcon,
                    ),
                  ),
                  validator: (val) {
                    if (val.trim().isEmpty) return "Enter City Name";
                    return null;
                  },
                ),
                TextFormField(
                  controller: pincodeController,
                  autovalidateMode: AutovalidateMode.always,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Pincode",
                    icon: Icon(
                      Icons.add_location,
                      //color: mFieldIcon,
                    ),
                  ),
                  validator: (val) {
                    if (val.trim().isEmpty) return "Enter Pincode";
                    try {
                      int.parse(val.trim());
                    } catch (e) {
                      return "Enter a valid input";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        FlatButton.icon(
          //color: mPrimaryColor,
          icon: Icon(Icons.save),
          label: Text("Save"),
          onPressed: () async {
            Toast.show('Address Updated', context);
            await AppUser().updateAddress(
                doorNo: doornoController.text,
                streetName: streetController.text,
                cityName: cityController.text,
                pincode: pincodeController.text);
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
