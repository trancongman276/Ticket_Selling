import 'dart:io';

import 'package:CoachTicketSelling/MainPage/ProfileView.dart';
import 'package:CoachTicketSelling/MainPage/User/BookTrip/RecommendationItem.dart';
import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:CoachTicketSelling/Utils/Route.dart';
import 'package:CoachTicketSelling/classes/Implement/RouteImpl.dart';
import 'package:CoachTicketSelling/classes/Implement/TripImpl.dart';
import 'package:CoachTicketSelling/classes/actor/AppUser.dart';
import 'package:CoachTicketSelling/classes/actor/Trip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserUI extends StatefulWidget {
  @override
  _UserUIState createState() => _UserUIState();
}

class _UserUIState extends State<UserUI> {
  _UserUIState() {
    _dateController.text = "yyyy-mm-dd";
    _refresh();
  }
  bool isInit = false;
  _refresh() {
    _source = RouteImpl.instance.routeLs.keys.toList();
    if (_source.isNotEmpty) {
      isInit = true;
      _sourceValue = _source[0];
      _destination = RouteImpl.instance.routeLs[_sourceValue];
      _desValue = _destination[0];
    }
  }

  List<String> _source = ['Source'];
  String _sourceValue = 'Source';

  List<String> _destination = ['Destination'];
  String _desValue = 'Destination';

  final TextEditingController _dateController = TextEditingController();
  DateTime date;

  int currentIndex = 1;

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

  bool checkAndNavigate() {
    if ((_sourceValue != 'Source') &
        (_desValue != 'Destination') &
        (_dateController.text != 'yyyy-mm-dd')) {
      var tripLs =
          TripImplement.instance.findTrip(_sourceValue, _desValue, date);

      Navigator.pushNamed(context, UserFindTripViewRoute,
          arguments: tripLs.isNotEmpty
              ? tripLs
              : [
                  Trip(
                      id: null,
                      source: _sourceValue,
                      destination: _desValue,
                      time: Map<String, DateTime>.from({'Start Time': date}))
                ]);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Color(0xFFE8F5E9),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Container(
                        alignment: AlignmentDirectional.center,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _iconDestination(),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(30, 10, 0, 0),
                                    child: Text(
                                      "Source",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(30, 0, 0, 10),
                                    child: Container(
                                      width: 250,
                                      //color: Colors.blue,
                                      child: DropdownButton(
                                        hint: Text("Select Source"),
                                        isExpanded: true,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                        value: _sourceValue,
                                        onTap: () {
                                          if (!isInit) {
                                            setState(() => _refresh());
                                          }
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            _sourceValue = value;
                                            _destination = RouteImpl
                                                .instance.routeLs[_sourceValue];
                                            _desValue = _destination[0];
                                          });
                                        },
                                        items: _source.map((value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                    child: Text(
                                      "Destination",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(30, 0, 0, 10),
                                    child: Container(
                                      width: 250,
                                      child: DropdownButton(
                                        hint: Text("Select Destination"),
                                        isExpanded: true,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                        value: _desValue,
                                        onTap: () {
                                          if (!isInit) {
                                            setState(() => _refresh());
                                          }
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            _desValue = value;
                                          });
                                        },
                                        items: _destination.map((value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Container(
                          alignment: AlignmentDirectional.center,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          width: 240,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: IconButton(
                                  onPressed: () async {
                                    date = await showRoundedDatePicker(
                                        context: context,
                                        firstDate: DateTime.now(),
                                        borderRadius: 16,
                                        theme: ThemeData(
                                            primarySwatch: Colors.green));
                                    date != null
                                        ? _dateController.text =
                                            date.toString().substring(0, 10)
                                        // ignore: unnecessary_statements
                                        : Null;
                                  },
                                  icon: Icon(Icons.calendar_today),
                                  color: Utils.primaryColor.withBlue(10),
                                  iconSize: 30,
                                ),
                              ),
                              Container(
                                width: 100,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 10, 0, 0),
                                      child: Text(
                                        "DATE",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: TextFormField(
                                        validator: Utils.validateEmpty,
                                        decoration: InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Utils.primaryColor,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                        controller: _dateController,
                                        readOnly: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                            child: GestureDetector(
                              child: Icon(Icons.search,
                                  size: 70, color: Utils.primaryColor),
                              onTap: () {
                                checkAndNavigate();
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 10, 0),
                            child: Text(
                              "SEARCH",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.grey),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: Text(
                          "Recommended for you",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                      Container(
                        height: 250,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            RecommendationItem(
                              origin: 'Ha Noi',
                              destination: 'Khanh Hoa',
                              price: '150000',
                              color: Colors.deepOrange[300],
                              date: '2020-12-06',
                            ),
                            RecommendationItem(
                              origin: 'Ha Noi',
                              destination: 'Ho Chi Minh',
                              price: '200000',
                              color: Utils.primaryColor,
                              date: '2020-10-20',
                            ),
                            RecommendationItem(
                              origin: 'Ho Chi Minh',
                              destination: 'Da Nang',
                              price: '190000',
                              color: Colors.amberAccent[700],
                              date: '2020-12-06',
                            ),
                            RecommendationItem(
                              origin: 'Da Nang',
                              destination: 'Ho Chi Minh',
                              price: '2500000',
                              color: Colors.deepOrange[400],
                              date: '2020-12-25',
                            ),
                            RecommendationItem(
                              origin: 'Hue',
                              destination: 'Ho Chi Minh',
                              price: '300000',
                              color: Colors.lightGreen[600],
                              date: '2020-3-9',
                            ),
                            RecommendationItem(
                              origin: 'Hue',
                              destination: 'Da Nang',
                              price: '350000',
                              color: Colors.amber[600],
                              date: '2020-3-9',
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                  //Todo_next
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: currentIndex,
          onItemSelected: (index) {
            setState(() {
              currentIndex = index;
              if (currentIndex == 0) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Profile(role: 'User')));
              }
              if (currentIndex == 2) {
                Navigator.popAndPushNamed(context, UserTicketViewRoute);
              }
              currentIndex = 1;
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
                'Ticket',
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

  bool get wantKeepAlive => true;
}

Widget _iconDestination() {
  return Container(
    child: Column(
      children: <Widget>[
        Icon(
          Icons.directions_car,
          color: Utils.primaryColor,
          size: 30,
        ),
        Icon(
          Icons.fiber_manual_record,
          color: Utils.primaryColor,
          size: 12,
        ),
        Icon(
          Icons.fiber_manual_record,
          color: Utils.primaryColor,
          size: 12,
        ),
        Icon(
          Icons.fiber_manual_record,
          color: Utils.primaryColor,
          size: 12,
        ),
        Icon(
          Icons.fiber_manual_record,
          color: Utils.primaryColor,
          size: 12,
        ),
        Icon(
          Icons.fiber_manual_record,
          color: Utils.primaryColor,
          size: 12,
        ),
        Icon(
          Icons.fiber_manual_record,
          color: Color(0xFFFf89380),
          size: 12,
        ),
        Icon(
          Icons.fiber_manual_record,
          color: Color(0xFFFf89380),
          size: 12,
        ),
        Icon(
          Icons.fiber_manual_record,
          color: Color(0xFFFf89380),
          size: 12,
        ),
        Icon(
          Icons.location_on,
          color: Color(0xFFFf89380),
          size: 30,
        )
      ],
    ),
  );
}
