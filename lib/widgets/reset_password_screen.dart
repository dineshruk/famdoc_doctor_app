import 'package:email_validator/email_validator.dart';
import 'package:famdoc_doctor_app/providers/auth_provider.dart';
import 'package:famdoc_doctor_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  static const String id = 'reset-screen';
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  bool _loading = false;
  String email;
  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return Scaffold(
      
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'images/reset_pass.png',
                    height: 210,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RichText(
                      text: TextSpan(text: '', children: [
                    TextSpan(
                        text: 'ForgotPassword  ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent)),
                    TextSpan(
                        text:
                            'Dont worry, provide us you registered Email, We will send you an email to reset your password',
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                  ])),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _emailTextController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Email';
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
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor, width: 2),
                      ),
                      focusColor: Theme.of(context).primaryColor,
                      contentPadding: EdgeInsets.zero,
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: FlatButton(
                          child: _loading
                              ? LinearProgressIndicator()
                              : Text(
                                  'Reset Password',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                _loading = true;
                              });
                              _authData.resetPassword(email);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Check your Email ${_emailTextController.text} for reset link')));
                            }
                            Navigator.pushReplacementNamed(
                                context, LoginScreen.id);
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
      ),
    );
  }
}
