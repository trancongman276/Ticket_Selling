import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  String imageUrl;
  String detail;
  int totalSeat;
  Map<String, bool> seat;
  String source;
  String destination;
  DateTime time;
  int duration;
  int price;
  DocumentReference driver;

  Trip({
    this.imageUrl,
    this.detail,
    this.totalSeat,
    this.seat,
    this.source,
    this.destination,
    this.duration,
    this.time,
    this.price,
    this.driver,
  });
}
