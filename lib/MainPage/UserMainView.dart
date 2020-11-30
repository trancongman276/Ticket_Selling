import 'dart:io';

import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserMainView extends StatefulWidget {
  const UserMainView({Key key}) : super(key: key);
  @override
  _UserMainViewState createState() => _UserMainViewState();
}

class _UserMainViewState extends State<UserMainView> {
  @override
  Widget build(BuildContext context) {
    final User user = Utils.firebaseAuth.currentUser;

    Future<bool> _onWillPop() {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Exit'),
                content: Text('Do you want to close app?'),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('No')),
                  FlatButton(onPressed: () => exit(0), child: Text('Yes')),
                ],
              ));
    }

    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hello ${user.displayName.split(' ')[0]},",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: FaIcon(FontAwesomeIcons.userCircle),
                    onPressed: () =>
                        {Utils.logout(), Navigator.of(context).pop()},
                    // TODO:
                  ),
                ],
              ),
              Text(
                "Where do you want to go today?",
                style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
