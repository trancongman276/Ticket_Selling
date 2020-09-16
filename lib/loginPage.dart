import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'Module/FirstPage/inputTb.dart';

class loginPage extends StatefulWidget {
  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  @override
  Widget build(BuildContext context) {

    var creator = borderLessInputTb();

    final username = creator.textbox('Username', null, false, Colors.green, 1.5);
    final password = creator.textbox('Password', null, true, Colors.green, 1.5);
    final otherLoginMethod = [
      IconButton(
        onPressed: (){print('Sign In Facebook bt pressed!');},
        icon: FaIcon(FontAwesomeIcons.facebook),
        color: Color(0xff2ecc71),
      ),
      IconButton(
        onPressed: (){ print('Sign In Twitter bt pressed!'); },
        icon: FaIcon(FontAwesomeIcons.twitter),
        color: Color(0xff2ecc71),
      ),
      IconButton(
        onPressed: (){ print('Sign In with Google bt pressed!'); },
        icon: FaIcon(FontAwesomeIcons.google),
        color: Color(0xff2ecc71),
      ),
    ];
    final loginForm = Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/loginBG.png'),
          fit: BoxFit.cover,
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Container(//TOP
            child: Column(
              children: <Widget>[
                Container(
                  child: Center(
                    child: Image.asset('assets/images/logo.png'),
                  ),
                  padding: EdgeInsets.symmetric( horizontal: 130, vertical: 0),
                ),
                Text('Fill the information bellow to login',
                  style: TextStyle(color: Colors.white),),
              ],
            )
          ),

          Container( //BODY
            child: Container(
                margin: EdgeInsets.all(40),
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20 ),
                decoration: BoxDecoration(
                  boxShadow:[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0,3),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0)
                ),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text('Login Account',
                            style: TextStyle(fontSize: 20, color: Colors.black),),
                        ),
                        username,
                        SizedBox(height: 20,),
                        password,
                        Container(
                          alignment: Alignment.topRight,
                          child: FlatButton(
                            onPressed: (){print('Forgot bt pressed!');},
                            child: Text('Forgot?', style: TextStyle(color: Colors.green),),
                          ),
                        ),
                        // SizedBox(height: 10,),
                        RaisedButton(
                            onPressed: () => print("Button Pressed") ,
                            color: Color(0xff27ae60),
                            child: Text('LOG IN',
                              style: TextStyle( color: Colors.white),),
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 80),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)
                            )
                        ),
                        Container(
                          child: Text('Or'),
                          padding: EdgeInsets.only(top:20, bottom: 5),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: otherLoginMethod,
                        ),
                     ],
                    )
                ),
            ),
          ),

          Container(
            padding: EdgeInsets.only(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Don't have account?",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),),
                FlatButton(
                  onPressed: () { print('Sign Up bt pressed!'); },
                  child: Text('Sign Up',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xff2ecc71)),),
                ),
              ],
            )
          ),
        ],
      )
    );

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        child: loginForm
      ),
    );
  }
}
