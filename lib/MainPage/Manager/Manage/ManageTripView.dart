import 'package:CoachTicketSelling/Utils/Route.dart';
import 'package:CoachTicketSelling/classes/Implement/TripImpl.dart';
import 'package:CoachTicketSelling/classes/actor/Trip.dart';
import 'package:flutter/material.dart';

class ManageTripView extends StatefulWidget {
  @override
  _ManageTripViewState createState() => _ManageTripViewState();
}

class _ManageTripViewState extends State<ManageTripView> {
  final GlobalKey<RefreshIndicatorState> _key =
      GlobalKey<RefreshIndicatorState>();

  Widget tripField(Trip trip) {
    double _height = 100;
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      padding: EdgeInsets.all(10.0),
      height: _height,
      child: Row(
        children: <Widget>[
          // Container(
          //   child: Image.network(
          //     trip.imageUrl,
          //     height: _height,
          //     fit: BoxFit.fitHeight,
          //   ),
          // ), //image
          Expanded(
            child: Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(trip.source,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0)),
                            Text('15:00'),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Icon(Icons.arrow_forward_rounded),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(trip.destination,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0)),
                            Text('21:00'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Seat: ${trip.totalSeat}',
                          style: TextStyle(fontSize: 20.0)),
                      Text(
                        '\$${trip.price}',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, bool> map;
  TripImplement tripImplement = TripImplement.instance;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _key,
      onRefresh: () async {
        setState(() {});
      },
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Column(
              children: List.generate(tripImplement.tripList.length, (index) {
                return FlatButton(
                  onPressed: () {
                    print('Touched $index');
                    Navigator.pushNamed(context, EditTripViewRoute,
                            arguments:
                                tripImplement.tripList.keys.elementAt(index))
                        .then((value) {
                      setState(() {});
                    });
                  },
                  child: tripField(tripImplement
                      .tripList[tripImplement.tripList.keys.elementAt(index)]),
                );
              }),
              // (context, index) {
              //   return FlatButton(
              //     onPressed: () {
              //       print('Touched $index');
              //       Navigator.pushNamed(context, EditTripViewRoute);
              //     },
              //     child: tripField(trip),
              //   );
              // },
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
