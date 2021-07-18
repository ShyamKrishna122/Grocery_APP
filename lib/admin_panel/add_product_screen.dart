import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:toast/toast.dart';

import 'package:grocery/models/productModel.dart';
import 'package:grocery/models/product_text_controllers.dart';
import 'package:grocery/models/userModel.dart';

class AddProductScreen extends StatefulWidget {
  static const routeName = "/add_product_screen";
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  List<Asset> images = List<Asset>();
  final _form = GlobalKey<FormState>();
  List<String> imageUrls = <String>[];
  List<String> sp = [];
  List<String> mrp = [];
  List<String> productSize = [];
  FirebaseFirestore db = FirebaseFirestore.instance;
  var isLoading = false;
  var brandEditingController = TextEditingController();
  var productNameEditingController = TextEditingController();
  var variantEditingController = TextEditingController();
  var mrpEditingController = TextEditingController();
  var spEditingController = TextEditingController();
  var sizeEditingController = TextEditingController();
  var brandFocusNode = FocusNode();
  var productNameFocusNode = FocusNode();
  var variantFocusNode = FocusNode();
  var categoryFocusNode = FocusNode();
  var unitFocusNode = FocusNode();
  var mrpFocusNode = FocusNode();
  var spFocusNode = FocusNode();
  var sizeFocusNode = FocusNode();
  List<String> categories = [];
  String _selectedCategory;
  List<String> units = ["grams", "litre", "kg", "packets"];
  String _selectedUnit;
  final List<ProductTextControllers> productTextControllers =
      List<ProductTextControllers>();

  @override
  void initState() {
    productTextControllers.add(ProductTextControllers(TextEditingController(),
        TextEditingController(), TextEditingController()));
    Future.delayed(Duration.zero).then((value) {
      final value =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      final edit = value["edit"];
      if (edit == 1) {
        final QueryDocumentSnapshot product = value["product"];
        print(product["brand"]);
        brandEditingController.text = product["brand"];
        productNameEditingController.text = product["productName"];
        variantEditingController.text = product["variant"];
        _selectedCategory = product["category"];
        _selectedUnit = product["unit"];
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    brandEditingController.clear();
    productNameEditingController.clear();
    variantEditingController.clear();
    mrpEditingController.clear();
    spEditingController.clear();
    sizeEditingController.clear();
    brandFocusNode.dispose();
    productNameFocusNode.dispose();
    variantFocusNode.dispose();
    categoryFocusNode.dispose();
    unitFocusNode.dispose();
    mrpFocusNode.dispose();
    spFocusNode.dispose();
    sizeFocusNode.dispose();
    super.dispose();
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
            await ProductModel().updateProduct(
                id,
                ProductModel(
                    category: _selectedCategory,
                    brand: brandEditingController.text,
                    productName: productNameEditingController.text,
                    variant: variantEditingController.text,
                    unit: _selectedUnit,
                    imageUrl: imageUrls,
                    mrp: mrp,
                    sellingPrice: sp,
                    size: productSize));
          } else {
            await ProductModel().addProduct(ProductModel(
                category: _selectedCategory,
                brand: brandEditingController.text,
                productName: productNameEditingController.text,
                variant: variantEditingController.text,
                unit: _selectedUnit,
                imageUrl: imageUrls,
                mrp: mrp,
                sellingPrice: sp,
                size: productSize));
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
        elevation: 0.0,
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
                    Text("Your product is being uploaded..Please wait.")
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
                              variantFocusNode.requestFocus();
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
                            controller: variantEditingController,
                            decoration: InputDecoration(
                                hintText: "Enter Variant",
                                labelText: "Variant"),
                            focusNode: variantFocusNode,
                            onFieldSubmitted: (value) {
                              unitFocusNode.requestFocus();
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
                          //width: 110,
                          padding: EdgeInsets.only(top: 11),
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              hintText: "Select Unit*",
                            ),
                            items: units
                                .map(
                                  (value) => DropdownMenuItem(
                                    child: Text(value),
                                    value: value,
                                  ),
                                )
                                .toList(),
                            onChanged: (unit) {
                              _selectedUnit = unit;
                            },
                            value: _selectedUnit,
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
                          height: 200,
                          width: MediaQuery.of(context).size.width * 3 / 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              FlatButton(
                                color: Colors.black12,
                                child: Text("Pick images"),
                                textColor: Theme.of(context).accentColor,
                                onPressed: loadAssets,
                              ),
                              Expanded(
                                child: buildGridView(),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          margin: const EdgeInsets.all(15),
                          //width: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ...productTextControllers.map(
                                  (personController) =>
                                      buildCard(personController)),
                              SizedBox(
                                height: 15.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  FloatingActionButton(
                                      heroTag: 1,
                                      child: Icon(Icons.add),
                                      onPressed: () {
                                        setState(() {
                                          productTextControllers
                                              .add(ProductTextControllers(
                                            TextEditingController(),
                                            TextEditingController(),
                                            TextEditingController(),
                                          ));
                                        });
                                      }),
                                  FloatingActionButton(
                                      heroTag: 2,
                                      child: Icon(Icons.remove),
                                      onPressed: () {
                                        setState(() {
                                          productTextControllers.removeLast();
                                        });
                                      }),
                                ],
                              ),
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

  Widget buildCard(ProductTextControllers controllers) {
    return Row(
      children: <Widget>[
        _buildMrpField(controllers.mrp),
        SizedBox(width: 10.0),
        _buildSpField(controllers.sp),
        SizedBox(width: 10.0),
        _buildSizeField(controllers.size),
        SizedBox(width: 10.0),
      ],
    );
  }

  _buildMrpField(TextEditingController mrps) {
    return Container(
      width: 100,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.always,
        controller: mrps,
        decoration: InputDecoration(hintText: "Enter MRP", labelText: "MRP"),
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value.trim().length == 0) {
            return "Type something";
          }
          return null;
        },
        onFieldSubmitted: (value) {
          setState(() {
            mrp.add(mrps.text);
          });
        },
      ),
    );
  }

  _buildSpField(TextEditingController sps) {
    return Container(
      width: 100,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.always,
        controller: sps,
        decoration: InputDecoration(hintText: "Enter SP", labelText: "SP"),
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value.trim().length == 0) {
            return "Type something";
          }
          return null;
        },
        onFieldSubmitted: (value) {
          setState(() {
            sp.add(sps.text);
          });
        },
      ),
    );
  }

  _buildSizeField(TextEditingController sizes) {
    return Container(
      width: 100,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.always,
        controller: sizes,
        decoration: InputDecoration(hintText: "Enter Size", labelText: "Size"),
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value.trim().length == 0) {
            return "Type something";
          }
          return null;
        },
        onFieldSubmitted: (value) {
          setState(() {
            productSize.add(sizes.text);
          });
        },
      ),
    );
  }
}
