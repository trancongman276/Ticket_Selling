import 'package:flutter/material.dart';
import 'package:flutter_app/MainPage/mainPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Nunito',
      ),
      debugShowCheckedModeBanner: false,
      title: "Welcome",
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          child: mainPage(),
        ),
      ),
    );
  }
}
