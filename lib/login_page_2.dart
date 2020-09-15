import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class loginPage2 extends StatefulWidget {
  @override
  _loginPage2State createState() => _loginPage2State();
}

class _loginPage2State extends State<loginPage2> {
  @override
  Widget build(BuildContext context) {

    final username = Padding(
      padding: EdgeInsets.only(),
      child: TextField(
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: 'Username',
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green,
              width: 1.5,
            ),
          ),
        ),
      ),
    );

    final password = Padding(
      padding: EdgeInsets.only(),
      child: TextField(
        obscureText: true,
        // style: TextStyle(color: Colors.black,),
        decoration: InputDecoration(
          hintText: 'Password',
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green,
              width: 1.5,
            ),
          ),
        ),
      ),
    );

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
                  padding: EdgeInsets.symmetric( horizontal: 100, vertical: 0),
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(30),
                  //   color: Colors.black,
                  // ),
                ),
                // SizedBox(height: 145,),

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
                        // offset: Offset(0,3),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0)
                ),

                child: Center(
                    child: Column(
                      children: <Widget>[
                        // SizedBox(height: 20,),
                        // Container(
                        //   alignment: Alignment.centerLeft,
                        //     child: Text('Username',
                        //       style: TextStyle(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.bold),)
                        // ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text('Login Account',
                            style: TextStyle(fontSize: 20, color: Colors.black),),
                        ),

                        username,
                        SizedBox(height: 20,),
                        // Container(
                        //   alignment: Alignment.center,
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text('Password',
                        //         style: TextStyle(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.bold),),
                        //       FlatButton(
                        //         onPressed: (){},
                        //         child: Text('Forgot?',
                        //             style: TextStyle(color: Color(0xff27ae60), fontSize: 15, fontWeight: FontWeight.bold)),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        password,
                        Container(
                          alignment: Alignment.topRight,
                          child: FlatButton(
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
                          children: [
                            IconButton(
                              onPressed: (){},
                              icon: FaIcon(FontAwesomeIcons.facebook),
                              color: Color(0xff2ecc71),
                            ),
                            IconButton(
                              onPressed: (){},
                              icon: FaIcon(FontAwesomeIcons.twitter),
                              color: Color(0xff2ecc71),
                            ),
                            IconButton(
                              onPressed: (){},
                              icon: FaIcon(FontAwesomeIcons.google),
                              color: Color(0xff2ecc71),
                            ),
                          ],
                        ),
                     ],
                    )
                )
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
                  onPressed: () {  },
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
      // backgroundColor: Color(0xff2ecc71),
      body: loginForm,
    );
  }
}
