import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/loginPage.dart';

class splashScreen extends StatefulWidget {
  @override
  _splashScreenState createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  int state = 0;
  Widget curWid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 5), () {
      print('Changed to state $state');
      setState(() {
        state = 1;
      });
      print('Changed to state $state');
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget Stage = Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          color: Color(0xff27ae60),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 150),
                    ),
                    Container(
                      decoration:
                          BoxDecoration(shape: BoxShape.circle, boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        )
                      ]),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50.0,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                          child: Image.asset('assets/images/logo.png'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'The Car',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Memory on the road',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  )
                ],
              ),
            )
          ],
        ),
      ],
    );

    switch (state) {
      case 0:
        return Stage;
        break;
      default:
        print('Passed');
        return loginPage();
        break;
    }
  }
}
