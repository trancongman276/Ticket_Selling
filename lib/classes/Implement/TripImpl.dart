import 'dart:math';

import 'package:CoachTicketSelling/classes/actor/Trip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TripImplement {
  Map<String, Trip> _tripLs = {};

  static TripImplement _instance = TripImplement._();
  static TripImplement get instance => _instance;
  TripImplement._() {
    Trip trip = Trip(
      // imageUrl:
      //     'https://pbs.twimg.com/profile_images/640666088271839233/OTKlt5pC.jpg',
      detail: '',
      totalSeat: 30,
      seat: {},
      source: 'SGN',
      destination: 'HCM',
      price: 100,
      // duration: {
      //   'Time start': Timestamp.fromDate(DateTime.now()),
      //   'Time end': Timestamp.fromDate(DateTime.now().add(Duration(hours: 5)))
      // },
      duration: {
        'Time start': DateTime.now(),
        'Time end': DateTime.now().add(Duration(hours: 5))
      },
    );

    _tripLs['1'] = trip;
    _tripLs['2'] = trip;
    _tripLs['3'] = trip;
    _tripLs['4'] = trip;
    _tripLs['5'] = trip;
    _tripLs['6'] = trip;
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
        duration: duration,
        seat: seat,
        driver: driver);
    return true;
  }

  bool add(String source, String destination, int price, int totalSeat,
      String detail, DocumentReference company) {
    _tripLs[Random.secure().nextInt(1000).toString()] = Trip(
        // imageUrl:
        //     'https://pbs.twimg.com/profile_images/640666088271839233/OTKlt5pC.jpg',
        source: source,
        destination: destination,
        price: price,
        totalSeat: totalSeat,
        detail: detail);
    return true;
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
