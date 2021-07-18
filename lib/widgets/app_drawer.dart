import 'package:flutter/material.dart';
import 'package:grocery/login_profile/user_profile.dart';
import 'package:grocery/orders/my_orders.dart';

import '../models/userModel.dart';
import '../screens/main_screen.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool homeColor = true;
  bool ordersColor = false;
  bool profileColor = false;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            accountName: RichText(
              text: TextSpan(
                  text: AppUser.name[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: AppUser.name.substring(1),
                    ),
                  ]),
            ),
            accountEmail: Text(AppUser.phone),
            currentAccountPicture: CircleAvatar(
              backgroundColor:Colors.lime,
              child: Text(
                AppUser.name[0].toUpperCase(),
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
          ListTile(
            selected: homeColor,
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              setState(() {
                homeColor = true;
                ordersColor = false;
                profileColor = false;
              });
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(MainScreen.routeName);
            },
          ),
          Divider(color: Colors.grey,),
          ListTile(
            selected: ordersColor,
            leading: Icon(Icons.add_to_queue),
            title: Text('My Orders'),
            onTap: () {
              setState(() {
                homeColor = false;
                ordersColor = true;
                profileColor = false;
              });
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(MyOrders.routeName);
            },
          ),
          Divider(color: Colors.grey,),
          ListTile(
            selected: profileColor,
            leading: Icon(Icons.settings),
            title: Text('Profile'),
            onTap: () {
              setState(() {
                homeColor = false;
                ordersColor = false;
                profileColor = true;
              });
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(UserProfile.routeName);
            },
          ),
          Divider(color: Colors.grey,),
        ],
      ),
    );
  }
}
