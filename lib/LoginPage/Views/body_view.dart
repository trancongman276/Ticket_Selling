import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:CoachTicketSelling/Utils/Route.dart';
import 'package:CoachTicketSelling/Utils/Timing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BodyView extends StatefulWidget {
  const BodyView({Key key}) : super(key: key);

  @override
  _BodyViewState createState() => _BodyViewState();
}

class _BodyViewState extends State<BodyView>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool isSuccess = true;
  String errorMessage;
  User _user;
  bool resendVerification = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

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
        UserCredential user = await Utils.firebaseAuth
            .signInWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim());
        _user = user.user;
        print("[DEBUG] Email verified: " +
            Utils.firebaseAuth.currentUser.emailVerified.toString());
        if (user.user.emailVerified == false) {
          setState(() {
            isSuccess = false;
            resendVerification = true;
            errorMessage = "Email is not verified";
          });
        } else {
          await Utils.storage
              .write(key: 'e', value: _emailController.text.trim());
          await Utils.storage
              .write(key: 'p', value: _passwordController.text.trim());
          Navigator.pushNamed(context, UserViewRoute, arguments: user.user.uid);
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => UserMainView(id: user.user.uid)));
        }
      } catch (error) {
        print('[DEBUG] ' + error.code);
        setState(() {
          isSuccess = false;
          switch (error.code) {
            case "wrong-password":
              errorMessage = "Your password is wrong.";
              break;
            case "user-not-found":
              errorMessage = "User with this email doesn't exist.";
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

    return Form(
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
                        var result =
                            await Navigator.pushNamed(context, ForgetViewRoute);
                        if (result != null)
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(result),
                            duration: Duration(seconds: 3),
                          ));
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
                  Container(
                    child: Column(
                      children: <Widget>[
                        Text(
                          isSuccess ? '' : errorMessage,
                          style: TextStyle(color: Colors.red),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (resendVerification) {
                              _user.sendEmailVerification();
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text("Check your mail"),
                                duration: Duration(seconds: 3),
                              ));
                            }
                          },
                          child: resendVerification
                              ? Timing(
                                  duration: 60,
                                )
                              : Text(resendVerification.toString()),
                        ),
                      ],
                    ),
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
