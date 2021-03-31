import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:famdoc_doctor_app/providers/auth_provider.dart';
import 'package:famdoc_doctor_app/screens/home_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  var _passwordTextController = TextEditingController();
  var _cpasswordTextController = TextEditingController();
  var _addressTextController = TextEditingController();
  var _nameTextEditingController = TextEditingController();
  var _idTextEditingController = TextEditingController();
  var _hospitalTextEditingController = TextEditingController();
  String email;
  String password;
  String mobile;
  String docName;
  String docID;
  bool _isLoading = false;

  Future<String> uploadFile(filePath) async {
    File file = File(filePath);

    FirebaseStorage _storage = FirebaseStorage.instance;

    try {
      await _storage
          .ref('uploads/docProfilePic/${_nameTextEditingController.text}')
          .putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e.code);
    }
    String downloadURL = await _storage
        .ref('uploads/docProfilePic/${_nameTextEditingController.text}')
        .getDownloadURL();
    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    scaffoldMessage(message) {
      return ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }

    return _isLoading
        ? CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          )
        : Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _nameTextEditingController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Doctor Name';
                      }
                      setState(() {
                        _nameTextEditingController.text = value;
                      });
                      setState(() {
                        docName = value;
                      });
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixText: 'Dr.',
                      prefixIcon: Icon(Icons.perm_identity_outlined),
                      labelText: 'Doctor Name',
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2, color: Theme.of(context).primaryColor)),
                      focusColor: Theme.of(context).primaryColor,
                      errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.redAccent)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.redAccent)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _idTextEditingController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Doctor ID';
                      }
                      setState(() {
                        docID = value;
                      });
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.verified_outlined),
                      labelText: 'Doctor ID',
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2, color: Theme.of(context).primaryColor)),
                      focusColor: Theme.of(context).primaryColor,
                      errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.redAccent)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.redAccent)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _emailTextController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Doctor Email';
                      }
                      final bool _isValid =
                          EmailValidator.validate(_emailTextController.text);
                      if (!_isValid) {
                        return 'Invalid Email Format';
                      }
                      setState(() {
                        email = value;
                      });
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      labelText: 'Doctor Email',
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2, color: Theme.of(context).primaryColor)),
                      focusColor: Theme.of(context).primaryColor,
                      errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.redAccent)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.redAccent)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    maxLength: 9,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Doctor Mobile';
                      }
                      setState(() {
                        mobile = value;
                      });
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixText: '+94',
                      prefixIcon: Icon(Icons.phone_android_outlined),
                      labelText: 'Doctor Mobile',
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2, color: Theme.of(context).primaryColor)),
                      focusColor: Theme.of(context).primaryColor,
                      errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.redAccent)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.redAccent)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    onChanged: (value) {
                      _hospitalTextEditingController.text = value;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.no_encryption),
                      labelText: 'Current Working Hospital',
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2, color: Theme.of(context).primaryColor)),
                      focusColor: Theme.of(context).primaryColor,
                      errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.redAccent)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.redAccent)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _passwordTextController,
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Password';
                      }
                      setState(() {
                        password = value;
                      });
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.vpn_key_outlined),
                      labelText: 'Password',
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2, color: Theme.of(context).primaryColor)),
                      focusColor: Theme.of(context).primaryColor,
                      errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.redAccent)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.redAccent)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _cpasswordTextController,
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Confirm Password';
                      }
                      if (_passwordTextController.text !=
                          _cpasswordTextController.text) {
                        return 'Password Does Not Match';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.vpn_key_outlined),
                      labelText: 'Confirm Password',
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2, color: Theme.of(context).primaryColor)),
                      focusColor: Theme.of(context).primaryColor,
                      errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.redAccent)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.redAccent)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    maxLines: 6,
                    controller: _addressTextController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please press Navigator Button';
                      }
                      if (_authData.docLatitude == null) {
                        return 'Please press Navigation Button';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.perm_identity_outlined),
                      labelText: 'Your Working Location',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.location_searching_outlined),
                        onPressed: () {
                          _addressTextController.text =
                              'Locating..\n Please Wait...';
                          _authData.getCurrentAddress().then((address) {
                            if (address != null) {
                              setState(() {
                                _addressTextController.text =
                                    '${_authData.placeName}\n${_authData.docAddress}';
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Could not find location ..try again')));
                            }
                          });
                        },
                      ),
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2, color: Theme.of(context).primaryColor)),
                      focusColor: Theme.of(context).primaryColor,
                      errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.redAccent)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.redAccent)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: FlatButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            if (_authData.isPicAvail == true) {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });
                                _authData
                                    .registerDoctor(email, password)
                                    .then((credential) {
                                  if (credential.user.uid != null) {
                                    uploadFile(_authData.image.path)
                                        .then((url) {
                                      if (url != null) {
                                        _authData.saveDoctorDataToDb(
                                          url: url,
                                          mobile: mobile,
                                          docName: docName,
                                          docID: docID,
                                          hospital:
                                              _hospitalTextEditingController
                                                  .text,
                                        );

                                        setState(() {
                                          
                                          _isLoading = false;
                                        });
                                        Navigator.pushReplacementNamed(
                                            context, HomeScreen.id);
                                      } else {
                                        scaffoldMessage(
                                            'Failde to upload profile picture');
                                      }
                                    });
                                  } else {
                                    //register failed
                                    scaffoldMessage(_authData.error);
                                  }
                                });
                              }
                            } else {
                              scaffoldMessage(
                                  'Doctor profile picture need to be added');
                            }
                          },
                          child: Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
