import 'package:CoachTicketSelling/MainPage/UserUI.dart';
import 'package:flutter/material.dart';

class MsgDialog {
  static void showMsgDialog (BuildContext context, String title, String msg) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog (
          title: Text(title),
          content: Text (msg),
          actions: <Widget>[
            FlatButton (
              child: Text ('OK'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserUI()));
              },
            )
          ],
        )
    );
  }
}