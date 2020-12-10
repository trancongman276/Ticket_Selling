import 'package:CoachTicketSelling/MainPage/Manager/Add/AddDriverView.dart';
import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:flutter/material.dart';

class EditDriverView extends StatefulWidget {
  final String driverID;

  const EditDriverView({Key key, this.driverID}) : super(key: key);
  @override
  _EditDriverViewState createState() => _EditDriverViewState(driverID);
}

class _EditDriverViewState extends State<EditDriverView> {
  final String driverID;
  _EditDriverViewState(this.driverID);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit'),
          centerTitle: true,
          backgroundColor: Utils.primaryColor,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: AddDriverView(
                  driverID: driverID,
                ),
              ),
            )
          ],
        ));
  }
}
