import 'package:CoachTicketSelling/LoginPage/Views/top_view.dart';
import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgetPasswordView extends StatelessWidget {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    Widget _email = TextFormField(
      textInputAction: TextInputAction.next,
      controller: _emailController,
      validator: Utils.validateEmail,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(color: Utils.primaryColor),
        hintText: 'Ex: abc@abc.com',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Utils.primaryColor,
            width: 1.5,
          ),
        ),
      ),
    );

    void request() {
      Utils.firebaseAuth.sendPasswordResetEmail(email: _emailController.text);
      Navigator.pop(context, true);
    }

    Widget _body = Container(
      padding: EdgeInsets.symmetric(vertical: 270, horizontal: 40),
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ], color: Colors.white, borderRadius: BorderRadius.circular(30.0)),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Text(
                    'Forget Password',
                    style: TextStyle(fontSize: 20),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                _email,
                SizedBox(height: 10),
                RaisedButton(
                    onPressed: () {
                      if (_key.currentState.validate()) request();
                      print('Submitted');
                    },
                    color: Utils.primaryColor,
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(color: Colors.white),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
              ],
            ),
          ),
    );

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Form(
        key: _key,
        child: Stack(
          children: <Widget>[TopView(), _body],
        ),
      ),
    );
  }
}
