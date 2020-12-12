import 'dart:math';

import 'package:CoachTicketSelling/classes/Implement/DriverImpl.dart';
import 'package:CoachTicketSelling/classes/actor/Driver.dart';
import 'package:CoachTicketSelling/classes/actor/Trip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TripImplement {
  Map<String, Trip> _tripLs = {};

  static TripImplement _instance = TripImplement._();
  static TripImplement get instance => _instance;
  TripImplement._();

  Future<bool> init() async {
    DriverImpl.instance.init();
    await FirebaseFirestore.instance.collection('Trip').get().then((query) {
      query.docs.forEach((doc) {
        Map<String, dynamic> tempMap = doc.data()['Time'];
        Map<String, DateTime> time = {};
        tempMap.forEach((key, value) {
          time[key] = DateTime.parse(value.toDate().toString());
        });

        _tripLs[doc.id] = Trip(
          source: doc.data()['Source'],
          destination: doc.data()['Destination'],
          price: doc.data()['Price'],
          totalSeat: doc.data()['Total Seat'],
          seat: Map<String, bool>.from(doc.data()['Seat']),
          detail: doc.data()['Detail'],
          time: time,
          driver: doc.data()['Driver'],
        );
      });
    });
    return Future.value(true);
  }

  bool update(String id,
      {String source,
      String destination,
      int price,
      int totalSeat,
      String detail,
      Map<String, DateTime> duration,
      Map<String, bool> seat,
      DocumentReference driver}) {
    _tripLs[id].update(
        source: source,
        destination: destination,
        price: price,
        totalSeat: totalSeat,
        detail: detail,
        time: duration,
        seat: seat,
        driver: driver);
    return true;
  }

  Future<bool> add(
      String source,
      String destination,
      int price,
      int totalSeat,
      DocumentReference driver,
      String detail,
      DocumentReference company) async {
    String id;
    await FirebaseFirestore.instance.collection('Trip').add({
      'Source': source,
      'Destination': destination,
      'Price': price,
      'Total Seat': totalSeat,
      'Seat': Map<String, bool>.identity(),
      'Driver': driver,
      'Company': company,
      'Detail': detail,
    }).then((value) => id = value.id);
    _tripLs[id] = Trip(
      source: source,
      destination: destination,
      price: price,
      totalSeat: totalSeat,
      detail: detail,
      driver: driver,
      company: company,
    );
    return Future.value(true);
  }

  bool delete(String tripID) {
    _tripLs.remove(tripID);
    return true;
  }

  Trip getTrip(String id) {
    return _tripLs[id];
  }

  Map get tripList => _tripLs;
}
