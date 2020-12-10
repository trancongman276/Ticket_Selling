import 'package:CoachTicketSelling/Utils/Route.dart';
import 'package:CoachTicketSelling/classes/Implement/DriverImpl.dart';
import 'package:CoachTicketSelling/classes/actor/Driver.dart';
import 'package:flutter/material.dart';

class ManageDriverView extends StatefulWidget {
  @override
  _ManageDriverViewState createState() => _ManageDriverViewState();
}

class _ManageDriverViewState extends State<ManageDriverView> {
  DriverImpl driverImpl = DriverImpl.instance;
  final GlobalKey<RefreshIndicatorState> _key =
      GlobalKey<RefreshIndicatorState>();
  _refresh() async {
    await setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget driverField(Driver driver) {
      double _height = 100;
      return Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
        padding: EdgeInsets.all(10.0),
        height: _height,
        child: Row(
          children: <Widget>[
            Container(
              child: Image.network(
                driver.imageUrl,
                height: _height,
                fit: BoxFit.fitHeight,
              ),
            ), //image
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(driver.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0)),
                        Text('-',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0)),
                        Text('${DateTime.now().year - driver.doB.year}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0)),
                      ],
                    ),
                    Text(driver.email),
                    Text(driver.phone),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      key: _key,
      onRefresh: () async {
        setState(() {});
      },
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Column(
              children: List.generate(driverImpl.len(), (index) {
                return FlatButton(
                  onPressed: () {
                    print('Touched $index');
                    Navigator.pushNamed(context, EditDriverViewRoute,
                            arguments:
                                driverImpl.driverList.keys.elementAt(index))
                        .then((value) {
                      setState(() {});
                    });
                  },
                  child: driverField(driverImpl
                      .driverList[driverImpl.driverList.keys.elementAt(index)]),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}