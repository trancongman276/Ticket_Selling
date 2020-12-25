import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:CoachTicketSelling/classes/actor/Ticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ticket_widget/flutter_ticket_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DetailTicket extends StatelessWidget {
  final UserTicket ticket;
  final String name;

  const DetailTicket({Key key, this.ticket, this.name}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlutterTicketWidget(
        width: 330.0,
        height: 600.0,
        isCornerRounded: true,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    border: Border.all(width: 1.0, color: Utils.primaryColor),
                  ),
                  child: Center(
                    child: Text(
                      ticket.companyName,
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      ticket.source,
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
                        ticket.dest,
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '${ticket.time['Start Time'].day}' +
                          '/${ticket.time['Start Time'].month}' +
                          '/${ticket.time['Start Time'].year}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      '${ticket.time['Finish Time'].day}' +
                          '/${ticket.time['Finish Time'].month}' +
                          '/${ticket.time['Finish Time'].year}',
                      style: TextStyle(fontSize: 18),
                    ),
                    // Text(
                    //   "$price VND",
                    //   style: TextStyle(fontSize: 18),
                    // )
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 23.0, left: 70, bottom: 20),
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
                        this.name,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Start time",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          Text(
                            '${ticket.time['Start Time'].hour < 10 ? '0' + ticket.time['Start Time'].hour.toString() : ticket.time['Start Time'].hour}' +
                                ':${ticket.time['Start Time'].minute < 10 ? '0' + ticket.time['Start Time'].minute.toString() : ticket.time['Start Time'].minute}',
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
                            '${ticket.time['Finish Time'].difference(ticket.time['Start Time']).inHours} hours',
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
                            '${ticket.time['Finish Time'].hour < 10 ? '0' + ticket.time['Finish Time'].hour.toString() : ticket.time['Finish Time'].hour}' +
                                ':${ticket.time['Finish Time'].minute < 10 ? '0' + ticket.time['Finish Time'].minute.toString() : ticket.time['Finish Time'].minute}',
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
                            "${ticket.seatID}",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                if (ticket.id != null)
                  Center(
                    child: QrImage(
                      data: ticket.id,
                      version: QrVersions.auto,
                      size: 200,
                    ),
                  )
              ],
            )));
  }
}
