import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:CoachTicketSelling/MainPage/Manager/Manage/ManageDriverView.dart';
import 'package:CoachTicketSelling/MainPage/Manager/Manage/ManageTripView.dart';
import 'package:flutter/material.dart';

class OveralManageView extends StatefulWidget {
  @override
  _OveralManageViewState createState() => _OveralManageViewState();
}

class _OveralManageViewState extends State<OveralManageView> {
  int currentTab = 0;
  List<TextStyle> styleLs = [
    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    TextStyle(color: Colors.white.withOpacity(0.2)),
  ];
  List<Widget> tabView = [
    ManageTripView(),
    ManageDriverView(),
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
            child: IndexedStack(
              children: tabView,
              index: currentTab,
            ),
          ),
        ],
      ),
    );
  }
}
