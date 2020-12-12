import 'package:CoachTicketSelling/MainPage/User/ViewTicket/ListTicket.dart';
import 'package:CoachTicketSelling/MainPage/User/ViewTicket/Ticket.dart';
import 'package:CoachTicketSelling/Utils/Route.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'package:CoachTicketSelling/Utils/GlobalValues.dart';

class ViewTicketUI extends StatefulWidget {
  @override
  _ViewTicketUIState createState() => _ViewTicketUIState();
}

class _ViewTicketUIState extends State<ViewTicketUI> {
  double rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(
          "TICKET DETAIL",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Utils.primaryColor,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: <Widget>[
                Center(child: Ticket()),
                SizedBox(
                  height: 5,
                ),
                SmoothStarRating(
                  starCount: 5,
                  isReadOnly: false,
                  spacing: 3,
                  rating: rating,
                  size: 40,
                  color: Colors.yellowAccent[200],
                  borderColor: Colors.yellowAccent[200],
                  allowHalfRating: false,
                  onRated: (value) {
                    setState(() {
                      rating = value;
                    });
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                FlatButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: () {
                      print("$rating");
                      Navigator.popAndPushNamed(context, UserTicketViewRoute);
                    },
                    color: Utils.primaryColor,
                    textColor: Colors.white,
                    child: Text(
                      "RATING",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
