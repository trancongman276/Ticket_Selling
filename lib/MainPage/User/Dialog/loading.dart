
import 'dart:async';

import 'package:flutter/material.dart';

import 'msg.dart';

class LoadingDialog {
  static void showLoadingDialog (BuildContext context, String msg) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => new Dialog(
          child: Container (
            color: Colors.white,
            height: 100,
            child: Column (
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                Padding (
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text (
                    msg,
                    style: TextStyle (fontSize: 18),
                  ),
                )
              ],
            ),
          ),
        )
    );
    new Future.delayed(new Duration(seconds: 2), () {
      Navigator.pop(context);
      MsgDialog.showMsgDialog(context, "Payment", "Payment succesfully");
    });
  }
}

