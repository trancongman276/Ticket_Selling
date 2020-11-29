import 'package:CoachTicketSelling/LoginPage/forgetView.dart';
import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BodyView extends StatefulWidget {
  final GlobalKey<FormState> formkey;

  const BodyView({Key key, @required this.formkey}) : super(key: key);

  @override
  _BodyViewState createState() => _BodyViewState(formkey);
}

class _BodyViewState extends State<BodyView> {
  final GlobalKey<FormState> _formkey;
  bool isSuccess = true;
  String errorMessage;

  _BodyViewState(this._formkey);

  @override
  Widget build(BuildContext context) {
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
          print('Sign In Facebook bt pressed!');
        },
        icon: FaIcon(FontAwesomeIcons.facebook),
        color: Utils.primaryColor,
      ), // Facebook
      IconButton(
        onPressed: () {
          print('Sign In Twitter bt pressed!');
        },
        icon: FaIcon(FontAwesomeIcons.twitter),
        color: Utils.primaryColor,
      ), // Twitter
      IconButton(
        onPressed: () {
          print('Sign In with Google bt pressed!');
        },
        icon: FaIcon(FontAwesomeIcons.google),
        color: Utils.primaryColor,
      ), // Google
    ];

    void login() async {
      //Todo: Login
      try {
        await Utils.firebaseAuth.signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
      } catch (error) {
        print(error.code);
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            // Body
            margin: EdgeInsets.all(40),
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ], color: Colors.white, borderRadius: BorderRadius.circular(30.0)),
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
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgetPasswordView()));
                      print('Forgot bt pressed!');
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Please check your email'),
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
                      print('Logined');
                    },
                    color: Utils.primaryColor,
                    child: Text(
                      'LOG IN',
                      style: TextStyle(color: Colors.white),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 80),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
                Container(
                  child: Text(
                    isSuccess ? '' : errorMessage,
                    style: TextStyle(color: Colors.red),
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
    );
  }
}
