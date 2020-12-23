import 'package:CoachTicketSelling/LoginPage/forgetView.dart';
import 'package:CoachTicketSelling/LoginPage/loginView.dart';
import 'package:CoachTicketSelling/LoginPage/registerView.dart';
import 'package:CoachTicketSelling/MainPage/ChangePasswordView.dart';
import 'package:CoachTicketSelling/MainPage/Manager/Charts/DetailBarChart.dart';
import 'package:CoachTicketSelling/MainPage/Manager/Charts/DetailLineChart.dart';
import 'package:CoachTicketSelling/MainPage/Manager/ManagerMainView.dart';
import 'package:CoachTicketSelling/MainPage/Manager/Manage/EditDriverView.dart';
import 'package:CoachTicketSelling/MainPage/Manager/Manage/EditTripView.dart';
import 'package:CoachTicketSelling/MainPage/Driver/DriverView.dart';
import 'package:CoachTicketSelling/MainPage/User/BookTrip/BookingUI.dart';
import 'package:CoachTicketSelling/MainPage/User/BookTrip/ChooseSeat.dart';
import 'package:CoachTicketSelling/MainPage/User/Payment/PaymentUI.dart';
import 'package:CoachTicketSelling/MainPage/User/Profile.dart';
import 'package:CoachTicketSelling/MainPage/User/UserUI.dart';
import 'package:CoachTicketSelling/MainPage/User/ViewTicket/ListTicket.dart';
import 'package:CoachTicketSelling/MainPage/User/ViewTicket/PreviewTicketView.dart';
import 'package:CoachTicketSelling/MainPage/LoadingView.dart';
import 'package:CoachTicketSelling/MainPage/ProfileView.dart';
import 'package:CoachTicketSelling/MainPage/User/ViewTicket/DetailTicketUI.dart';
import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:CoachTicketSelling/Utils/enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const String LoginViewRoute = '/';
const String LoadingViewRoute = '/loading';
const String RegisterViewRoute = '/register';
const String ForgetViewRoute = '/forget';
const String ManagerViewRoute = '/manager';
const String DetailIncomeChartViewRoute = '/manager/detailChart';
const String EditTripViewRoute = '/manager/edit/trip';
const String EditDriverViewRoute = '/manager/edit/driver';
const String DetailBarChartViewRoute = '/manager/charts/barchart';
const String UserViewRoute = '/user';
const String UserProfileViewRoute = '/user/profile';
const String UserTicketViewRoute = '/user/ticket';
const String UserDetailTicketViewRoute = '/user/ticketList/detail';
const String UserFindTripViewRoute = '/user/findTrip';
const String UserChooseTripViewRoute = '/user/findTrip/chooseSeat';
const String UserPreviewTicketViewRoute =
    '/user/findTrip/chooseSeat/previewTickets';
const String UserPaymentViewRoute =
    '/user/findTrip/chooseSeat/previewTickets/payment';
const String DriverViewRoute = '/driver';
const String ProfileViewRoute = '/profile';
const String ChangePasswordViewRoute = '/profile/changePassword';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginViewRoute:
      return MaterialPageRoute(builder: (context) => LoginView());
    case RegisterViewRoute:
      return MaterialPageRoute(builder: (context) => RegisterView());
    case ForgetViewRoute:
      return MaterialPageRoute(builder: (context) => ForgetPasswordView());

    case LoadingViewRoute:
      return MaterialPageRoute(builder: (context) => LoadingView());

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
    case UserProfileViewRoute:
      return MaterialPageRoute(builder: (context) => UserProfile());
    case UserTicketViewRoute:
      return MaterialPageRoute(builder: (context) => ListTicket());
    case UserDetailTicketViewRoute:
      var arg = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => DetailTicketUI(
                ticketIndex: arg,
              ));
    case UserFindTripViewRoute:
      var args = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => BookingUI(
                tripLs: args,
              ));
    case UserChooseTripViewRoute:
      var arg = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => ChooseSeat(
                currentTrip: arg,
              ));
    case UserPreviewTicketViewRoute:
      Map<String, dynamic> arg = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => PreviewTicketView(
                checkOutDetail: arg,
              ));
    case UserPaymentViewRoute:
      Map<String, dynamic> arg = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => PaymentUI(
                checkOutDetail: arg,
              ));

    case DriverViewRoute:
      return MaterialPageRoute(
          builder: (context) => DriverView(
                title: 'Driver view',
              ));
    case ProfileViewRoute:
      var arg = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => Profile(
                role: arg,
              ));
    case ChangePasswordViewRoute:
      var arg = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => ChangePasswordView(
                role: arg,
              ));
    default:
      return null;
  }
}

Future<bool> checkLogined() async {
  String mail = await Utils.storage.read(key: 'e');
  String pass = await Utils.storage.read(key: 'p');
  if (mail != null && pass != null) {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: mail, password: pass);
    return true;
  } else {
    return false;
  }
}

Future<String> navigate() async {
  String id = FirebaseAuth.instance.currentUser.uid;
  String role = '';
  await FirebaseFirestore.instance
      .collection('User')
      .doc(id)
      .get()
      .then((doc) => role = doc.data()['Role']);
  // switch (role) {
  //   case 'User':
  //     AppUser.instance.getUser(FirebaseAuth.instance.currentUser.uid);
  //     return Future.value(UserViewRoute);
  //     break;
  //   case 'Driver':
  //     return Future.value(DriverViewRoute);
  //     break;
  //   case 'Manager':
  //     return Future.value(ManagerViewRoute);
  //     break;
  // }
  return Future.value(role);
}

class DetailedChartArgs {
  ChartQuery chart;
  Color primaryColor;
  DetailedChartArgs(this.chart, this.primaryColor);
}
