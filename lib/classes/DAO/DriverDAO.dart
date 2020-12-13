import 'package:CoachTicketSelling/classes/actor/Company.dart';
import 'package:CoachTicketSelling/classes/actor/Driver.dart';
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
  Company company;

  bool update({
    @required String id,
    String email,
    String name,
    String phone,
    DateTime doB,
    String gender,
    Company company,
  });

  bool add(
    String id,
    String email,
    String name,
    String phone,
    DateTime doB,
    String gender,
    Company company,
  );

  Driver get(String id);

  bool delete(String id);
}
