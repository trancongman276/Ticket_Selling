import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:CoachTicketSelling/classes/Implement/TripImpl.dart';
import 'package:CoachTicketSelling/classes/actor/Trip.dart';
import 'package:flutter/material.dart';
import 'package:CoachTicketSelling/MainPage/Manager/Add/AddTripView.dart';

class EditTripView extends StatefulWidget {
  final String tripID;

  const EditTripView({Key key, this.tripID}) : super(key: key);
  @override
  _EditTripViewState createState() => _EditTripViewState(tripID);
}

class _EditTripViewState extends State<EditTripView> {
  final String tripID;
  _EditTripViewState(this.tripID);

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
              child: AddTripView(tripID: tripID),
            )
          ],
        ));
  }
}
