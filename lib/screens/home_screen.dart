import 'package:famdoc_doctor_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'home-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacementNamed(context, LoginScreen.id);
          },
          child: Text('Log Out'),
        ),
      ),
    );
  }
}
