import 'package:famdoc_doctor_app/widgets/image_picker.dart';
import 'package:famdoc_doctor_app/widgets/register_form.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  static const String id = 'register-screen';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    'Doctor Registration',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                DocPicCard(),
                RegisterForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
