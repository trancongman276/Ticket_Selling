import 'package:CoachTicketSelling/Utils/Route.dart';
import 'package:flutter/material.dart';

class MsgDialog {
  static void showMsgDialog(
      BuildContext contextMain, String title, String msg) {
    showDialog(
        context: contextMain,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(msg),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamedAndRemoveUntil(contextMain,
                        UserViewRoute, (Route<dynamic> route) => false);
                  },
                )
              ],
            ));
  }
}
