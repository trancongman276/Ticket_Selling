import 'package:CoachTicketSelling/classes/Implement/DriverImpl.dart';
import 'package:CoachTicketSelling/classes/Implement/TripImpl.dart';
import 'package:CoachTicketSelling/classes/actor/AppUser.dart';
import 'package:CoachTicketSelling/classes/actor/Driver.dart';
import 'package:CoachTicketSelling/Utils/Route.dart';
import 'package:CoachTicketSelling/classes/actor/Manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoadingView extends StatefulWidget {
  @override
  _LoadingViewState createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  String route;

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

      switch (_role) {
        case 'User':
          await AppUser.instance.getUser(FirebaseAuth.instance.currentUser.uid);
          // await TripImplement.instance.init();
          break;
        case 'Manager':
          await Manager.instance.getData();
          await DriverImpl.instance.init();
          await TripImplement.instance.init('Manager');
          break;
        case 'Driver':
          await Driver.currentDriver.init();
          await TripImplement.instance.init('Driver');
          break;
      }
      role = doc.data()['Role'];
    });

    return Future.value(role);
  }

  void navigation() async {
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
    return Container(
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
