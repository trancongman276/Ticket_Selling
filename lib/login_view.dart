import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/loginBG.png'),
            fit: BoxFit.fill,
          )),
        ),
        Column(
          children: <Widget>[
            SizedBox(height: 50,),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                )
              ]),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 40.0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Image.asset('assets/images/logo.png'),
                ),
              ),
            ),
            Text(
              'The Car',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Fill the information bellow to login',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
