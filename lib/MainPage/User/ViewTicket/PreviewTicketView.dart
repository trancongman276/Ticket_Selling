import 'package:CoachTicketSelling/MainPage/User/DetailTicket.dart';
import 'package:CoachTicketSelling/Utils/Route.dart';
import 'package:CoachTicketSelling/classes/actor/AppUser.dart';
import 'package:CoachTicketSelling/classes/actor/Ticket.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:CoachTicketSelling/Utils/GlobalValues.dart';

class PreviewTicketView extends StatefulWidget {
  final Map<String, dynamic> checkOutDetail;

  const PreviewTicketView({Key key, this.checkOutDetail}) : super(key: key);
  @override
  _PreviewTicketViewState createState() =>
      _PreviewTicketViewState(checkOutDetail);
}

class _PreviewTicketViewState extends State<PreviewTicketView> {
  final Map<String, dynamic> checkOutDetail;

  _PreviewTicketViewState(this.checkOutDetail) {
    print(checkOutDetail);
    source = checkOutDetail['Trip'].source;
    dest = checkOutDetail['Trip'].destination;
    time = checkOutDetail['Trip'].time;
    companyName = checkOutDetail['Trip'].company.name;
  }

  String source;
  String dest;
  Map<String, DateTime> time;
  String companyName;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Utils.primaryColor,
      child: SingleChildScrollView(
          child: SafeArea(
              child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            color: Utils.primaryColor,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                "YOUR TICKETS",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
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
                    )),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.88,
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
                        Icon(
                          FontAwesomeIcons.ticketAlt,
                          color: Colors.black,
                          size: 30,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        height: 500,
                        child: ListView.builder(
                          itemCount: checkOutDetail['Choosing Seat'].length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                DetailTicket(
                                    ticket: UserTicket(
                                        seatID: checkOutDetail['Choosing Seat']
                                            [index],
                                        source: source,
                                        dest: dest,
                                        time: time,
                                        companyName: companyName),
                                    name: AppUser.instance.name),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            );
                          },
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Container(
                        child: FlatButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            onPressed: () {
                              Navigator.pushNamed(context, UserPaymentViewRoute,
                                  arguments: checkOutDetail);
                            },
                            color: Utils.primaryColor,
                            textColor: Colors.white,
                            child: Text(
                              "BOOKING",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    )
                  ],
                ),
              )),
        ],
      ))),
    );
  }
}
