import 'dart:io';

import 'package:CoachTicketSelling/MainPage/UserUI.dart';
import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserMainView extends StatefulWidget {
  final String id;


  const UserMainView({Key key, @required this.id}) : super(key: key);
  @override
  _UserMainViewState createState() => _UserMainViewState(this.id);
}

class _UserMainViewState extends State<UserMainView> {
  final uid;
  _UserMainViewState(this.uid);
  int currentIndex = 0;

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
                      onPressed: () => Navigator.push(context, MaterialPageRoute (builder: (context) => UserUI ())),
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
                        Navigator.push(context, MaterialPageRoute (builder: (context) => UserUI ())),
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
        bottomNavigationBar: BottomNavyBar (
          selectedIndex: currentIndex,
          onItemSelected: (index) {
            setState(() {
              currentIndex = index;
              if (currentIndex == 1) {
                Navigator.push(context, MaterialPageRoute (builder: (context) => UserUI()));
              }
              currentIndex = 0;
            });
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem (
              icon: Icon (Icons.person, size: 30,),
              title: Text ('Profile',style: TextStyle (fontSize: 18),),
              activeColor: Utils.primaryColor,
              inactiveColor: Colors.black,
            ),
            BottomNavyBarItem (
              icon: Icon (Icons.search, size: 30,),
              title: Text ('Search',style: TextStyle (fontSize: 18),),
              activeColor: Utils.primaryColor,
              inactiveColor: Colors.black,
            ),
            BottomNavyBarItem (
              icon: Icon (FontAwesomeIcons.ticketAlt, size: 27,),
              title: Text ('Ticket',style: TextStyle (fontSize: 18),),
              activeColor: Utils.primaryColor,
              inactiveColor: Colors.black,
            ),
            BottomNavyBarItem (
              icon: Icon (Icons.settings, size: 30,),
              title: Text ('Setting',style: TextStyle (fontSize: 18),),
              activeColor: Utils.primaryColor,
              inactiveColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
