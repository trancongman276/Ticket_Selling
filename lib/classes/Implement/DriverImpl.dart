import 'dart:io';

import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:CoachTicketSelling/classes/DAO/accountDAO.dart';
import 'package:CoachTicketSelling/classes/actor/Company.dart';
import 'package:CoachTicketSelling/classes/actor/Driver.dart';
import 'package:CoachTicketSelling/classes/actor/Manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DriverImpl extends AccountDAO {
  Company company;
  bool isInit = false;
  Map<String, Driver> _driverLs = {};

  static DriverImpl _instance = DriverImpl._();
  static bool kill() {
    _instance = DriverImpl._();
    return true;
  }

  static DriverImpl get instance => _instance;

  DriverImpl._();

  // Init Driver list
  Future<bool> init() async {
    
    company = Manager.instance.company;

    Timestamp timestamp;
    await FirebaseFirestore.instance
        .collection('User')
        .where('Role', isEqualTo: 'Driver')
        .where('Company', isEqualTo: company.documentReference)
        .get()
        .then((querySnap) {
      querySnap.docs.forEach((document) {
        bool isAvailable = document.data()['isAvailable'];
        if (isAvailable == true) {
          timestamp = document.data()['DoB'];

          Driver driver = Driver.create(
              document.id,
              document.data()['Phone'],
              document.data()['Email'],
              document.data()['Name'],
              DateTime.parse(timestamp.toDate().toString()),
              document.data()['Gender'],
              document.data()['ImageUrl'],
              company,
              document.data()['Note'],
              document.reference);

          _driverLs[document.id] = driver;
        }
      });
    });

    // Driver driver = Driver.id('1');
    // driver.imageUrl =
    //     'https://static.wikia.nocookie.net/diepio/images/6/6e/Pogchamp.jpg';
    // driver.email = 'abc@abc.com';
    // driver.name = 'I am POG';
    // driver.phone = '0123456789';
    // driver.doB = DateTime.utc(1987, 6, 12);
    // driver.gender = 'Male';
    // _driverLs['1'] = driver;
    // _driverLs['2'] = driver;
    // _driverLs['3'] = driver;
    // _driverLs['4'] = driver;
    // _driverLs['5'] = driver;
    // _driverLs['6'] = driver;
    // _driverLs['7'] = driver;
    // _driverLs['8'] = driver;
    isInit = true;

    return true;
  }

  //Update Driver
  @override
  Future<bool> update(
      {String id,
      bool isAvailable,
      String email,
      String password,
      String name,
      String phone,
      DateTime doB,
      String gender,
      File image,
      String note}) async {
    Driver driver = _driverLs[id];

    await driver.update(
        id: id,
        email: email,
        name: name,
        password: password,
        phone: phone,
        doB: doB,
        gender: gender,
        image: image,
        note: note);

    return true;
  }

  // Copy Driver information and update
  bool updateUsingDriverObject(String id, Driver driver) {
    _driverLs[id] = driver;
    FirebaseFirestore.instance.collection('User').doc(id).set({
      'isAvailable': driver.isAvailable,
      'Email': driver.email,
      'Name': driver.name,
      'Phone': driver.phone,
      'DoB': Timestamp.fromDate(doB),
      'Gender': driver.gender,
      'Company': driver.company,
      'Note': driver.note,
      'Role': 'Driver',
      'ImageUrl': driver.imageUrl,
    });
    return true;
  }

  // Add Driver
  Future<bool> add(String email, String name, String phone, DateTime doB,
      String gender, File image,
      {@required String note}) async {
    String id = '';

    for (var driver in _driverLs.values) {
      if (driver.email == email) {
        return false;
      }
    }

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email, password: '${doB.year}${doB.month}${doB.day}')
          .then((user) {
        id = user.user.uid;
        // user.user.sendEmailVerification();
      });
    } catch (e) {
      if (e.code == 'email-already-in-use') return false;
    }

    String imageUrl = '';
    String ex = image.path.split('.').last;
    imageUrl = await uploadImage(image, 'Driver/$id.$ex');

    DocumentReference ref =
        FirebaseFirestore.instance.collection('User').doc(id);
    await ref.set({
      'isAvailable': true,
      'Email': email,
      'Name': name,
      'Phone': phone,
      'DoB': Timestamp.fromDate(doB),
      'Gender': gender,
      'Company': company.documentReference,
      'Role': 'Driver',
      'Note': note,
      'ImageUrl': imageUrl,
    });
    Driver driver = Driver.create(
        id, phone, email, name, doB, gender, imageUrl, company, note, ref);
    _driverLs[id] = driver;

    return true;
  }

  // Delete Driver
  bool delete(String id) {
    _driverLs[id].isAvailable = false;
    update(id: id, isAvailable: false);

    _driverLs.remove(id);
    return true;
  }

  // Get list of free driver in a specific time
  Future<List<Driver>> getFreeDriver(String start, String end) async {
    List<Driver> returnDriver = [];
    for (var i = 0; i < _driverLs.length; i++) {
      bool isPassed = true;
      String id = _driverLs.keys.elementAt(i);
      Driver driver = _driverLs[id];
      await driver.getDayWork(id);
      driver.dayWorkList.every((time) {
        if ((time['Start Time'].isBefore(Utils.dateFormat.parse(start)) &
                time['Finish Time'].isAfter(Utils.dateFormat.parse(start))) |
            (time['Start Time'].isBefore(Utils.dateFormat.parse(end)) &
                time['Finish Time'].isAfter(Utils.dateFormat.parse(end)))) {
          isPassed = false;
          return false;
        }
        return true;
      });
      if (isPassed) returnDriver.add(driver);
    }
    return Future.value(returnDriver);
  }

  // Get driver by index
  Driver getDriverAtIndex(int index) {
    return _driverLs[_driverLs.keys.elementAt(index)];
  }

  // Get Driver ID
  String getDriverID(Driver driver) {
    // String _key = '';
    // _driverLs.forEach((key, value) {
    //   if (value == driver) return ;
    // });
    // return '';
    for (var key in _driverLs.keys) {
      if (_driverLs[key] == driver) {
        return key;
      }
    }
    return null;
  }

  Map<String, Driver> get driverList => _driverLs;
  int len() => _driverLs.length;
}
