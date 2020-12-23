import 'dart:io';

import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:CoachTicketSelling/Utils/Route.dart';
import 'package:CoachTicketSelling/classes/Implement/RouteImpl.dart';
import 'package:CoachTicketSelling/classes/Implement/TicketImpl.dart';
import 'package:CoachTicketSelling/classes/Implement/TripImpl.dart';
import 'package:CoachTicketSelling/classes/actor/AppUser.dart';
import 'package:CoachTicketSelling/classes/actor/Ticket.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListTicket extends StatefulWidget {
  @override
  _ListTicketState createState() => _ListTicketState();
}

class _ListTicketState extends State<ListTicket> {
  int currentIndex = 2;

  // String source = 'Ho Chi Minh';
  // String destination = 'Da Nang';
  // String date = '2020 - 03 - 06';
  // String timeStart = "14:00";
  // String timeEnd = "20:00";
  // String company = "Phuong Trang";
  // int rate = 0;
  // int result = 15;
  // int price = 150000;
  // String imageLink =
  //     'assets/images/logo.png'; //Create class to set link image corresponding to Company logo
  final GlobalKey<RefreshIndicatorState> _key =
      GlobalKey<RefreshIndicatorState>();

  List<UserTicket> ticketLs;

  _ListTicketState() {
    ticketLs = TicketImpl.instance.ticketLs;
  }

  Future _refresh() async {
    TicketImpl.instance.init();
    setState(() {
      ticketLs = TicketImpl.instance.ticketLs;
    });
    return Future.value(true);
  }

  Future<bool> _onWillPop() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Exit - Sign Out'),
              content: Text('Do you want to close app? Or maybe Sign out?'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () async {
                      await Utils.logout();
                      AppUser.kill();
                      TripImplement.kill();
                      RouteImpl.kill();
                      Navigator.pushNamed(context, LoginViewRoute);
                    },
                    child: Text('Sign out')),
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('No')),
                FlatButton(onPressed: () => exit(0), child: Text('Yes')),
              ],
            ));
  }

  Widget _bookingItem(
    int index,
    String source,
    String destination,
    int rate,
    DateTime timeStart,
    DateTime timeEnd,
    String company,
    int seatNum,
    // int price,
    // String imageLink,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, UserDetailTicketViewRoute,
            arguments: index);
      },
      child: Container(
        width: 500,
        height: 200,
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Container(
                //   height: 30,
                //   width: 30,
                //   child: Image.asset(
                //     imageLink,
                //     fit: BoxFit.fill,
                //   ),
                // ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  company,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 25,
                ),
                //Icon (FontAwesomeIcons.coins, size: 20,),
                // SizedBox(
                //   width: 5,
                // ),
                // Text(
                //   "$price VND",
                //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                // )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '${timeStart.day} - ${timeStart.month} - ${timeStart.year}',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  "Seat num: $seatNum",
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  source,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Column(
                  children: [
                    _iconDestination(),
                  ],
                ),
                Text(
                  destination,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${timeStart.hour}:${timeStart.minute}',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${timeEnd.hour}:${timeEnd.minute}',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            _rating(rate)
          ],
        ),
      ),
    );
  }

  Widget _iconDestination() {
    return Container(
      child: Row(
        children: <Widget>[
          Icon(
            Icons.directions_car,
            color: Utils.primaryColor,
            size: 20,
          ),
          Icon(
            Icons.fiber_manual_record,
            color: Utils.primaryColor,
            size: 9,
          ),
          Icon(
            Icons.fiber_manual_record,
            color: Utils.primaryColor,
            size: 9,
          ),
          Icon(
            Icons.fiber_manual_record,
            color: Utils.primaryColor,
            size: 9,
          ),
          Icon(
            Icons.fiber_manual_record,
            color: Color(0xFFFf89380),
            size: 9,
          ),
          Icon(
            Icons.fiber_manual_record,
            color: Color(0xFFFf89380),
            size: 9,
          ),
          Icon(
            Icons.fiber_manual_record,
            color: Color(0xFFFf89380),
            size: 9,
          ),
          Icon(
            Icons.location_on,
            color: Color(0xFFFf89380),
            size: 20,
          )
        ],
      ),
    );
  }

  Widget _rating(int a) {
    int b = 5 - a.toInt();
    if (a == 0)
      return Center(
        child: Text(
          "Please rate me ≧ ﹏ ≦",
          style: TextStyle(fontSize: 20, color: Colors.redAccent),
        ),
      );
    return Container(
      height: 20,
      child: Row(
        children: [
          ListView.builder(
              shrinkWrap: true,
              itemCount: a.toInt(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Row(
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 30,
                    )
                  ],
                );
              }),
          ListView.builder(
            shrinkWrap: true,
            itemCount: b,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Row(
                children: <Widget>[
                  Icon(
                    Icons.star_border,
                    color: Colors.yellow,
                    size: 30,
                  )
                ],
              );
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Utils.primaryColor,
        body: SingleChildScrollView(
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
                      "BASKET TICKETS",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.white),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        )),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.87,
                    child: Column(
                      //tris that contain free seat
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "${ticketLs.length} Tickets",
                              style: TextStyle(fontSize: 25),
                            ),
                            Icon(
                              FontAwesomeIcons.list,
                              color: Colors.black,
                              size: 25,
                            )
                          ],
                        ),
                        SizedBox(height: 30),
                        Expanded(
                          child: RefreshIndicator(
                            key: _key,
                            onRefresh: _refresh,
                            child: Container(
                                child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: ticketLs.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: <Widget>[
                                    _bookingItem(
                                      index,
                                      ticketLs[index].source,
                                      ticketLs[index].dest,
                                      ticketLs[index].rate,
                                      ticketLs[index].time['Start Time'],
                                      ticketLs[index].time['Finish Time'],
                                      ticketLs[index].companyName,
                                      ticketLs[index].seatID,
                                      // ticketLs[index].company.imageUrl,
                                      context,
                                    ),
                                    //Create a class that use ID to query this information : db.string(id)
                                    SizedBox(
                                      height: 20,
                                    )
                                  ],
                                );
                              },
                            )),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: currentIndex,
          onItemSelected: (index) {
            setState(() {
              currentIndex = index;
              if (currentIndex == 1) {
                Navigator.popAndPushNamed(context, UserViewRoute);
              }
              if (currentIndex == 0) {
                Navigator.popAndPushNamed(context, UserProfileViewRoute);
              }
              currentIndex = 2;
            });
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
              icon: Icon(
                Icons.person,
                size: 30,
              ),
              title: Text(
                'Profile',
                style: TextStyle(fontSize: 18),
              ),
              activeColor: Utils.primaryColor,
              inactiveColor: Colors.black,
            ),
            BottomNavyBarItem(
              icon: Icon(
                Icons.search,
                size: 30,
              ),
              title: Text(
                'Search',
                style: TextStyle(fontSize: 18),
              ),
              activeColor: Utils.primaryColor,
              inactiveColor: Colors.black,
            ),
            BottomNavyBarItem(
              icon: Icon(
                FontAwesomeIcons.ticketAlt,
                size: 27,
              ),
              title: Text(
                ' Ticket',
                style: TextStyle(fontSize: 18),
              ),
              activeColor: Utils.primaryColor,
              inactiveColor: Colors.black,
            ),
            BottomNavyBarItem(
              icon: Icon(
                Icons.settings,
                size: 30,
              ),
              title: Text(
                'Setting',
                style: TextStyle(fontSize: 18),
              ),
              activeColor: Utils.primaryColor,
              inactiveColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
