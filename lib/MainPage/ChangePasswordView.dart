import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:CoachTicketSelling/classes/actor/AppUser.dart';
import 'package:CoachTicketSelling/classes/actor/Driver.dart';
import 'package:CoachTicketSelling/classes/actor/Manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangePasswordView extends StatefulWidget {
  final String role;

  const ChangePasswordView({Key key, this.role}) : super(key: key);
  @override
  _ChangePasswordViewState createState() => _ChangePasswordViewState(role);
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final String role;
  _ChangePasswordViewState(this.role) {
    title = ['Current Password', 'New Password', 'Re-type Pasword'];
    controllers =
        List.generate(title.length, (index) => TextEditingController());
  }
  List<String> title;
  List<TextEditingController> controllers;
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  String errorMessage = '';

  Future changePassword() async {
    switch (role) {
      case 'Manager':
        if (await checkValidPassword(Manager.instance.email)) {
          Manager.instance.update(password: controllers[1].text.trim());
          Navigator.pop(context);
        }
        break;
      case 'Driver':
        if (await checkValidPassword(Driver.currentDriver.email)) {
          Driver.currentDriver.update(password: controllers[1].text.trim());
          Navigator.pop(context);
        }
        break;
      case 'User':
        if (await checkValidPassword(AppUser.instance.email)) {
          AppUser.instance.update(password: controllers[1].text.trim());
          Navigator.pop(context);
        }
        break;
    }
  }

  Future checkValidPassword(String email) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: controllers[0].text.trim());
    } catch (e) {
      if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password';
      } else if (e.code == "too-many-request")
        errorMessage = "Too many requests. Try again later.";
      else
        errorMessage = 'Unexpected Error Occur';
      setState(() {});
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
        centerTitle: true,
        backgroundColor: Utils.primaryColor,
      ),
      body: Form(
        key: _key,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            children: <Widget>[
              Flexible(
                child: ListView.builder(
                  itemCount: title.length,
                  itemBuilder: (context, index) {
                    Widget textform = TextFormField(
                      cursorColor: Utils.primaryColor,
                      validator: (value) {
                        if (index == 2) {
                          return Utils.validateRetypePassword(
                              value, controllers[1].text);
                        }
                        return Utils.validatePassword(value);
                      },
                      obscureText: true,
                      controller: controllers[index],
                      textInputAction: TextInputAction.next,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: InputDecoration(
                        labelText: title[index],
                        labelStyle: TextStyle(
                            color: Utils.primaryColor,
                            fontWeight: FontWeight.bold),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Utils.primaryColor)),
                      ),
                    );

                    if (index == title.length - 1) {
                      return Column(
                        children: <Widget>[
                          textform,
                          if (errorMessage.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                errorMessage,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: RaisedButton(
                              color: Utils.primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              onPressed: () async {
                                if (_key.currentState.validate()) {
                                  await changePassword();
                                }
                              },
                              child: Text(
                                'Save',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else
                      return textform;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
