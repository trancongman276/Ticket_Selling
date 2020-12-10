import 'package:CoachTicketSelling/LoginPage/forgetView.dart';
import 'package:CoachTicketSelling/LoginPage/loginView.dart';
import 'package:CoachTicketSelling/LoginPage/registerView.dart';

import 'package:CoachTicketSelling/MainPage/Manager/Charts/DetailBarChart.dart';
import 'package:CoachTicketSelling/MainPage/Manager/Charts/DetailLineChart.dart';
import 'package:CoachTicketSelling/MainPage/Manager/ManagerMainView.dart';
import 'package:CoachTicketSelling/MainPage/Manager/Manage/EditDriverView.dart';
import 'package:CoachTicketSelling/MainPage/Manager/Manage/EditTripView.dart';

import 'package:CoachTicketSelling/MainPage/Driver/DriverView.dart';

import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:CoachTicketSelling/Utils/enum.dart';
import 'package:flutter/material.dart';

import 'package:CoachTicketSelling/MainPage/User/UserUI.dart';

const String LoginViewRoute = '/';

const String RegisterViewRoute = '/register';
const String ForgetViewRoute = '/forget';
const String ManagerViewRoute = '/manager';
const String UserViewRoute = '/user';
const String DetailIncomeChartViewRoute = '/manager/detailChart';
const String EditTripViewRoute = '/manager/edit/trip';
const String EditDriverViewRoute = '/manager/edit/driver';
const String DetailBarChartViewRoute = '/manager/charts/barchart';
const String DriverViewRoute = '/driver';

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
    case DetailBarChartViewRoute:
      DetailedChartArgs arg = settings.arguments;
      return MaterialPageRoute(
          settings: settings,
          builder: (context) => BarChartView(
                chart: arg.chart,
                primaryColor: arg.primaryColor,
              ));
    case DetailIncomeChartViewRoute:
      DetailedChartArgs arg = settings.arguments;
      return MaterialPageRoute(
          settings: settings,
          builder: (context) => DetailChart(
                chart: arg.chart,
                primaryColor: arg.primaryColor,
              ));
    case EditTripViewRoute:
      var arg = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => EditTripView(
                tripID: arg,
              ));
    case EditDriverViewRoute:
      var arg = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => EditDriverView(
                driverID: arg,
              ));
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
    // Utils.firebaseAuth
    //     .signInWithEmailAndPassword(email: mail, password: pass)
    //     .then((user) => Account.instance.get(user.user.uid));

    //TODO: FIX ACCOUNT
    return true;
  } else {
    return false;
  }
}

class DetailedChartArgs {
  ChartQuery chart;
  Color primaryColor;
  DetailedChartArgs(this.chart, this.primaryColor);
}
