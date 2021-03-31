import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class AuthProvider extends ChangeNotifier {
  File image;
  bool isPicAvail = false;
  String pickerError = '';
  String error = '';
  double docLatitude;
  double docLongitude;
  String docAddress;
  String placeName;
  String email;

  Future<File> getImage() async {
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

  Future getCurrentAddress() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    this.docLatitude = _locationData.latitude;
    this.docLongitude = _locationData.longitude;
    notifyListeners();

    final coordinates =
        new Coordinates(_locationData.latitude, _locationData.longitude);
    var _addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var docAddress = _addresses.first;
    this.docAddress = docAddress.addressLine;
    this.placeName = docAddress.featureName;
    notifyListeners();
    return docAddress;
  }
//doctor register
  Future<UserCredential> registerDoctor(email, password) async {
    this.email = email;
    notifyListeners();
    UserCredential userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        this.error = 'The password provided is too weak';
        notifyListeners();
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        this.error = 'The account already exists for that email';
        notifyListeners();
        print('The account already exists for that email.');
      }
    } catch (e) {
      this.error = e.toString();
      notifyListeners();
      print(e);
    }
    return userCredential;
  }
//doctor login
  Future<UserCredential> loginDoctor(email, password) async {
    this.email = email;
    notifyListeners();
    UserCredential userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      this.error = e.code;
      notifyListeners();
    } catch (e) {
      this.error = e.code;
      notifyListeners();
      print(e);
    }
    return userCredential;
  }



//reset passwor
 Future<void> resetPassword(email) async {
    this.email = email;
    notifyListeners();
    UserCredential userCredential;
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email,);
    } on FirebaseAuthException catch (e) {
      this.error = e.code;
      notifyListeners();
    } catch (e) {
      this.error = e.code;
      notifyListeners();
      print(e);
    }
    return userCredential;
  }

  //save doctor data to firestore

  Future<void> saveDoctorDataToDb(
      {String url,
      String docName,
      String mobile,
      String docID,
      String hospital}) {
    User user = FirebaseAuth.instance.currentUser;
    DocumentReference _doctors =
        FirebaseFirestore.instance.collection('doctors').doc(user.uid);
    _doctors.set({
      'uid': user.uid,
      'docName': docName,
      'mobile': mobile,
      'email': this.email,
      'docID': docID,
      'hospital': hospital,
      'address': '${this.placeName}: ${this.docAddress}',
      'location': GeoPoint(this.docLatitude, this.docLongitude),
      'docAvaiable': true,
      'rating': 0.0,
      'totalRating': 0,
      'verified': false,
      'imageURL': url
    });
    return null;
  }
}
