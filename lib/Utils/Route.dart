import 'package:CoachTicketSelling/LoginPage/forgetView.dart';
import 'package:CoachTicketSelling/LoginPage/loginView.dart';
import 'package:CoachTicketSelling/LoginPage/registerView.dart';
import 'package:CoachTicketSelling/MainPage/Driver/DriverView.dart';
import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:flutter/material.dart';

import 'package:CoachTicketSelling/MainPage/User/UserUI.dart';

const String LoginViewRoute = '/';
const String RegisterViewRoute = '/register';
const String ForgetViewRoute = '/forget';
const String UserViewRoute = '/user';
const String ManagerViewRoute = '/manager';
const String DriverViewRoute = '/driver';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginViewRoute:
      return MaterialPageRoute(builder: (context) => LoginView());
    case RegisterViewRoute:
      return MaterialPageRoute(builder: (context) => RegisterView());
    case ForgetViewRoute:
      return MaterialPageRoute(builder: (context) => ForgetPasswordView());
    case UserViewRoute:
      return MaterialPageRoute(builder: (context) => UserUI());
    case DriverViewRoute:
      return MaterialPageRoute(
          builder: (context) => DriverView(
                title: 'Driver view',
              ));
    default:
      return null;
  }
}

Future<bool> checkLogined() async {
  String mail = await Utils.storage.read(key: 'e');
  String pass = await Utils.storage.read(key: 'p');
  print("[DEBUG] Email: $mail | Pass: $pass");
  if (mail != null && pass != null) {
    Utils.firebaseAuth.signInWithEmailAndPassword(email: mail, password: pass);
    return true;
  } else {
    return false;
  }
}
