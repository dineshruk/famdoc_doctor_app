import 'package:email_validator/email_validator.dart';
import 'package:famdoc_doctor_app/providers/auth_provider.dart';
import 'package:famdoc_doctor_app/screens/home_screen.dart';
import 'package:famdoc_doctor_app/screens/register_screen.dart';
import 'package:famdoc_doctor_app/widgets/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  Icon icon;
  bool _visible = false;
  var _emailTextController = TextEditingController();
  String email;
  String password;
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: SingleChildScrollView(
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      //mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Login',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 30),
                            ),
                            Image.asset(
                              'images/logo.png',
                              height: 100,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: _emailTextController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter Email';
                            }
                            final bool _isValid = EmailValidator.validate(
                                _emailTextController.text);
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
                            errorBorder: OutlineInputBorder(),
                            focusedErrorBorder: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2),
                            ),
                            focusColor: Theme.of(context).primaryColor,
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter Password';
                            }
                            if (value.length < 6) {
                              return 'Minimum 6 Chaacters';
                            }
                            setState(() {
                              password = value;
                            });
                            return null;
                          },
                          obscureText: _visible == false ? true : false,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: _visible
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _visible = !_visible;
                                });
                              },
                            ),
                            enabledBorder: OutlineInputBorder(),
                            errorBorder: OutlineInputBorder(),
                            focusedErrorBorder: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2),
                            ),
                            focusColor: Theme.of(context).primaryColor,
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.vpn_key_sharp),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                    context, ResetPassword.id);
                              },
                              child: Text(
                                'Forgot Password ?',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: FlatButton(
                                color: Theme.of(context).primaryColor,
                                child: _loading
                                    ? LinearProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                        backgroundColor: Colors.transparent,
                                      )
                                    : Text(
                                        'Login',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      _loading = true;
                                    });
                                    _authData
                                        .loginDoctor(email, password)
                                        .then((credential) {
                                      if (credential != null) {
                                        setState(() {
                                          _loading = false;
                                        });
                                        Navigator.pushReplacementNamed(
                                            context, HomeScreen.id);
                                      } else {
                                        setState(() {
                                          _loading = false;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content:
                                                    Text(_authData.error)));
                                      }
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            FlatButton(
                              padding: EdgeInsets.zero,
                              child: RichText(
                                  text: TextSpan(text: '', children: [
                                TextSpan(
                                    text: 'Don\'t have an account ? ',
                                    style: TextStyle(color: Colors.black54)),
                                TextSpan(
                                    text: 'Register',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold))
                              ])),
                              onPressed: () {
                                Navigator.pushNamed(context, RegisterScreen.id);
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
