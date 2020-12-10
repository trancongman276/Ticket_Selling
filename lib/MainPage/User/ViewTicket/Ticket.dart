import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ticket_widget/flutter_ticket_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:CoachTicketSelling/Utils/GlobalValues.dart';

// ignore: must_be_immutable
class Ticket extends StatelessWidget {
  String ticketID = 'ABC1234';
  String companyName = 'Phuong Trang';
  String source = 'Ho Chi Minh';
  String destination = 'Ho Chi Minh';
  String date = '24-12-2020';
  String nameUser = 'Mario';
  String startTime = '14:00';
  String arriveTime = '20:00';
  String duration = '6:00';
  int seat = 2;
  int price = 150000;

  @override
  Widget build(BuildContext context) {
    return FlutterTicketWidget(
        width: 330.0,
        height: 600.0,
        isCornerRounded: true,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 20, 20, 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
              Container(
                width: 140.0,
                height: 30.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(width: 1.0, color: Utils.primaryColor),
                ),
                child: Center(
                  child: Text(
                    companyName,
                    style: TextStyle(
                      color: Utils.primaryColor,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Text(
                    source,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 13.0),
                    child: Icon(
                      FontAwesomeIcons.carSide,
                      color: Utils.primaryColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      destination,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date,
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "$price VND",
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 23.0, left: 70, bottom: 20),
                child: Text(
                  'Coach Ticket',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Passenger",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Text(
                      nameUser,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Start time",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Text(
                          startTime,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Duration",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Text(
                          duration,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Arrive time",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Text(
                          arriveTime,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Seat",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Text(
                          "$seat",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Center(
                child: QrImage(
                  data: ticketID,
                  version: QrVersions.auto,
                  size: 200,
                ),
              )
            ])));
  }
}
