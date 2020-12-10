import 'package:CoachTicketSelling/classes/actor/Driver.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class DriverDAO {
  Map<String, Driver> driverLs;
  String id;
  String email;
  String name;
  String phone;
  DateTime doB;
  String gender;
  String role;
  DocumentReference company;

  bool update({
    @required String id,
    String email,
    String name,
    String phone,
    DateTime doB,
    String gender,
    DocumentReference company,
  });

  bool add(
    String id,
    String email,
    String name,
    String phone,
    DateTime doB,
    String gender,
    DocumentReference company,
  );

  Driver get(String id);

  bool delete(String id);
}
