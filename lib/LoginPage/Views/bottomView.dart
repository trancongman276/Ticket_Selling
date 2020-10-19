import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:flutter/material.dart';

class BottomView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        // Bottom
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            "Don't have account?",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
                backgroundColor: Colors.white),
          ),
          FlatButton(
            onPressed: () {
              print('Sign Up bt pressed!');
              // TODO: Add PageRoute
            },
            child: Text(
              'Sign Up',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Utils.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
