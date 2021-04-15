import 'dart:io';

import 'package:famdoc_doctor_app/providers/package_provider.dart';
import 'package:famdoc_doctor_app/widgets/category_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class AddNewTime extends StatefulWidget {
  static const String id = 'addnew-time';

  @override
  _AddNewTimeState createState() => _AddNewTimeState();
}

class _AddNewTimeState extends State<AddNewTime> {
  final _formKey = GlobalKey<FormState>();

  List<String> _collections = [
    'Home Visit Treatment',
    'Online Consultation',
    'Both Visit And Online Treatment'
  ];
  String dropdownValue;

  var _categoryTextController = TextEditingController();
  var _subcategoryTextController = TextEditingController();
  File _image;
  bool _visible = false;
  bool _track = false;

  String packageName;
  String description;
  double price;

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<PackageProvider>(context);
    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Material(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          child: Text('SetUp Your Hire Package Detail'),
                        ),
                      ),
                      FlatButton.icon(
                        color: Theme.of(context).primaryColor,
                        icon: Icon(
                          Icons.save_outlined,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            if (_categoryTextController.text.isNotEmpty) {
                              if (_subcategoryTextController.text.isNotEmpty) {
                                if (_image != null) {
                                  EasyLoading.show(status: 'Saving...');
                                  _provider
                                      .uploadPackageImage(
                                          _image.path, packageName)
                                      .then((url) {
                                    if (url != null) {
                                      EasyLoading.dismiss();
                                      _provider.savePackageDataToDb(
                                          context: context,
                                          collection: dropdownValue,
                                          description: description,
                                          price: price,
                                          packageName: packageName);

                                      setState(() {
                                        _formKey.currentState.reset();
                                        dropdownValue = null;
                                        _subcategoryTextController.clear();
                                        _categoryTextController.clear();
                                        _image = null;
                                        _visible = false;
                                      });
                                    } else {
                                      _provider.alertDialog(
                                        context: context,
                                        title: 'IMAGE UPLOAD',
                                        content: 'Failed to image upload',
                                      );
                                    }
                                  });
                                } else {
                                  _provider.alertDialog(
                                    context: context,
                                    title: 'PACKAGE IMAGE',
                                    content: 'Package Image Not Selected',
                                  );
                                }
                              } else {
                                _provider.alertDialog(
                                  context: context,
                                  title: 'Time',
                                  content: 'Time not selected',
                                );
                              }
                            } else {
                              _provider.alertDialog(
                                context: context,
                                title: 'Main Day Time',
                                content: 'Main day time not selected',
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              TabBar(
                indicatorColor: Theme.of(context).primaryColor,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.black54,
                tabs: [
                  Tab(text: 'General'),
                  Tab(text: 'Inventory'),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: TabBarView(
                      children: [
                        ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Enter package Name';
                                      }
                                      setState(() {
                                        packageName = value;
                                      });
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        labelText: 'Package Name*',
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[300]),
                                        )),
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 5,
                                    maxLength: 200,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Say some thing About package';
                                      }
                                      setState(() {
                                        description = value;
                                      });
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        labelText: 'About Package*',
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[300]),
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        _provider
                                            .getPackageImage()
                                            .then((image) {
                                          setState(() {
                                            _image = image;
                                          });
                                        });
                                      },
                                      child: SizedBox(
                                        width: 150,
                                        height: 150,
                                        child: Card(
                                          child: Center(
                                            child: _image == null
                                                ? Text('Select Image')
                                                : Image.file(_image),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Enter package Price';
                                      }
                                      setState(() {
                                        price = double.parse(value);
                                      });
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        labelText: 'Package Price*',
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[300]),
                                        )),
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
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 10),
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
                                              controller:
                                                  _categoryTextController,
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'Select Time Of Day You Work';
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                  hintText: 'not selected*',
                                                  labelStyle: TextStyle(
                                                      color: Colors.grey),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Colors.grey[300]),
                                                  )),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                            icon: Icon(Icons.edit_outlined),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return CategoryList();
                                                  }).whenComplete(() {
                                                setState(() {
                                                  _categoryTextController.text =
                                                      _provider
                                                          .selectedCategory;
                                                  _visible = true;
                                                });
                                              });
                                            }),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: _visible,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 20),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Time',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: AbsorbPointer(
                                              absorbing: true,
                                              child: TextFormField(
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
                                                    labelStyle: TextStyle(
                                                        color: Colors.grey),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              Colors.grey[300]),
                                                    )),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                              icon: Icon(Icons.edit_outlined),
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return SubCategoryList();
                                                    }).whenComplete(() {
                                                  setState(() {
                                                    _subcategoryTextController
                                                            .text =
                                                        _provider
                                                            .selectedSubCategory;
                                                  });
                                                });
                                              }),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              SwitchListTile(
                                title: Text('Nothing To Show'),
                                activeColor: Theme.of(context).primaryColor,
                                subtitle: Text(
                                  'Swith on',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                value: _track,
                                onChanged: (selected) {
                                  setState(() {
                                    _track = !_track;
                                  });
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
