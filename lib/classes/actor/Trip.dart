import 'package:CoachTicketSelling/classes/actor/Company.dart';
import 'package:CoachTicketSelling/classes/actor/Driver.dart';
import 'package:flutter/material.dart';

class Trip {
  String id;
  String source;
  String destination;
  String detail;
  int totalSeat;
  List<int> seat;
  Map<String, DateTime> time;
  int price;
  Driver driver;
  Company company;

  Trip(
      {@required this.id,
      this.source,
      this.destination,
      this.detail,
      this.totalSeat,
      this.seat,
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
    List<int> seat,
    Driver driver,
  }) {
    this.source = source ?? this.source;
    this.destination = destination ?? this.destination;
    this.price = price ?? this.price;
    this.totalSeat = totalSeat ?? this.totalSeat;
    this.detail = detail ?? this.detail;
    this.time = time ?? this.time;
    this.seat = seat ?? this.seat;
    if (totalSeat != null) {
      if (this.seat.length < totalSeat) {
        this.seat.addAll(
            List.generate((totalSeat - this.seat.length), (index) => 3));
      }
    }
    this.driver = driver ?? this.driver;
    return true;
  }
}
