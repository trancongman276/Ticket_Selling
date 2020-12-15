import 'package:CoachTicketSelling/classes/actor/Company.dart';
import 'package:CoachTicketSelling/classes/actor/Driver.dart';
import 'package:CoachTicketSelling/classes/actor/Manager.dart';
import 'package:CoachTicketSelling/classes/actor/Trip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TripImplement {
  Company company;
  bool isInit = false;
  Map<String, Trip> _tripLs = {};
  static TripImplement _instance = TripImplement._();
  static bool kill() {
    _instance = TripImplement._();
    return true;
  }

  static TripImplement get instance => _instance;
  TripImplement._();

  //For Specific company
  Future<bool> init() async {
    if (Manager.instance.company == null) {
      await Manager.instance.getData();
    }
    company = Manager.instance.company;
    await FirebaseFirestore.instance
        .collection('Trip')
        .where('Company', isEqualTo: company.documentReference)
        .get()
        .then((query) {
      query.docs.forEach((doc) async {
        await _assignData(doc, true);
      });
    });
    isInit = true;
    return Future.value(true);
  }

  //For all company
  Future<bool> initAll() async {
    company = Manager.instance.company;
    await FirebaseFirestore.instance.collection('Trip').get().then((query) {
      query.docs.forEach((doc) async {
        await _assignData(doc, false);
      });
    });
    return Future.value(true);
  }

  //Put data into trip list
  Future _assignData(QueryDocumentSnapshot doc, bool isManager) async {
    Map<String, dynamic> tempMap = doc.data()['Time'];
    Map<String, DateTime> time = {};
    tempMap.forEach((key, value) {
      time[key] = DateTime.parse(value.toDate().toString());
    });
    Company _company = Company.none();

    if (!isManager) {
      await _company.getData(doc.data()['Company']);
    }
    DocumentReference ref = doc.data()['Driver'];
    _tripLs[doc.id] = Trip(
      source: doc.data()['Source'],
      destination: doc.data()['Destination'],
      price: doc.data()['Price'],
      totalSeat: doc.data()['Total Seat'],
      seat: List<int>.from(doc.data()['Seat']),
      detail: doc.data()['Detail'],
      time: time,
      driver: Driver.id(ref.id),
      company: isManager ? company : _company,
    );
  }

  //Update trip
  bool update(String id,
      {String source,
      String destination,
      int price,
      int totalSeat,
      String detail,
      Map<String, DateTime> time,
      List<int> seat}) {
    _tripLs[id].update(
        source: source,
        destination: destination,
        price: price,
        totalSeat: totalSeat,
        detail: detail,
        time: time,
        seat: seat);

    FirebaseFirestore.instance.collection('Trip').doc(id).set({
      'Source': _tripLs[id].source,
      'Destination': _tripLs[id].destination,
      'Price': _tripLs[id].price,
      'Time': _tripLs[id].time,
      'Total Seat': _tripLs[id].totalSeat,
      'Seat': _tripLs[id].seat,
      'Detail': _tripLs[id].detail,
    });
    return true;
  }

  //Adding trip handling
  Future<bool> add(String source, String destination, int price, int totalSeat,
      Driver driver, String detail, Map<String, DateTime> time) async {
    Map<String, Timestamp> tempMap =
        time.map((key, value) => MapEntry(key, Timestamp.fromDate(value)));
    await FirebaseFirestore.instance.collection('Trip').add({
      'Source': source,
      'Destination': destination,
      'Price': price,
      'Total Seat': totalSeat,
      'Seat': [],
      'Driver': FirebaseFirestore.instance.collection('User').doc(driver.id),
      'Company': company.documentReference,
      'Detail': detail,
      'Time': tempMap,
    }).then((value) {
      _tripLs[value.id] = Trip(
        source: source,
        destination: destination,
        price: price,
        totalSeat: totalSeat,
        detail: detail,
        driver: driver,
        company: company,
        time: time,
      );
    });

    return Future.value(true);
  }

  //Delete Trip
  bool delete(String tripID) {
    _tripLs.remove(tripID);
    FirebaseFirestore.instance.collection('Trip').doc(tripID).delete();
    return true;
  }

  //Get Trip
  Trip getTrip(String id) {
    return _tripLs[id];
  }

  Map get tripList => _tripLs;
}
