import 'package:CoachTicketSelling/LoginPage/forgetView.dart';
import 'package:CoachTicketSelling/LoginPage/loginView.dart';
import 'package:CoachTicketSelling/LoginPage/registerView.dart';
import 'package:CoachTicketSelling/MainPage/Manager/Charts/DetailChart.dart';
import 'package:CoachTicketSelling/MainPage/Manager/MainView.dart';
import 'package:CoachTicketSelling/MainPage/UserMainView.dart';
import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:CoachTicketSelling/Utils/enum.dart';
import 'package:CoachTicketSelling/classes/account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const String LoginViewRoute = '/';
const String RegisterViewRoute = '/register';
const String ForgetViewRoute = '/forget';
const String UserViewRoute = '/user';
const String ManagerViewRoute = '/manager';
const String DetailIncomeChartViewRoute = '/manager/detailChart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginViewRoute:
      return MaterialPageRoute(builder: (context) => LoginView());
    case RegisterViewRoute:
      return MaterialPageRoute(builder: (context) => RegisterView());
    case ForgetViewRoute:
      return MaterialPageRoute(builder: (context) => ForgetPasswordView());
    case ManagerViewRoute:
      return MaterialPageRoute(builder: (context) => ManagerMainView());
    case UserViewRoute:
      return MaterialPageRoute(builder: (context) => UserMainView());
    case DetailIncomeChartViewRoute:
      detailedChartArgs arg = settings.arguments;
      return MaterialPageRoute(
          settings: settings,
          builder: (context) => DetailChart(
                chart: arg.chart,
                primaryColor: arg.primaryColor,
              ));
    // case UserViewRoute:
    //   var _id = settings.arguments;
    //   return MaterialPageRoute(builder: (context) => UserMainView(id: _id));
    default:
      return null;
  }
}

Future<bool> checkLogined() async {
  String mail = await Utils.storage.read(key: 'e');
  String pass = await Utils.storage.read(key: 'p');
  print("[DEBUG] Email: $mail | Pass: $pass");
  if (mail != null && pass != null) {
    Utils.firebaseAuth
        .signInWithEmailAndPassword(email: mail, password: pass)
        .then((user) => Account.instance.load(user.user.uid));
    return true;
  } else {
    return false;
  }
}

class detailedChartArgs {
  ChartQuery chart;
  Color primaryColor;
  detailedChartArgs(this.chart, this.primaryColor);
}
