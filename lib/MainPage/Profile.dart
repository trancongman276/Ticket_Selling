import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'UserUI.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int currentIndex = 0;
  String fullName = 'Nguyen Huynh Phuong Thanh';
  String email = 'abc@gmail.com';
  String dob = '2000-09-01';
  String phone = '0123456789';
  String gener = 'Female';


  @override
  Widget build(BuildContext context) {
    return Scaffold (
      backgroundColor: Color(0xFFE8F5E9),
      body: SingleChildScrollView(
        child: SafeArea (
          child: Container (
            margin: EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: Column (
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(90, 10, 0, 20),
                  child: Text (
                    "MY PROFILE",
                    style: TextStyle ( fontSize: 30, color: Colors.green, fontWeight: FontWeight.bold,),
                  ),
                ),
                Center (
                  child: Stack (
                    children: <Widget>[
                      Container (
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration (
                          border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor
                          ),
                          boxShadow: [
                            BoxShadow (
                              spreadRadius: 2, blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset (0,10)
                            )
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage (
                            fit: BoxFit.cover,
                            image: AssetImage ('assets/images/profile.png'),
                          )
                        ),
                      ),
                      Positioned (
                        bottom: 0,
                        right: 0,
                        child: Container (
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration (
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            )
                          ),
                          child: Icon (Icons.edit, color: Colors.white,),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 430,
                  child: ListView (
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      SizedBox (height: 20),
                      Text (
                        "FULL NAME",
                        style: TextStyle (
                          fontSize: 20, color: Colors.black,
                        ),
                      ),
                      SizedBox (height: 10),
                      Container (
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration (
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                          color: Colors.lightGreen[600],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: Text (
                            fullName,
                            style: TextStyle (fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox (height: 20),
                      Text (
                        "EMAIL",
                        style: TextStyle (
                          fontSize: 20, color: Colors.black,
                        ),
                      ),
                      SizedBox (height: 10),
                      Container (
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration (
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                          color: Colors.lightGreen[600],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: Text (
                            email,
                            style: TextStyle (fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox (height: 20),
                      Text (
                        "DATE OF BIRTH",
                        style: TextStyle (
                          fontSize: 20, color: Colors.black,
                        ),
                      ),
                      SizedBox (height: 10),
                      Container (
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration (
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                          color: Colors.lightGreen[600],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: Text (
                            dob,
                            style: TextStyle (fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox (height: 20),
                      Text (
                        "PHONE",
                        style: TextStyle (
                          fontSize: 20, color: Colors.black,
                        ),
                      ),
                      SizedBox (height: 10),
                      Container (
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration (
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                          color: Colors.lightGreen[600],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: Text (
                            phone,
                            style: TextStyle (fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox (height: 20),
                      Text (
                        "GENDER",
                        style: TextStyle (
                          fontSize: 20, color: Colors.black,
                        ),
                      ),
                      SizedBox (height: 10),
                      Container (
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration (
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                          color: Colors.lightGreen[600],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: Text (
                            gener,
                            style: TextStyle (fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
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
    );
  }
}
