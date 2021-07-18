import 'package:flutter/material.dart';
import 'package:grocery/constants.dart';

import 'category_products.dart';

class CategoriesView extends StatefulWidget {
  final int b;
  final List<String> categories;
  CategoriesView(this.categories, this.b);
  @override
  _CategoriesViewState createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  List<String> images = [
    "assets/icons/bakery.png",
    "assets/icons/baking goods.png",
    "assets/icons/beverage.png",
    "assets/icons/cleaners.png",
    "assets/icons/dairy.png",
    "assets/icons/frozen foods.png",
    "assets/icons/other.png",
    "assets/icons/paper goods.png",
    "assets/icons/cosmetics.png",
    "assets/icons/produce.png",
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 15, left: 10, bottom: 15),
            child: Text(
              "Categories",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 5, right: 5),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              ProductsCategory.routeName,
                              arguments: {
                                "category": widget.categories[index]
                              });
                        },
                        child: CircleAvatar(
                          maxRadius: 30,
                          backgroundColor: kPrimaryColor,
                          child: CircleAvatar(
                            maxRadius: 25,
                            backgroundColor: Colors.white12,
                            child: Image(
                              image: AssetImage(images[index]),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 2, right: 3),
                        child: Text(widget.categories[index])),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
