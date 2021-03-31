import 'dart:io';

import 'package:famdoc_doctor_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DocPicCard extends StatefulWidget {
  @override
  _DocPicCardState createState() => _DocPicCardState();
}

class _DocPicCardState extends State<DocPicCard> {
  File _image;

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {
          _authData.getImage().then((image) {
            setState(() {
              _image = image;
            });
            if (image != null) {
              _authData.isPicAvail = true;
            }
            print(_image.path);
          });
        },
        child: SizedBox(
          height: 150,
          width: 150,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(85)),
            color: Theme.of(context).primaryColor,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(75),
              child: _image == null
                  ? Center(
                      child: Text(
                      'Add Profile Image',
                      style: TextStyle(color: Colors.grey),
                    ))
                  : Image.file(
                      _image,
                      fit: BoxFit.fill,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
