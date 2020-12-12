import 'dart:io';

import 'package:CoachTicketSelling/MainPage/User/UserUI.dart';

import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:CoachTicketSelling/Utils/Route.dart';
import 'package:CoachTicketSelling/classes/actor/AppUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BodyView extends StatefulWidget {
  @override
  _BodyViewState createState() => _BodyViewState();
}

class _BodyViewState extends State<BodyView>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String errorMessage = '';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Future<bool> _onWillPop() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Exit'),
              content: Text('Do you want to close app?'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('No')),
                FlatButton(onPressed: () => exit(0), child: Text('Yes')),
              ],
            ));
  }

  Future<bool> _navigate() async {
    String id = FirebaseAuth.instance.currentUser.uid;

    String role = '';
    await FirebaseFirestore.instance
        .collection('User')
        .doc(id)
        .get()
        .then((doc) => role = doc.data()['Role']);
    switch (role) {
      case 'User':
        AppUser.instance.getUser(FirebaseAuth.instance.currentUser.uid);
        Navigator.pushNamed(context, UserViewRoute);
        break;
      case 'Driver':
        Navigator.pushNamed(context, DriverViewRoute);
        break;
      case 'Manager':
        Navigator.pushNamed(context, ManagerViewRoute);
        break;
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final emailTb = Container(
      padding: EdgeInsets.all(0),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        controller: _emailController,
        validator: Utils.validateEmail,
        decoration: InputDecoration(
          hintText: 'Email (abc@abc.com)',
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Utils.primaryColor,
              width: 1.5,
            ),
          ),
        ),
      ),
    );

    final passwordTB = Container(
      padding: EdgeInsets.all(0),
      child: TextFormField(
        obscureText: true,
        textInputAction: TextInputAction.done,
        controller: _passwordController,
        validator: Utils.validatePassword,
        decoration: InputDecoration(
          hintText: 'Password (at least 6 characters)',
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Utils.primaryColor,
              width: 1.5,
            ),
          ),
        ),
      ),
    );

    final otherLoginMethod = [
      IconButton(
        onPressed: () {
          print('[DEBUG] Sign In Facebook bt pressed!');
        },
        icon: FaIcon(FontAwesomeIcons.facebook),
        color: Utils.primaryColor,
      ), // Facebook
      IconButton(
        onPressed: () {
          print('[DEBUG] Sign In Twitter bt pressed!');
        },
        icon: FaIcon(FontAwesomeIcons.twitter),
        color: Utils.primaryColor,
      ), // Twitter
      IconButton(
        onPressed: () {
          print('[DEBUG] Sign In with Google bt pressed!');
        },
        icon: FaIcon(FontAwesomeIcons.google),
        color: Utils.primaryColor,
      ), // Google
    ];

    void login() async {
      try {
        print('[DEBUG] Loggin in');
        UserCredential user = await Utils.firebaseAuth
            .signInWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim());
        print("[DEBUG] Email verified: " +
            Utils.firebaseAuth.currentUser.emailVerified.toString());
        // TODO: Verification
        // if (user.user.emailVerified == false) {
        //   setState(() {
        //     errorMessage = "Email is not verified";
        //   });
        // } else {
        await Utils.storage
            .write(key: 'e', value: _emailController.text.trim());
        await Utils.storage
            .write(key: 'p', value: _passwordController.text.trim());
        _navigate();
        // }
      } catch (error) {
        print('[DEBUG] ' + error.code);
        setState(() {
          switch (error.code) {
            case "wrong-password":
              errorMessage = "Your email or password is wrong.";
              break;
            case "user-not-found":
              errorMessage = "Your email or password is wrong.";
              break;
            case "user-disabled":
              errorMessage = "User with this email has been disabled.";
              break;
            case "too-many-request":
              errorMessage = "Too many requests. Try again later.";
              break;
            default:
              errorMessage = "An undefined Error happened.";
          }
        });
      }
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Form(
        key: _formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                // Body
                margin: EdgeInsets.all(40),
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0)),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Login Account',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                    emailTb,
                    passwordTB,
                    Container(
                      alignment: Alignment.topRight,
                      child: FlatButton(
                        onPressed: () async {
                          print('[DEBUG] Forgot bt pressed!');
                          // var result = await Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => ForgetPasswordView()));
                          // var result =
                          //     await Navigator.pushNamed(context, ForgetViewRoute);
                          // if (result != null)
                          //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //     content: Text(result),
                          //     duration: Duration(seconds: 3),
                          //   ));
                          Navigator.pushNamed(context, ForgetViewRoute).then(
                              (value) => ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text("Check your mail"),
                                    duration: Duration(seconds: 3),
                                  )));
                        },
                        child: Text(
                          'Forgot?',
                          style: TextStyle(color: Utils.primaryColor),
                        ),
                      ),
                    ),
                    // SizedBox(height: 10,),
                    RaisedButton(
                        onPressed: () async {
                          if (_formkey.currentState.validate()) login();
                        },
                        color: Utils.primaryColor,
                        child: Text(
                          'LOG IN',
                          style: TextStyle(color: Colors.white),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 80),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                    Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),

                    Container(
                      child: Text('Or'),
                      padding: EdgeInsets.symmetric(vertical: 5),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: otherLoginMethod,
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
