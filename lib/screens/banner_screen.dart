import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famdoc_doctor_app/providers/package_provider.dart';
import 'package:famdoc_doctor_app/services/firebase_services.dart';
import 'package:famdoc_doctor_app/widgets/banner_card.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class BannerScreen extends StatefulWidget {
  @override
  _BannerScreenState createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  FirebaseServices _services = FirebaseServices();
  bool _visible = false;
  File _image;
  var _imagePathText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<PackageProvider>(context);
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          BannerCard(),
          Divider(
            thickness: 3,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Center(
              child: Text(
                'ADD NEW COVER PICTURE',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      color: Colors.grey[200],
                      child: _image != null
                          ? Image.file(
                              _image,
                              fit: BoxFit.fill,
                            )
                          : Center(
                              child: Text('No Cover Selected'),
                            ),
                    ),
                  ),
                  TextFormField(
                    controller: _imagePathText,
                    enabled: false,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Visibility(
                    visible: _visible ? false : true,
                    child: Row(
                      children: [
                        Expanded(
                          child: FlatButton(
                            color: Theme.of(context).primaryColor,
                            child: Text(
                              'Add New Cover',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              setState(() {
                                _visible = true;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _visible,
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: FlatButton(
                                  color: Theme.of(context).primaryColor,
                                  child: Text(
                                    'Upload Cover',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    getBannerImage().then((value) {
                                      if (_image != null) {
                                        setState(() {
                                          _imagePathText.text = _image.path;
                                        });
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: AbsorbPointer(
                                  absorbing: _image != null ? false : true,
                                  child: FlatButton(
                                    color: _image != null
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey,
                                    child: Text(
                                      'Save',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      EasyLoading.show(status: 'Saving...');
                                      uploadBannerImage(
                                              _image.path, _provider.docName)
                                          .then((url) {
                                        if (url != null) {
                                          _services.saveCover(url);
                                          setState(() {
                                            _imagePathText.clear();
                                            _image = null;
                                          });
                                          EasyLoading.dismiss();
                                          _provider.alertDialog(
                                            context: context,
                                            title: 'Cover Upload',
                                            content:
                                                'Cover Image Uploaded successfully',
                                          );
                                        } else {
                                          _provider.alertDialog(
                                            context: context,
                                            title: 'Cover Upload',
                                            content: 'Cover Uploaded Failed',
                                          );
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: FlatButton(
                                  color: Colors.black54,
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _visible = false;
                                      _imagePathText.clear();
                                      _image = null;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<File> getBannerImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 20);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
    return _image;
  }

  Future<String> uploadBannerImage(filePath, docName) async {
    File file = File(filePath);
    var timeStamp = Timestamp.now().millisecondsSinceEpoch;

    FirebaseStorage _storage = FirebaseStorage.instance;

    try {
      await _storage.ref('doctorcover/${docName}/$timeStamp').putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e.code);
    }
    String downloadURL = await _storage
        .ref('doctorcover/${docName}/$timeStamp')
        .getDownloadURL();

    return downloadURL;
  }
}
