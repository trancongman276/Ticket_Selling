import 'package:CoachTicketSelling/MainPage/User/DetailTicket.dart';
import 'package:CoachTicketSelling/Utils/Route.dart';
import 'package:CoachTicketSelling/classes/Implement/TicketImpl.dart';
import 'package:CoachTicketSelling/classes/actor/AppUser.dart';
import 'package:CoachTicketSelling/classes/actor/Ticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ticket_widget/flutter_ticket_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'package:CoachTicketSelling/Utils/GlobalValues.dart';

class DetailTicketUI extends StatefulWidget {
  final int ticketIndex;

  const DetailTicketUI({Key key, this.ticketIndex}) : super(key: key);
  @override
  _DetailTicketUIState createState() => _DetailTicketUIState(ticketIndex);
}

class _DetailTicketUIState extends State<DetailTicketUI> {
  final int ticketIdx;
  int rating;
  UserTicket ticket;
  _DetailTicketUIState(this.ticketIdx) {
    ticket = TicketImpl.instance.ticketLs[ticketIdx];
    rating = ticket.rate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                Center(
                    child: DetailTicket(
                  ticket: ticket,
                  name: AppUser.instance.name,
                )),
                SizedBox(
                  height: 5,
                ),
                SmoothStarRating(
                  starCount: 5,
                  isReadOnly: false,
                  spacing: 3,
                  rating: rating.toDouble(),
                  size: 40,
                  color: Colors.yellowAccent[200],
                  borderColor: Colors.yellowAccent[200],
                  allowHalfRating: false,
                  onRated: (value) {
                    setState(() {
                      rating = value.toInt();
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
                      ticket.updateRate(rating);
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
