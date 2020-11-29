import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Utils {
  // Variables
  static final AssetImage _loginBackground =
      AssetImage('assets/images/loginBG.png');
  static final AssetImage _registerBackground =
      AssetImage('assets/images/Login/registerBG.jpg');
  static final Image _logo = Image.asset('assets/images/logo.png');

  // FireBase
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  // Styles
  static final Map<String, TextStyle> styles = {
    'NormalText': TextStyle(),
  };
  static final Color _primaryColor = Color(0xff2ecc71);

  // Func
  static String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  static String validatePassword(String value) {
    if (value.length < 6) {
      return 'Wrong password format';
    }
    return null;
  }

  static String validateEmpty(String value){
    if (value.isEmpty || value == 'yyyy-mm-dd'){
      return 'Please fill the empty';
    }
    return null;
  }

  static String validateNumber(String value, int minLen, int maxLen) {
    if (value.isEmpty) {
      return 'Please fill the empty';
    }

    if (value.length >= maxLen || value.length <= minLen) {
      return 'Wrong number length';
    }
    return null;
  }

  // Getter
  static AssetImage get loginBackground => _loginBackground;

  static AssetImage get registerBackground => _registerBackground;

  static Image get logo => _logo;

  static FirebaseAuth get firebaseAuth => _firebaseAuth;

  static FirebaseFirestore get firebase => _firebase;

  static Color get primaryColor => _primaryColor;
}
