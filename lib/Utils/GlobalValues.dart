import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Utils{

   // Variables
   static final AssetImage _loginBackground = AssetImage('assets/images/loginBG.png');
   static final Image _logo = Image.asset('assets/images/logo.png');

   // FireBase
   static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

   // Styles
   static final Map<String, TextStyle> styles = {
     'NormalText' : TextStyle(),
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
      return '';
   }

   // Getter
   static AssetImage get loginBackground => _loginBackground;
   static Image get logo => _logo;
  static FirebaseAuth get firebaseAuth => _firebaseAuth;
   static Color get primaryColor => _primaryColor;

}