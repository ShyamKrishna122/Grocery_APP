import 'package:flutter/material.dart';

import 'dashBoard_screen.dart';
import 'manage_product_screen.dart';

class AdminPanelScreen extends StatefulWidget {
  static const routeName = "/admin_panel_screen";
  @override
  _AdminPanelScreenState createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Admin Panel"),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.dashboard),
                text: "Dashboard",
              ),
              Tab(
                icon: Icon(Icons.sort),
                text: "Manage",
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          DashBoardScreen(),
          ManageProductScreen(),
        ]),
      ),
    );
  }
}
