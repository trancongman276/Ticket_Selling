import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:flutter/material.dart';

class TopView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: Utils.loginBackground,
                  fit: BoxFit.fill,
                )),
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 40, bottom: 10),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    )
                  ]),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 40.0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Utils.logo,
                    ),
                  ),
                ),
              ),
              Text(
                'The Car',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Fill the information bellow to login',
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
