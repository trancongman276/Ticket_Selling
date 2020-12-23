import 'package:CoachTicketSelling/classes/actor/TripRoute.dart';

class Bill {
  final String id;
  final int cost;
  final double rate;
  final DateTime purchaseTime;
  final Map<String, DateTime> tripTime;
  final TripRoute tripRoute;
  final String companyName;
  final Map<String, dynamic> ticketLs;

  Bill(
      {this.id,
      this.tripTime,
      this.cost,
      this.rate,
      this.purchaseTime,
      this.tripRoute,
      this.companyName,
      this.ticketLs});
}
