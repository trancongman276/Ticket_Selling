import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  String detail;
  int totalSeat;
  Map<String, bool> seat;
  String source;
  String destination;
  Map<String, DateTime> duration;
  int price;
  DocumentReference driver;

  Trip({
    this.detail,
    this.totalSeat,
    this.seat,
    this.source,
    this.destination,
    this.duration,
    this.price,
    this.driver,
  });

  bool update(
      {String source,
      String destination,
      int price,
      int totalSeat,
      String detail,
      Map<String, DateTime> duration,
      Map<String, bool> seat,
      DocumentReference driver}) {
    this.source = source ?? this.source;
    this.destination = destination ?? this.destination;
    this.price = price ?? this.price;
    this.totalSeat = totalSeat ?? this.totalSeat;
    this.detail = detail ?? this.detail;
    this.duration = duration ?? this.duration;
    this.seat = seat ?? this.seat;
    this.driver = driver ?? this.driver;
    return true;
  }
}
