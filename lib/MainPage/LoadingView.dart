import 'package:CoachTicketSelling/classes/Implement/BillImpl.dart';
import 'package:CoachTicketSelling/classes/Implement/DriverImpl.dart';
import 'package:CoachTicketSelling/classes/Implement/TicketImpl.dart';
import 'package:CoachTicketSelling/classes/Implement/TripImpl.dart';
import 'package:CoachTicketSelling/classes/actor/AppUser.dart';
import 'package:CoachTicketSelling/classes/actor/Driver.dart';
import 'package:CoachTicketSelling/Utils/Route.dart';
import 'package:CoachTicketSelling/classes/actor/Manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LoadingView extends StatefulWidget {
  @override
  _LoadingViewState createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  String route;
  String role;
  Future<bool> isInit;
  @override
  void initState() {
    super.initState();
    navigation();
  }

  Future<String> getData() async {
    String role = '';
    await FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((doc) async {
      String _role = doc.data()['Role'];
      this.role = _role;

      switch (_role) {
        case 'User':
          await TripImplement.instance.initAll();
          await AppUser.instance.getUser();
          TicketImpl.instance.init();
          break;
        case 'Manager':
          await Manager.instance.getData();
          await DriverImpl.instance.init();
          await TripImplement.instance.init('Manager');
          await BillImplement.instance.refresh();
          break;
        case 'Driver':
          await Driver.currentDriver.init();
          await TripImplement.instance.init('Driver');
          break;
      }
      isInit = Future.value(true);
      role = doc.data()['Role'];
    });
    return Future.value(role);
  }

  Future<void> navigation() async {
    String role = await getData();
    switch (role) {
      case 'User':
        Navigator.of(context).popAndPushNamed(UserViewRoute);
        break;
      case 'Manager':
        Navigator.of(context).popAndPushNamed(ManagerViewRoute);
        break;
      case 'Driver':
        Navigator.of(context).popAndPushNamed(DriverViewRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => Future.value(false),
        child: Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            )));
  }
}
