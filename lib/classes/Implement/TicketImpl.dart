import 'package:CoachTicketSelling/classes/actor/AppUser.dart';
import 'package:CoachTicketSelling/classes/actor/Ticket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TicketImpl {
  TicketImpl._();
  static TicketImpl _instance = TicketImpl._();
  static TicketImpl get instance => _instance;
  static bool kill() {
    _instance = TicketImpl._();
    return true;
  }

  List<UserTicket> ticketLs = [];

  bool init() {
    ticketLs = [];
    AppUser.instance.billLs.values.forEach((bill) {
      Map<String, dynamic> tickets = bill['Ticket'];
      tickets.forEach((key, value) {
        this.ticketLs.add(UserTicket(
            id: key,
            seatID: value['SeatID'],
            rate: value['Rate'].toInt(),
            source: bill['Source'],
            dest: bill['Destination'],
            time: Map<String, Timestamp>.from(bill['Trip Time']).map(
                (key, value) =>
                    MapEntry(key, DateTime.parse(value.toDate().toString()))),
            companyName: bill['Company Name']));
      });
    });
    return true;
  }
}
