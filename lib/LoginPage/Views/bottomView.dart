import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:CoachTicketSelling/Utils/Route.dart';
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
              Navigator.pushNamed(context, RegisterViewRoute);
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => RegisterView()));
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
