import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_app/loginPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
@override
Widget build(BuildContext context) {
  // final wordpair = WordPair.random();
  return MaterialApp(
    theme: ThemeData(
      fontFamily: 'Nunito',

    ),
    debugShowCheckedModeBanner: false,
    title: "Welcome",
    home: loginPage(),
    // home: Scaffold(
    //   body: RandomWords(),
    // ),
  );
}
}
