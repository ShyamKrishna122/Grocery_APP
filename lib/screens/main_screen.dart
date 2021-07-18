import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery/admin_panel/admin_panel_screen.dart';
import 'package:grocery/cart/cart_button.dart';
import 'package:grocery/categories/categories.dart';
import 'package:grocery/login_profile/init_profile_screen.dart';
import 'package:grocery/models/userModel.dart';
import 'package:grocery/offers/offers_view.dart';
import 'package:grocery/products/feature_product.dart';
import 'package:grocery/widgets/app_drawer.dart';
import 'package:grocery/widgets/search_products.dart';

class MainScreen extends StatefulWidget {
  static const routeName = "/mainScreen";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _isLoading = false;
  var _isInit = true;
  List<String> categories = [];
  int len;
  int b;
  double a;
  DocumentSnapshot cat;

  AppUser appUser = AppUser();

  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      FirebaseFirestore.instance
          .collection("Categories")
          .doc("Categories")
          .get()
          .then((value) {
        final cate = value.data();
        len = cate.length;
        for (var data in cate.keys.toList()) {
          categories.add(data);
        }
        categories.sort();
      });
      setState(() {
        _isLoading = true;
      });
      if (await appUser.getInfoFromDb) {
        if (!AppUser.isLoggedIn) {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        Navigator.of(context).pushReplacementNamed(InitProfileScreen.routeName);
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return AppUser.userType == 0
        ? Scaffold(
            key: key,
            appBar: _isLoading
                ? null
                : AppBar(
                    elevation: 5.0,
                    centerTitle: true,
                    title: Text(
                      "AKKK Grocery",
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    leading: IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        key.currentState.openDrawer();
                      },
                    ),
                    actions: [
                      IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            showSearch(context: context, delegate: Search());
                          }),
                      CartButton(),
                    ],
                  ),
            drawer: AppDrawer(),
            body: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        CategoriesView(categories, b),
                        OffersView(),
                        FeatureProduct(),
                      ],
                    ),
                  ))
        : Scaffold(
            body: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : AdminPanelScreen());
  }
}
