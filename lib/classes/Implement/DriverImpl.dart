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

  static final DriverImpl _instance = DriverImpl._();

  static DriverImpl get instance => _instance;

  DriverImpl._();

  // Init Driver list
  Future<bool> init() async {
    if (Manager.instance.company == null) {
      await Manager.instance.getData();
    }
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
    print('[DEBUG] Driver Implement initiated.');

    return true;
  }

  //Update Driver
  @override
  bool update(
      {String id,
      bool isAvailable,
      String email,
      String password,
      String name,
      String phone,
      DateTime doB,
      String gender,
      File image,
      String note}) {
    Driver driver = _driverLs[id];

    driver.update(
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
      'ImageUrl': driver.imageUrl,
    });
    print('[DEBUG] Updated $id \t${driver.name}');
    return true;
  }

  // Add Driver
  bool add(String email, String name, String phone, DateTime doB, String gender,
      File image,
      {@required String note}) {
    String id = '';
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: email, password: '${doB.year}${doB.month}${doB.day}')
        .then((user) {
      id = user.user.uid;
      user.user.sendEmailVerification();
    });

    String imageUrl = '';
    String ex = image.path.split('.').last;
    uploadImage(image, id, 'Driver/$id.$ex').then((url) => imageUrl = url);

    DocumentReference ref =
        FirebaseFirestore.instance.collection('User').doc(id);
    ref.set({
      'isAvailable': true,
      'Email': email,
      'Name': name,
      'Phone': phone,
      'DoB': Timestamp.fromDate(doB),
      'Gender': gender,
      'Company': company,
      'Role': 'Driver',
      'Note': note,
      'ImageUrl': imageUrl,
    });
    Driver driver = Driver.create(
        id, phone, email, name, doB, gender, imageUrl, company, note, ref);
    _driverLs[id] = driver;

    print('[DEBUG] Created Driver ${driver.toString()}');
    return true;
  }

  // Delete Driver
  bool delete(String id) {
    _driverLs.remove(id);
    FirebaseFirestore.instance
        .collection('User')
        .doc(id)
        .set({'isAvailable': false});
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
    _driverLs.forEach((key, value) {
      if (value == driver) return key;
    });
    return null;
  }

  Map<String, Driver> get driverList => _driverLs;
  int len() => _driverLs.length;
}
