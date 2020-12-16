import 'dart:io';

import 'package:CoachTicketSelling/MainPage/Manager/Charts/ChartOveral.dart';
import 'package:CoachTicketSelling/MainPage/Manager/Add/OveralAddView.dart';
import 'package:CoachTicketSelling/MainPage/Manager/Manage/OveralManageView.dart';
import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:CoachTicketSelling/Utils/Route.dart';
import 'package:CoachTicketSelling/classes/Implement/BillImpl.dart';
import 'package:CoachTicketSelling/classes/Implement/DriverImpl.dart';
import 'package:CoachTicketSelling/classes/Implement/TripImpl.dart';
import 'package:CoachTicketSelling/classes/actor/Manager.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ManagerMainView extends StatefulWidget {
  @override
  _ManagerMainViewState createState() => _ManagerMainViewState();
}

class _ManagerMainViewState extends State<ManagerMainView>
    with AutomaticKeepAliveClientMixin {
  List<Icon> iconLs = <Icon>[
    Icon(Icons.show_chart),
    Icon(Icons.add),
    Icon(Icons.list_alt),
  ];

  List<String> title = ['Report', 'Add', 'Manage'];
  List<bool> bottomAppState = List<bool>.generate(3, (index) => false);
  int currentBABState = 0;

  Future notificationOnClick() async {
    // TODO: Create Route
    // await Utils.toJson(FirebaseFirestore.instance.collection('User'));
  }

  void bottomAppBarOnClick(int index) {
    if (currentBABState == index) {
      return;
    } else {
      bottomAppState[currentBABState] = false;
      currentBABState = index;
    }
    setState(() {
      bottomAppState[index] = true;
    });
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
                      DriverImpl.kill();
                      TripImplement.kill();
                      Manager.kill();
                      BillImplement.kill();
                      Navigator.of(context).pop(true);
                    },
                    child: Text('Sign out')),
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('No')),
                FlatButton(onPressed: () => exit(0), child: Text('Yes')),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    List<Widget> page = [
      OveralChartView(),
      OveralAddView(),
      OveralManageView(),
    ];

    Widget appbar = AppBar(
      elevation: currentBABState != 0 ? 0 : null,
      automaticallyImplyLeading: false,
      backgroundColor: currentBABState == 0 ? Colors.white : Utils.primaryColor,
      centerTitle: true,
      title: Text(title[currentBABState],
          style: TextStyle(
              fontSize: 20,
              color: currentBABState == 0 ? Colors.black : Colors.white)),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.all(10.0),
          child: GestureDetector(
            // Notification
            onTap: notificationOnClick,
            child: Icon(
              Icons.notifications,
              color: Colors.yellowAccent.shade700,
            ),
          ),
        ),
      ],
      leading: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, ProfileViewRoute, arguments: 'Manager');
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 15.0),
          child: FaIcon(
            FontAwesomeIcons.userCircle,
            size: 23.0,
            color: currentBABState == 0 ? Utils.primaryColor : Colors.white,
          ),
        ),
      ),
    );

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: appbar,
        body: SafeArea(
          child: IndexedStack(
            children: page,
            index: currentBABState,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Utils.primaryColor,
          currentIndex: currentBABState,
          onTap: (index) => bottomAppBarOnClick(index),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: iconLs[0], label: 'Report'),
            BottomNavigationBarItem(icon: iconLs[1], label: 'Add'),
            BottomNavigationBarItem(icon: iconLs[2], label: 'Manage'),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
