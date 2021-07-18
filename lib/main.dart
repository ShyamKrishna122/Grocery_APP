import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:grocery/admin_panel/add_offer_screen.dart';
import 'package:grocery/admin_panel/add_product_screen.dart';
import 'package:grocery/admin_panel/admin_order_detail_screen.dart';
import 'package:grocery/admin_panel/admin_panel_screen.dart';
import 'package:grocery/admin_panel/manage_product_screen.dart';
import 'package:grocery/admin_panel/offer_list_screen.dart';
import 'package:grocery/admin_panel/order_list_screen.dart';
import 'package:grocery/admin_panel/product_list_screen.dart';

import 'package:grocery/cart/cart_screen.dart';
import 'package:grocery/constants.dart';

import 'package:grocery/login_profile/init_profile_screen.dart';
import 'package:grocery/login_profile/user_profile.dart';

import 'package:grocery/offers/offer_alone_products.dart';

import 'package:grocery/orders/my_orders.dart';
import 'package:grocery/orders/order_detail_screen.dart';

import 'package:grocery/products/single_product.dart';

import 'package:grocery/screens/main_screen.dart';
import 'package:grocery/screens/splash_screen.dart';

import 'package:grocery/categories/category_products.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: kPrimaryColor,
        statusBarBrightness: Brightness.dark,
      ),
      child: MaterialApp(
        title: 'Grocery',
        theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          primaryColor: kPrimaryColor,
          textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        routes: {
          MainScreen.routeName: (ctx) => MainScreen(),
          InitProfileScreen.routeName: (ctx) => InitProfileScreen(),
          AdminPanelScreen.routeName: (ctx) => AdminPanelScreen(),
          ManageProductScreen.routeName: (ctx) => ManageProductScreen(),
          AddProductScreen.routeName: (ctx) => AddProductScreen(),
          ProductListScreen.routeName: (ctx) => ProductListScreen(),
          OfferListScreen.routeName: (ctx) => OfferListScreen(),
          AddOfferScreen.routeName: (ctx) => AddOfferScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrderListScreen.routeName: (ctx) => OrderListScreen(),
          MyOrders.routeName: (ctx) => MyOrders(),
          OrderDetailScreen.routeName: (ctx) => OrderDetailScreen(),
          AdminOrderDetailScreen.routeName: (ctx) => AdminOrderDetailScreen(),
          ProductsCategory.routeName: (ctx) => ProductsCategory(),
          OfferAloneProducts.routeName: (ctx) => OfferAloneProducts(),
          SingleProduct.routeName: (ctx) => SingleProduct(),
          UserProfile.routeName: (ctx) => UserProfile(),
        },
      ),
    );
  }
}
