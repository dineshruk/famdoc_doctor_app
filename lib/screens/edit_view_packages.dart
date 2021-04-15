import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famdoc_doctor_app/providers/package_provider.dart';
import 'package:famdoc_doctor_app/services/firebase_services.dart';
import 'package:famdoc_doctor_app/widgets/category_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class EditViewPackage extends StatefulWidget {
  final String packageId;
  EditViewPackage({this.packageId});
  @override
  _EditViewPackageState createState() => _EditViewPackageState();
}

class _EditViewPackageState extends State<EditViewPackage> {
  FirebaseServices _services = FirebaseServices();
  final _formKey = GlobalKey<FormState>();

  List<String> _collections = [
    'Home Visit Treatment',
    'Online Consultation',
    'Both Visit And Online Treatment'
  ];
  String dropdownValue;

  var _packageText = TextEditingController();
  var _priceText = TextEditingController();
  var _timeText = TextEditingController();
  var _packageType = TextEditingController();
  var _descriptionText = TextEditingController();
  var _categoryTextController = TextEditingController();
  var _subcategoryTextController = TextEditingController();
  String image;
  File _image;
  bool _visible = false;
  String categoryImage;
  bool _editing = true;

  DocumentSnapshot doc;

  @override
  void initState() {
    getPackageDetails();
    super.initState();
  }

  Future<void> getPackageDetails() async {
    _services.packages
        .doc(widget.packageId)
        .get()
        .then((DocumentSnapshot document) {
      if (document.exists) {
        setState(() {
          doc = document;
          _packageText.text = document.data()['packageName'];
          _priceText.text = document.data()['price'].toString();
          _timeText.text = document.data()['categoryName']['subCategory'];
          _packageType.text = document.data()['categoryName']['mainCategory'];
          image = document.data()['categoryName']['categoryImage'];
          _descriptionText.text = document.data()['description'];
          _categoryTextController.text =
              document.data()['categoryName']['mainCategory'];
          _subcategoryTextController.text =
              document.data()['categoryName']['subCategory'];
          dropdownValue = document.data()['collection'];
          categoryImage = document.data()['categoryName']['categoryImage'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<PackageProvider>(context);
    _provider.resetProvider();
    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton(
              onPressed: () {
                setState(() {
                  _editing = false;
                });
              },
              child: Text(
                'Edit',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      bottomSheet: Container(
        height: 50,
        child: Row(
          children: [
            Expanded(
                child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                color: Colors.black87,
                child: Center(
                    child: Text(
                  'Cancel',
                  style: TextStyle(fontSize: 19, color: Colors.white),
                )),
              ),
            )),
            Expanded(
                child: AbsorbPointer(
              absorbing: _editing,
              child: InkWell(
                onTap: () {
                  if (_formKey.currentState.validate()) {
                    EasyLoading.show(status: 'Saving...');
                    if (_image != null) {
                      _provider
                          .uploadPackageImage(_image.path, _packageText.text)
                          .then((url) {
                        if (url != null) {
                          EasyLoading.dismiss();
                          _provider.updatePackage(
                            context: context,
                            packageName: _packageText.text,
                            price: double.parse(_priceText.text),
                            description: _descriptionText.text,
                            collection: dropdownValue,
                            packageId: widget.packageId,
                            image: image,
                            category: _categoryTextController.text,
                            subcategory: _subcategoryTextController.text,
                            categoryImage: categoryImage,
                          );
                        }
                      });
                    } else {
                      
                      _provider.updatePackage(
                        context: context,
                        packageName: _packageText.text,
                        price: double.parse(_priceText.text),
                        description: _descriptionText.text,
                        collection: dropdownValue,
                        packageId: widget.packageId,
                        image: image,
                        category: _categoryTextController.text,
                        subcategory: _subcategoryTextController.text,
                        categoryImage: categoryImage,
                      );
                      EasyLoading.dismiss();
                    }
                  }
                },
                child: Container(
                  color: Colors.pinkAccent,
                  child: Center(
                      child: Text(
                    'Save',
                    style: TextStyle(fontSize: 19, color: Colors.white),
                  )),
                ),
              ),
            )),
          ],
        ),
      ),
      body: doc == null
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView(
                    children: [
                      AbsorbPointer(
                        absorbing: _editing,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 150,
                                  height: 30,
                                  child: TextFormField(
                                    enabled: false,
                                    controller: _packageType,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      hintText: 'Package Type',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: OutlineInputBorder(),
                                      filled: true,
                                      fillColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(.1),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Time : '),
                                    Container(
                                      width: 70,
                                      child: TextFormField(
                                        enabled: false,
                                        controller: _timeText,
                                        style: TextStyle(fontSize: 14),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                              controller: _packageText,
                              style: TextStyle(fontSize: 30),
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                prefixText: 'Rs : ',
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                              controller: _priceText,
                              style: TextStyle(fontSize: 20),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: _image != null
                                    ? Image.file(
                                        _image,
                                        height: 300,
                                      )
                                    : Image.network(
                                        image,
                                        height: 300,
                                      ),
                              ),
                            ),
                            Text(
                              'About this Package',
                              style: TextStyle(fontSize: 20),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: TextFormField(
                                maxLines: null,
                                controller: _descriptionText,
                                keyboardType: TextInputType.multiline,
                                style: TextStyle(color: Colors.grey),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 10),
                              child: Row(
                                children: [
                                  Text(
                                    'Time of Day',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 16),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: AbsorbPointer(
                                      absorbing: true,
                                      child: TextFormField(
                                        enabled: false,
                                        controller: _categoryTextController,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Select Time Of Day You Work';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            hintText: 'not selected*',
                                            labelStyle:
                                                TextStyle(color: Colors.grey),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey[300]),
                                            )),
                                      ),
                                    ),
                                  ),
                                  // Visibility(
                                    
                                  //   visible: _editing ? false : true,
                                  //   child: IconButton(
                                  //       icon: Icon(Icons.edit_outlined),
                                  //       onPressed: () {
                                  //         showDialog(
                                  //             context: context,
                                  //             builder: (BuildContext context) {
                                  //               return CategoryList();
                                  //             }).whenComplete(() {
                                  //           setState(() {
                                  //             _categoryTextController.text =
                                  //                 _provider.selectedCategory;
                                  //             _visible = true;
                                  //           });
                                  //         });
                                  //       }),
                                  //),
                                ],
                              ),
                            ),
                            Padding(
                              
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 20),
                                child: Row(
                                  
                                  children: [
                                    Text(
                                      'Time',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      
                                      child: AbsorbPointer(
                                        absorbing: true,
                                        child: TextFormField(
                                          enabled: false,
                                          controller:
                                              _subcategoryTextController,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Select Time';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              hintText: 'not selected*',
                                              labelStyle:
                                                  TextStyle(color: Colors.grey),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey[300]),
                                              )),
                                        ),
                                      ),
                                    ),
                                    // IconButton(
                                    //     icon: Icon(Icons.edit_outlined),
                                    //     onPressed: () {
                                    //       showDialog(
                                    //           context: context,
                                    //           builder: (BuildContext context) {
                                    //             return SubCategoryList();
                                    //           }).whenComplete(() {
                                    //         setState(() {
                                    //           _subcategoryTextController.text =
                                    //               _provider.selectedSubCategory;
                                    //         });
                                    //       });
                                    //     }),
                                  ],
                                ),
                              ),
                        
                            Container(
                              child: Row(
                                children: [
                                  Text('How You Treat',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      )),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  DropdownButton<String>(
                                    hint: Text('Select Type'),
                                    value: dropdownValue,
                                    icon: Icon(Icons.arrow_drop_down),
                                    onChanged: (String value) {
                                      setState(() {
                                        dropdownValue = value;
                                      });
                                    },
                                    items: _collections
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            )
                          ],
                        ),
                      ),
                    ],
                  ))),
    );
  }
}
