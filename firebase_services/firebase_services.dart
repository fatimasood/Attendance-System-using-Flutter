import 'dart:async';

import 'package:attendence_sys/authentication/SignIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;

    final user = auth.currentUser;

    if (user != null) {
    } else {
      Timer(
          const Duration(seconds: 6),
          () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignIn())));
    }
  }
}
