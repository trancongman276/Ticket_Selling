import 'package:CoachTicketSelling/LoginPage/Views/body_view.dart';
import 'package:CoachTicketSelling/LoginPage/Views/bottomView.dart';
import 'package:flutter/material.dart';
import 'Views/top_view.dart';


class LoginView extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Stack(
        children: <Widget>[TopView(), BodyView(formkey: _formKey,), BottomView()],
      ),
    );
  }
}
