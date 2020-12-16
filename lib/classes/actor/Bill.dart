import 'package:CoachTicketSelling/classes/TripRoute.dart';

class Bill {
  final int cost;
  final double rate;
  final TripRoute tripRoute;
  final DateTime time;

  Bill({this.tripRoute, this.cost, this.rate, this.time});
}
