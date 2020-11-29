import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'LoginPage/loginView.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Nunito',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      title: "Welcome",
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          child: LoginView(),
        ),
      ),
    );
  }
}
