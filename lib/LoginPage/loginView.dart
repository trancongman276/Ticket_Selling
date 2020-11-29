import 'package:CoachTicketSelling/LoginPage/Views/body_view.dart';
import 'package:CoachTicketSelling/LoginPage/Views/bottomView.dart';
import 'package:flutter/material.dart';
import 'Views/top_view.dart';


class LoginView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[TopView(), BodyView(), BottomView()],
      ),
    );
  }
}
