import 'package:CoachTicketSelling/MainPage/Manager/Charts/ChartOveral.dart';
import 'package:CoachTicketSelling/MainPage/Manager/Add/OveralAddView.dart';
import 'package:CoachTicketSelling/MainPage/Manager/Manage/OveralManageView.dart';
import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
  }

  void notificationOnClick() {
    // TODO: Create Route
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
    );

    return Scaffold(
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
