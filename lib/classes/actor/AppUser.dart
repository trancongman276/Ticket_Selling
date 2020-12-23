import 'dart:io';

import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:CoachTicketSelling/classes/DAO/accountDAO.dart';
import 'package:CoachTicketSelling/classes/actor/Trip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppUser extends AccountDAO {
  Map<String, Map<String, dynamic>> billLs;
  String id;

  static AppUser _instance = AppUser._();
  static AppUser get instance => _instance;
  static bool kill() {
    _instance = AppUser._();
    return true;
  }

  AppUser._();
  @override
  Future<bool> update({
    String email,
    String password,
    String name,
    String phone,
    DateTime doB,
    String gender,
    File image,
    Map<String, Map<String, dynamic>> billLs,
  }) async {
    if (password != null) {
      await FirebaseAuth.instance.currentUser.updatePassword(password);
    } else {
      this.email = email ?? this.email;
      this.name = name ?? this.name;
      this.phone = phone ?? this.phone;
      this.doB = doB ?? this.doB;
      this.gender = gender ?? this.gender;
      this.billLs = billLs ?? this.billLs;

      if (image != null) {
        String ex = image.path.split('.').last;
        uploadImage(image, 'User/$id.$ex').then((url) => this.imageUrl = url);
      }

      await FirebaseFirestore.instance.collection('User').doc(id).set({
        'Email': this.email,
        'Name': this.name,
        'Phone': this.phone,
        'DoB': Timestamp.fromDate(this.doB),
        'Gender': this.gender,
        'ImageUrl': this.imageUrl ?? Utils.defaultUrl,
        'Role': 'User',
        'Bill': this.billLs,
      });
    }
    return true;
  }

  Future<bool> getUser() async {
    if (this.id == null) {
      this.id = FirebaseAuth.instance.currentUser.uid;
    }
    await FirebaseFirestore.instance
        .collection('User')
        .doc(id)
        .get()
        .then((document) {
      this.email = document.data()['Email'];
      this.name = document.data()['Name'];
      this.phone = document.data()['Phone'];
      Timestamp timestamp = document.data()['DoB'];
      this.doB = DateTime.tryParse(timestamp.toDate().toString());
      this.gender = document.data()['Gender'];
      this.imageUrl = document.data()['ImageUrl'];
      var map = document.data()['Bill'];
      this.billLs = Map<String, Map<String, dynamic>>.from(map);
    });

    return true;
  }

  Future doPayment({Trip trip, List<int> seatLs}) async {
    Timestamp buyTime = Timestamp.fromDate(DateTime.now());
    String id = trip.id + '${buyTime.nanoseconds}';
    Map<String, dynamic> ticketLs = {};
    seatLs.forEach((seatID) {
      ticketLs[id + seatID.toString()] = {
        'SeatID': seatID,
        'Rate': int.parse('0')
      };
    });
    billLs[id] = {
      'Trip Time': trip.time
          .map((key, value) => MapEntry(key, Timestamp.fromDate(value))),
      'Source': trip.source,
      'Destination': trip.destination,
      'Cost': trip.price * seatLs.length,
      'Purchase Time': buyTime,
      'Company Name': trip.company.name,
      'Ticket': ticketLs,
    };
    await update();
    return Future.value(true);
  }
}
