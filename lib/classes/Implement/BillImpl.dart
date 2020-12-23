import 'dart:collection';

import 'package:CoachTicketSelling/classes/actor/AppUser.dart';
import 'package:CoachTicketSelling/classes/actor/Trip.dart';
import 'package:CoachTicketSelling/classes/actor/TripRoute.dart';
import 'package:CoachTicketSelling/classes/actor/Bill.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_util/date_util.dart';

class BillImplement {
  Map<String, Bill> _billLs = {};
  List<int> _incomeMonthly = [];
  List<List<int>> _incomeDaily = List.generate(
      12,
      (index) => List.generate(
          DateUtil().daysInMonth(index + 1, DateTime.now().year),
          (index) => 0));
  List<double> _kpis = List.generate(12, (index) => 0.0);
  List<Map<TripRoute, int>> _visit = List.generate(12, (index) => {});
  List<Map<TripRoute, double>> _rate = List.generate(12, (index) => {});

  BillImplement._();

  static BillImplement _instance = BillImplement._();
  static BillImplement get instance => _instance;
  static bool kill() {
    _instance = BillImplement._();
    return true;
  }

  Future<bool> _initBill() async {
    _incomeDaily = List.generate(12, (index) {
      if ((index + 1) == DateTime.now().month) {
        return List.generate(DateTime.now().day, (index) => 0);
      } else
        return List.generate(
            DateUtil().daysInMonth(index + 1, DateTime.now().year),
            (index) => 0);
    });

    await FirebaseFirestore.instance
        .collection('User')
        .where('Role', isEqualTo: 'User')
        .get()
        .then((user) {
      for (QueryDocumentSnapshot query in user.docs) {
        var userBillList = query.data()['Bill'];
        Map<String, Map<String, dynamic>> ticket = query.data()['Ticket'];
        double rate = -1;
        if (ticket != null) if (ticket.isNotEmpty) {
          rate = 0;
          for (Map<String, dynamic> map in ticket.values) {
            rate += map['Rate'];
          }
          rate /= ticket.length;
        }

        userBillList.forEach((key, bill) {
          _billLs[key] = Bill(
              id: key,
              tripTime: Map<String, Timestamp>.from(bill['Trip Time']).map(
                  (key, value) =>
                      MapEntry(key, DateTime.parse(value.toDate().toString()))),
              cost: bill['Cost'],
              purchaseTime:
                  DateTime.parse(bill['Purchase Time'].toDate().toString()),
              rate: rate == -1 ? 0 : rate,
              tripRoute: TripRoute(
                  source: bill['Source'], destination: bill['Destination']),
              companyName: bill['Company Name']);
        });
      }
    });

    return true;
  }

  bool _initIncome() {
    _billLs.forEach((id, bill) {
      _incomeDaily[bill.purchaseTime.month - 1][bill.purchaseTime.day - 1] =
          bill.cost;
    });
    _incomeDaily.forEach((month) {
      if (month.isNotEmpty) {
        int income = month.reduce((value, element) => value + element);
        _incomeMonthly.add(income);
      } else
        _incomeMonthly.add(0);
    });
    return true;
  }

  bool _initKpis() {
    for (int i = 0; i < _incomeMonthly.length - 1; i++) {
      _kpis[i + 1] =
          (_incomeMonthly[i + 1] - _incomeMonthly[i]) / _incomeMonthly[i];
    }

    return true;
  }

  bool _initMostVisited() {
    _billLs.forEach((id, bill) {
      if (_visit[bill.purchaseTime.month - 1][bill.tripRoute] == null) {
        _visit[bill.purchaseTime.month - 1]
            .putIfAbsent(bill.tripRoute, () => 1);
      } else {
        _visit[bill.purchaseTime.month - 1]
            .update(bill.tripRoute, (value) => value + 1);
      }
    });
    _billLs.forEach((id, bill) {
      var sortedValue = _visit[bill.purchaseTime.month - 1]
          .keys
          .toList(growable: false)
            ..sort((k1, k2) => _visit[bill.purchaseTime.month - 1][k2]
                .compareTo(_visit[bill.purchaseTime.month - 1][k1]));
      _visit[bill.purchaseTime.month - 1] = LinkedHashMap.fromIterable(
          sortedValue,
          key: (k) => k,
          value: (v) => _visit[bill.purchaseTime.month - 1][v]);
    });
    return true;
  }

  bool _initRating() {
    // 12 months
    List<Map<TripRoute, List<double>>> allRating =
        List.generate(12, (index) => {});

    _billLs.forEach((id, bill) {
      allRating[bill.purchaseTime.month - 1]
          .putIfAbsent(bill.tripRoute, () => []);
      allRating[bill.purchaseTime.month - 1].update(bill.tripRoute, (value) {
        value.add(bill.rate);
        return value;
      });
    });

    for (int index = 0; index < allRating.length; index++) {
      allRating[index].forEach((id, rates) {
        _rate[index][id] =
            rates.reduce((current, next) => current + next) / rates.length;
      });
      var sortedValue = _rate[index].keys.toList(growable: false)
        ..sort((k1, k2) => _rate[index][k2].compareTo(_rate[index][k1]));
      _rate[index] = LinkedHashMap.fromIterable(sortedValue,
          key: (k) => k, value: (v) => _rate[index][v]);
    }

    return true;
  }

  Future<bool> refresh() async {
    await _initBill();
    _initIncome();
    _initKpis();
    _initMostVisited();
    _initRating();
    return true;
  }



  List<int> getAllDailyIncome(int month) => _incomeDaily[month];
  List<int> getAllMonthlyIncome() => _incomeMonthly;
  List<double> getKpis() => _kpis;
  List<Map<TripRoute, int>> getVisited() => _visit;
  List<Map<TripRoute, double>> getRating() => _rate;
}
