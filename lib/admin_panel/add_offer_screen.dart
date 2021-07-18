import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';

import 'package:grocery/models/offerModel.dart';
import 'package:grocery/models/userModel.dart';

class AddOfferScreen extends StatefulWidget {
  static const routeName = "/add_offer_screen";
  @override
  _AddOfferScreenState createState() => _AddOfferScreenState();
}

class _AddOfferScreenState extends State<AddOfferScreen> {
  List<Asset> images = List<Asset>();
  final _form = GlobalKey<FormState>();
  List<String> imageUrls = <String>[];
  FirebaseFirestore db = FirebaseFirestore.instance;
  var isLoading = false;
  List<String> categories = [];
  String _selectedCategory;

  var brandEditingController = TextEditingController();
  var productNameEditingController = TextEditingController();
  var offerNameEditingController = TextEditingController();
  var descriptionEditingController = TextEditingController();
  var spEditingController = TextEditingController();
  var mrpEditingController = TextEditingController();

  var categoryFocusNode = FocusNode();
  var brandFocusNode = FocusNode();
  var productNameFocusNode = FocusNode();
  var offerNameFocusNode = FocusNode();
  var descriptionFocusNode = FocusNode();
  var spFocusNode = FocusNode();
  var mrpFocusNode = FocusNode();

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      final value =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      final edit = value["edit"];
      if (edit == 1) {
        final QueryDocumentSnapshot product = value["offer"];
        _selectedCategory = product["category"];
        brandEditingController.text = product["brand"];
        productNameEditingController.text = product["productName"];
        offerNameEditingController.text = product["offerName"];
        descriptionEditingController.text = product["description"];
        mrpEditingController.text = product["mrp"];
        spEditingController.text = product["sellingPrice"];
      }
    });
    super.initState();
  }

  DocumentSnapshot cat;

  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      FirebaseFirestore.instance
          .collection("Categories")
          .doc("Categories")
          .get()
          .then((value) {
        final cate = value.data();

        for (var data in cate.keys.toList()) {
          categories.add(data);
        }
        categories.sort();
        setState(() {});
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    brandEditingController.clear();
    productNameEditingController.clear();
    brandFocusNode.dispose();
    productNameFocusNode.dispose();
    categoryFocusNode.dispose();
    offerNameEditingController.clear();
    descriptionEditingController.clear();
    spEditingController.clear();
    mrpEditingController.clear();
    offerNameFocusNode.dispose();
    descriptionFocusNode.dispose();
    spFocusNode.dispose();
    mrpFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    final value =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    final edit = value["edit"];

    if (!isValid) {
      return;
    } else {
      if (images.length > 0) {
        setState(() {
          isLoading = true;
        });
        _form.currentState.save();
        await uploadImages();
        try {
          if (edit == 1) {
            final id = value["id"];
            await OfferModel().updateOffer(
                id,
                OfferModel(
                  category: _selectedCategory,
                  brand: brandEditingController.text,
                  productName: productNameEditingController.text,
                  offerName: offerNameEditingController.text,
                  imageUrl: imageUrls,
                  description: descriptionEditingController.text,
                  sellingPrice: spEditingController.text,
                  mrp: mrpEditingController.text,
                ));
          } else {
            await OfferModel().addOffer(OfferModel(
              category: _selectedCategory,
              brand: brandEditingController.text,
              productName: productNameEditingController.text,
              offerName: offerNameEditingController.text,
              imageUrl: imageUrls,
              description: descriptionEditingController.text,
              sellingPrice: spEditingController.text,
              mrp: mrpEditingController.text,
            ));
          }
          Navigator.of(context).pop();
        } catch (e) {
          await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text("An error occurred!"),
                    content: Text("Something Went Wrong!!"),
                    actions: [
                      FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text("Okay"),
                      )
                    ],
                  ));
        }
        setState(() {
          isLoading = false;
        });
      } else {
        Toast.show('Please add some photos', context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    }
  }

  Future<bool> _onBackPressed() async {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Do you want to exit"),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("NO"),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text("yes"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final value =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final edit = value["edit"];
    return Scaffold(
      appBar: AppBar(
        title: edit == 0 ? Text("Add Offer") : Text("Update Offer"),
      ),
      body: isLoading
          ? Center(
              child: Container(
                height: 200,
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 30,
                    ),
                    Text("Your offer is being uploaded..Please wait.")
                  ],
                ),
              ),
            )
          : WillPopScope(
              onWillPop: _onBackPressed,
              child: SingleChildScrollView(
                child: Container(
                  child: Form(
                    key: _form,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(15),
                          //width: 110,
                          padding: EdgeInsets.only(top: 11),
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              hintText: "Select Category*",
                            ),
                            items: categories
                                .map(
                                  (value) => DropdownMenuItem(
                                    child: Text(value),
                                    value: value,
                                  ),
                                )
                                .toList(),
                            onChanged: (category) {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                            value: _selectedCategory,
                            validator: (value) {
                              if (value.trim().length == 0) {
                                return "select something";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          margin: const EdgeInsets.all(15),
                          child: TextFormField(
                            autovalidateMode: AutovalidateMode.always,
                            controller: brandEditingController,
                            decoration: InputDecoration(
                                hintText: "Enter Brand Name",
                                labelText: "Brand Name"),
                            focusNode: brandFocusNode,
                            onFieldSubmitted: (value) {
                              productNameFocusNode.requestFocus();
                            },
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value.trim().length == 0) {
                                return "Type something";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          margin: const EdgeInsets.all(15),
                          child: TextFormField(
                            autovalidateMode: AutovalidateMode.always,
                            controller: productNameEditingController,
                            decoration: InputDecoration(
                                hintText: "Enter Product Name",
                                labelText: "Product Name"),
                            focusNode: productNameFocusNode,
                            onFieldSubmitted: (value) {
                              offerNameFocusNode.requestFocus();
                            },
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value.trim().length == 0) {
                                return "Type something";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          margin: const EdgeInsets.all(15),
                          child: TextFormField(
                            autovalidateMode: AutovalidateMode.always,
                            controller: offerNameEditingController,
                            decoration: InputDecoration(
                                hintText: "Enter Offer Name",
                                labelText: "Offer Name"),
                            focusNode: offerNameFocusNode,
                            onFieldSubmitted: (value) {
                              descriptionFocusNode.requestFocus();
                            },
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value.trim().length == 0) {
                                return "Type something";
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(15),
                          child: TextFormField(
                            autovalidateMode: AutovalidateMode.always,
                            controller: descriptionEditingController,
                            decoration: InputDecoration(
                                hintText: "Enter description about offer",
                                labelText: "description"),
                            focusNode: descriptionFocusNode,
                            maxLines: 5,
                            keyboardType: TextInputType.multiline,
                            validator: (value) {
                              if (value.trim().length == 0) {
                                return "Type something";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          margin: const EdgeInsets.all(15),
                          child: TextFormField(
                            autovalidateMode: AutovalidateMode.always,
                            controller: mrpEditingController,
                            decoration: InputDecoration(
                                hintText: "Enter mrp", labelText: "MRP"),
                            focusNode: mrpFocusNode,
                            onFieldSubmitted: (value) {
                              spFocusNode.requestFocus();
                            },
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value.trim().length == 0) {
                                return "Type something";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          margin: const EdgeInsets.all(15),
                          child: TextFormField(
                            autovalidateMode: AutovalidateMode.always,
                            controller: spEditingController,
                            decoration: InputDecoration(
                                hintText: "Enter Selling Price",
                                labelText: "Selling Price"),
                            focusNode: spFocusNode,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value.trim().length == 0) {
                                return "Type something";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width * 3 / 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              FlatButton(
                                color: Colors.black12,
                                child: Text("Pick images"),
                                textColor: Theme.of(context).accentColor,
                                onPressed: () {
                                  _checkPermission().then((granted) {
                                    if (!granted) return;
                                    loadAssets();
                                  });
                                },
                              ),
                              Expanded(
                                child: buildGridView(),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: isLoading
          ? null
          : FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                if (!isLoading) _saveForm();
              },
              child: Icon(Icons.save),
            ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          children: [
            Container(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _checkPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    return statuses[Permission.storage] == PermissionStatus.granted;
  }

  Widget buildGridView() {
    return images.length == 0
        ? GestureDetector(
            onTap: () => loadAssets(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  border: Border.all(
                    width: images.length == 0 ? 2 : 0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                child: Icon(Icons.add),
              ),
            ),
          )
        : GridView.count(
            crossAxisCount: 3,
            children: List.generate(images.length, (index) {
              Asset asset = images[index];
              return AssetThumb(
                asset: asset,
                width: 300,
                height: 300,
              );
            }),
          );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#990011",
          actionBarTitle: "Choose photos",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  Future<void> uploadImages() async {
    for (var imageFile in images) {
      await postImage(imageFile).then((downloadUrl) {
        imageUrls.add(downloadUrl.toString());
        if (imageUrls.length == images.length) {
          return;
        }
      }).catchError((err) {
        print(err);
      });
    }
  }

  Future<dynamic> postImage(Asset imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseStorage db = FirebaseStorage.instance;
    await db
        .ref()
        .child("images")
        .child("${AppUser.phone}_$fileName")
        .putData((await imageFile.getByteData()).buffer.asUint8List());
    return db
        .ref()
        .child("images")
        .child("${AppUser.phone}_$fileName")
        .getDownloadURL();
  }
}
