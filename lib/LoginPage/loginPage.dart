import 'package:CoachTicketSelling/LoginPage/Views/body_view.dart';
import 'package:CoachTicketSelling/LoginPage/Views/bottomView.dart';
import 'package:flutter/material.dart';
import 'Views/top_view.dart';


class LoginPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Stack(
        children: <Widget>[TopView(), BodyView(), BottomView()],
      ),
    );

    // Widget registerForm() {
    //   return Container(
    //     padding: EdgeInsets.symmetric(vertical: 185, horizontal: 40),
    //     child: Container(
    //       padding: EdgeInsets.symmetric(horizontal: 20),
    //       decoration: BoxDecoration(boxShadow: [
    //         BoxShadow(
    //           color: Colors.grey.withOpacity(0.5),
    //           spreadRadius: 5,
    //           blurRadius: 7,
    //           offset: Offset(0, 3),
    //         ),
    //       ], color: Colors.white, borderRadius: BorderRadius.circular(30.0)),
    //       child: Column(
    //         children: [
    //           SizedBox(height: 20),
    //           Text(
    //             'Register Account',
    //             style: TextStyle(fontSize: 20),
    //           ),
    //           SizedBox(height: 20),
    //           creator.textbox('Username', null, false, Colors.green, 1.5),
    //           SizedBox(height: 10),
    //           creator.textbox('Password', null, true, Colors.green, 1.5),
    //           SizedBox(height: 10),
    //           creator.textbox('Retype password', null, true, Colors.green, 1.5),
    //           SizedBox(height: 10),
    //           creator.textbox('Email', null, false, Colors.green, 1.5),
    //           SizedBox(height: 20),
    //           RaisedButton(
    //               onPressed: () {
    //                 print('Submited');
    //                 setState(() {
    //                   formState = 2;
    //                 });
    //               },
    //               color: Color(0xff27ae60),
    //               padding: EdgeInsets.symmetric(vertical: 10, horizontal: 80),
    //               child: Text(
    //                 'SUBMIT',
    //                 style: TextStyle(color: Colors.white),
    //               ),
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(30.0),
    //               )),
    //         ],
    //       ),
    //     ),
    //   );
    // }
  }
}
