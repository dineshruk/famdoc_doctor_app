import 'package:famdoc_doctor_app/providers/auth_provider.dart';
import 'package:famdoc_doctor_app/screens/home_screen.dart';
import 'package:famdoc_doctor_app/screens/login_screen.dart';
import 'package:famdoc_doctor_app/screens/register_screen.dart';
import 'package:famdoc_doctor_app/screens/splash_screen.dart';
import 'package:famdoc_doctor_app/widgets/reset_password_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => AuthProvider(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF26A69A),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        LoginScreen.id:(context) => LoginScreen(),
        ResetPassword.id:(context) => ResetPassword(),
      },
    );
  }
}
