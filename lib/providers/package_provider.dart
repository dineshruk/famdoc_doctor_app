import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PackageProvider with ChangeNotifier {
  String selectedCategory;
  String selectedSubCategory;
  String categoryImage;
  File image;
  String pickerError;
  String docName;
  String packageUrl;

  selectCategory(mainCategory, categoryImage) {
    this.selectedCategory = mainCategory;
    this.categoryImage = categoryImage;
    notifyListeners();
  }

  selectSubCategory(selected) {
    this.selectedSubCategory = selected;
    notifyListeners();
  }

  getDocName(docName) {
    this.docName = docName;
    notifyListeners();
  }

  resetProvider() {
    this.selectedCategory = null;
    this.selectedSubCategory = null;
    this.categoryImage = null;
    this.image = null;
    this.pickerError = null;
    this.docName = null;
    this.packageUrl = null;
    notifyListeners();
  }

  Future<String> uploadPackageImage(filePath, packageName) async {
    File file = File(filePath);
    var timeStamp = Timestamp.now().microsecondsSinceEpoch;

    FirebaseStorage _storage = FirebaseStorage.instance;

    try {
      await _storage
          .ref('packageImage/${this.docName}/$packageName/$timeStamp')
          .putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e.code);
    }
    String downloadURL = await _storage
        .ref('packageImage/${this.docName}/$packageName/$timeStamp')
        .getDownloadURL();
    this.packageUrl = downloadURL;
    notifyListeners();
    return downloadURL;
  }

  Future<File> getPackageImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 20);
    if (pickedFile != null) {
      this.image = File(pickedFile.path);
      notifyListeners();
    } else {
      this.pickerError = 'No image selected.';
      print('No image selected.');
      notifyListeners();
    }
    return this.image;
  }

  alertDialog({context, title, content}) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Future<void> savePackageDataToDb({
    packageName,
    description,
    price,
    collection,
    context,
  }) {
    var timeStamp = DateTime.now().microsecondsSinceEpoch;
    User user = FirebaseAuth.instance.currentUser;
    CollectionReference _packages =
        FirebaseFirestore.instance.collection('packages');
    try {
      _packages.doc(timeStamp.toString()).set({
        'doctor': {'docName': this.docName, 'docUid': user.uid},
        'packageName': packageName,
        'description': description,
        'price': price,
        'collection': collection,
        'categoryName': {
          'mainCategory': this.selectedCategory,
          'subCategory': this.selectedSubCategory,
          'categoryImage': this.categoryImage
        },
        'published': false,
        'packageId': timeStamp.toString(),
        'packageImage': this.packageUrl
      });
      this.alertDialog(
          context: context,
          title: 'SAVE DATA',
          content: 'Package Details saved successfully');
    } catch (e) {
      this.alertDialog(
          context: context, title: 'SAVE DATA', content: '${e.toString()}');
    }
    return null;
  }

  Future<void> updatePackage({
    packageName,
    description,
    price,
    collection,
    context,
    packageId,
    image,
    category,
    subcategory,
    categoryImage,
  }) {
    CollectionReference _packages =
        FirebaseFirestore.instance.collection('packages');
    try {
      _packages.doc(packageId).update({
        'packageName': packageName,
        'description': description,
        'price': price,
        'collection': collection,
        'categoryName': {
          'mainCategory': category,
          'subCategory': subcategory,
          'categoryImage':
              this.categoryImage == null ? categoryImage : this.categoryImage
        },
        'packageImage': this.packageUrl == null ? image : this.packageUrl
      });
      this.alertDialog(
          context: context,
          title: 'SAVE DATA',
          content: 'Package Details saved successfully');
    } catch (e) {
      this.alertDialog(
          context: context, title: 'SAVE DATA', content: '${e.toString()}');
    }
    return null;
  }
}
