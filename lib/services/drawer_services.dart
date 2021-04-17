import 'package:famdoc_doctor_app/screens/banner_screen.dart';
import 'package:famdoc_doctor_app/screens/dashboard_screen.dart';
import 'package:famdoc_doctor_app/screens/time_screen.dart';
import 'package:flutter/material.dart';

class DrawerServices {
  Widget drawerScreen(title) {
    if (title == 'Dashboard') {
      return MainScreen();
    }
    if (title == 'Set Packages') {
      return SetTimeScreen();
    }
    if (title == 'Cover Images') {
      return BannerScreen();
    }
    return MainScreen();
  }
}
