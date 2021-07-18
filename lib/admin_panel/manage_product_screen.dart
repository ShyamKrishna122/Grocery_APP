import 'package:flutter/material.dart';

import 'offer_list_screen.dart';
import 'product_list_screen.dart';

class ManageProductScreen extends StatefulWidget {
  static const routeName = "/manage_product_screen";
  @override
  _ManageProductScreenState createState() => _ManageProductScreenState();
}

class _ManageProductScreenState extends State<ManageProductScreen> {
  var categoryController = TextEditingController();
  
  @override
  void initState() {
    categoryController.text = null;
    super.initState();
  }

  @override
  void dispose() {
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.change_history),
          title: Text("Products list"),
          onTap: () {
            Navigator.of(context).pushNamed(ProductListScreen.routeName);
          },
        ),
        Divider(color: Colors.grey,),
        ListTile(
          leading: Icon(Icons.local_offer),
          title: Text("Offers list"),
          onTap: () {
            Navigator.of(context).pushNamed(OfferListScreen.routeName);
          },
        ),
        Divider(color: Colors.grey,),
      ],
    );
  }
}
