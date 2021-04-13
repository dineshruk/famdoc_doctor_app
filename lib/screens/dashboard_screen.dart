import 'package:famdoc_doctor_app/screens/home_screen.dart';
import 'package:famdoc_doctor_app/widgets/drawer_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('DashBoard'),),
    );
  }
}
