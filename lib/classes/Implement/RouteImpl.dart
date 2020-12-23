import 'package:CoachTicketSelling/classes/actor/Company.dart';

class RouteImpl {
  Map<String, List<String>> routeLs;

  static RouteImpl _instance = RouteImpl._();
  static RouteImpl get instance => _instance;
  static bool kill() {
    _instance = RouteImpl._();
    return true;
  }

  RouteImpl._() {
    routeLs = {};
  }

  bool addRoute(Company company) {
    for (String key in company.route.keys) {
      if (routeLs[key] == null) routeLs[key] = [];
      Set<String> route = Set.from(routeLs[key]);
      route.addAll(company.route[key]);
      routeLs[key] = route.toList();
    }
    return true;
  }

  bool addRouteAvailable(String source, String des) {
    if (routeLs[source] == null) routeLs[source] = [];
    if (!routeLs[source].contains(des)) routeLs[source].add(des);
    return true;
  }
}
