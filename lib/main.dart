import 'package:flutter/material.dart';
import 'LoginPage/loginPage.dart';

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
          child: LoginPage(),
        ),
      ),
    );
  }
}
