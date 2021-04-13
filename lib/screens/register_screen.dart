import 'package:famdoc_doctor_app/screens/login_screen.dart';
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
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: FlatButton(
                        padding: EdgeInsets.zero,
                        child: RichText(
                            text: TextSpan(text: '', children: [
                          TextSpan(
                              text: 'Already have an account ? ',
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 20)),
                          TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20))
                        ])),
                        onPressed: () {
                          Navigator.pushNamed(context, LoginScreen.id);
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
