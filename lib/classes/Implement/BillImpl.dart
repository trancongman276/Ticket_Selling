import 'dart:collection';

import 'package:CoachTicketSelling/classes/actor/Bill.dart';

class BillImplement {
  Map<String, Bill> _billLs = {};
  List<int> _incomeMonthly = [];
  List<List<int>> _incomeDaily =
      List.generate(12, (index) => List.generate(31, (index) => 0));
  List<double> _kpis = List.generate(12, (index) => 0.0);
  List<Map<String, int>> _visit = List.generate(12, (index) => {});
  List<Map<String, double>> _rate = List.generate(12, (index) => {});

  BillImplement._() {
    refresh();
  }

  static BillImplement _instance = BillImplement._();
  static BillImplement get instance => _instance;

  bool _initBill() {
    _billLs['5'] = Bill(20, 4, 'Nha Trang', DateTime.now());
    _billLs['6'] = Bill(20, 4, 'Hue', DateTime.now());
    _billLs['7'] = Bill(20, 4, 'Da Nang', DateTime.now());
    _billLs['8'] = Bill(20, 4, 'Daklak', DateTime.now());
    _billLs['1'] = Bill(100, 3.5, 'Ha Noi', DateTime.now());
    _billLs['2'] = Bill(200, 4.5, 'Ho Chi Minh', DateTime.now());
    _billLs['3'] = Bill(300, 1.5, 'Ha Noi', DateTime.now());
    _billLs['4'] = Bill(500, 3.5, 'Ho Chi Minh', DateTime.now());

    return true;
  }

  bool _initIncome() {
    _billLs.forEach((id, bill) {
      _incomeDaily[bill.time.month - 1][bill.time.day - 1] = bill.cost;
    });
    _incomeDaily.forEach((month) {
      if (month.isNotEmpty)
        _incomeMonthly.add(month.reduce((current, next) => current + next));
      else
        _incomeMonthly.add(0);
    });
    return true;
  }

  bool _initKpis() {
    for (int i = 0; i < _incomeMonthly.length - 1; i++) {
      _kpis[i + 1] =
          (_incomeMonthly[i + 1] - _incomeMonthly[i]) / _incomeMonthly[i];
    }
    print(_kpis);
    return true;
  }

  bool _initMostVisited() {
    _billLs.forEach((id, bill) {
      _visit[bill.time.month - 1][bill.destination] == null
          ? _visit[bill.time.month - 1].putIfAbsent(bill.destination, () => 1)
          : _visit[bill.time.month - 1][bill.destination] += 1;
    });
    _billLs.forEach((id, bill) {
      var sortedValue = _visit[bill.time.month - 1].keys.toList(growable: false)
        ..sort((k1, k2) => _visit[bill.time.month - 1][k2]
            .compareTo(_visit[bill.time.month - 1][k1]));
      _visit[bill.time.month - 1] = LinkedHashMap.fromIterable(sortedValue,
          key: (k) => k, value: (v) => _visit[bill.time.month - 1][v]);
    });
    return true;
  }

  bool _initRating() {
    List<Map<String, List<double>>> allRating =
        List.generate(12, (index) => {});

    _billLs.forEach((id, bill) {
      allRating[bill.time.month - 1].putIfAbsent(bill.destination, () => []);
      allRating[bill.time.month - 1][bill.destination].add(bill.rate);
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
    print(_rate);
    return true;
  }

  bool refresh() {
    _initBill();
    _initIncome();
    _initKpis();
    _initMostVisited();
    _initRating();
    return true;
  }

  List<int> getAllDailyIncome(int month) => _incomeDaily[month];
  List<int> getAllMonthlyIncome() => _incomeMonthly;
  List<double> getKpis() => _kpis;
  List<Map<String, int>> getVisited() => _visit;
  List<Map<String, double>> getRating() => _rate;
}
