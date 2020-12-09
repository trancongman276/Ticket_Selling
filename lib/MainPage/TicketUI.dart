import 'package:flutter/material.dart';
import 'package:flutter_ticket_widget/flutter_ticket_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'PaymentUI.dart';
import 'Ticket.dart';

class TicketUI extends StatefulWidget {
  @override
  _TicketUIState createState() => _TicketUIState();
}

class _TicketUIState extends State<TicketUI> {

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.white,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  color: Colors.green,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 65),
                    child: Text (
                        "YOUR TICKETS",
                        style: TextStyle (fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                  ),
                ),
                Positioned(
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          )
                      ),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.88,
                      child: Column(
                        //tris that contain free seat
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Check your tickets",
                                style: TextStyle(fontSize: 25),
                              ),
                              Icon(FontAwesomeIcons.ticketAlt, color: Colors.black,
                                size: 30,)
                            ],
                          ),
                          SizedBox (height: 10,),
                          Container(
                              height: 500,
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Ticket(),
                                        SizedBox (height: 20,),
                                      ],
                                    );
                                  },
                                  itemCount: 2,
                              )
                          ),
                          SizedBox (height: 10,),
                          Center(
                            child: Container (
                              child: FlatButton (
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                  onPressed: () {
                                    print("Booking");
                                    Navigator.push(context, MaterialPageRoute(builder:(context) => PaymentUI()));
                                  },
                                  color: Colors.green,
                                  textColor: Colors.white,
                                  child: Text (
                                    "BOOKING",
                                    style: TextStyle (color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                                  )
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                ),
              ],
            )
          )
        ),
    );
  }
}
