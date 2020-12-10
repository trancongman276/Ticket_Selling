import 'package:CoachTicketSelling/MainPage/Manager/Add/AddDriverView.dart';
import 'package:CoachTicketSelling/MainPage/Manager/Add/AddTripView.dart';
import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:flutter/material.dart';

class OveralAddView extends StatefulWidget {
  @override
  _OveralAddViewState createState() => _OveralAddViewState();
}

class _OveralAddViewState extends State<OveralAddView> {
  int currentTab = 0;
  List<TextStyle> styleLs = [
    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    TextStyle(color: Colors.white.withOpacity(0.2)),
  ];
  List<Widget> tabView = [
    AddTripView(),
    AddDriverView(),
  ];

  void tripTabOnClick() {
    if (currentTab != 0)
      setState(() {
        currentTab = 0;
      });
  }

  void driverTabOnClick() {
    if (currentTab != 1)
      setState(() {
        currentTab = 1;
      });
  }

  @override
  Widget build(BuildContext context) {
    Widget tabs = Container(
      decoration: BoxDecoration(
        color: Utils.primaryColor,
        boxShadow: [
          BoxShadow(color: Colors.black38, blurRadius: 2.0, spreadRadius: 1.0)
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: FlatButton(
              child: Text('Trip',
                  style: currentTab == 0 ? styleLs[0] : styleLs[1]),
              onPressed: tripTabOnClick,
            ),
          ),
          Expanded(
            child: FlatButton(
              child: Text('Driver',
                  style: currentTab == 1 ? styleLs[0] : styleLs[1]),
              onPressed: driverTabOnClick,
            ),
          ),
        ],
      ),
    );

    return SafeArea(
      child: Column(
        children: <Widget>[
          tabs,
          Expanded(
            child: SingleChildScrollView(
              child: IndexedStack(
                children: tabView,
                index: currentTab,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
