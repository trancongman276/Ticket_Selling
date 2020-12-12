import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  String detail;
  int totalSeat;
  Map<String, bool> seat;
  String source;
  String destination;
  Map<String, DateTime> time;
  int price;
  DocumentReference driver;
  DocumentReference company;

  Trip(
      {this.detail,
      this.totalSeat,
      this.seat,
      this.source,
      this.destination,
      this.time,
      this.price,
      this.driver,
      this.company});

  bool update({
    String source,
    String destination,
    int price,
    int totalSeat,
    String detail,
    Map<String, DateTime> time,
    Map<String, bool> seat,
    DocumentReference driver,
  }) {
    this.source = source ?? this.source;
    this.destination = destination ?? this.destination;
    this.price = price ?? this.price;
    this.totalSeat = totalSeat ?? this.totalSeat;
    this.detail = detail ?? this.detail;
    this.time = time ?? this.time;
    this.seat = seat ?? this.seat;
    this.driver = driver ?? this.driver;
    return true;
  }
}
