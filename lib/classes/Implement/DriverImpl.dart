import 'dart:io';
import 'dart:math';

import 'package:CoachTicketSelling/classes/DAO/accountDAO.dart';
import 'package:CoachTicketSelling/classes/actor/Driver.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DriverImpl extends AccountDAO {
  Map<String, Driver> _driverLs;

  static final DriverImpl _instance = DriverImpl._();

  static DriverImpl get instance => _instance;

  DriverImpl._() {
    _init();
    print('[DEBUGER] Driver Implement initiated.');
  }

  Future<bool> _init() async {
    _driverLs = {};
    // Timestamp timestamp;
    // await FirebaseFirestore.instance
    //     .collection('User')
    //     .where('Role', isEqualTo: 'Driver')
    //     .get()
    //     .then((querySnap) {
    //   querySnap.docs.forEach((document) {
    //     Driver driver;
    //     driver.company = document.data()['Company'];
    //     driver.email = document.data()['Email'];
    //     driver.name = document.data()['Name'];
    //     driver.gender = document.data()['Gender'];
    //     timestamp = document.data()['DoB'];
    //     driver.doB = DateTime.parse(timestamp.toDate().toString());
    //     driver.phone = document.data()['Phone'];
    //     driver.note = document.data()['Note'];
    //     driver.imageUrl = document.data()['ImageUrl'];
    //     _driverLs[document.id] = driver;
    //   });
    // });

    Driver driver = Driver.id('1');
    driver.imageUrl =
        'https://static.wikia.nocookie.net/diepio/images/6/6e/Pogchamp.jpg';
    driver.email = 'abc@abc.com';
    driver.name = 'I am POG';
    driver.phone = '0123456789';
    driver.doB = DateTime.utc(1987, 6, 12);
    driver.gender = 'Male';
    _driverLs['1'] = driver;
    _driverLs['2'] = driver;
    _driverLs['3'] = driver;
    _driverLs['4'] = driver;
    _driverLs['5'] = driver;
    _driverLs['6'] = driver;
    _driverLs['7'] = driver;
    _driverLs['8'] = driver;

    return true;
  }

  @override
  bool update({
    String id,
    String email,
    String password,
    String name,
    String phone,
    DateTime doB,
    String gender,
    File image,
    DocumentReference company,
    String note,
  }) {
    Driver driver = _driverLs[id];
    if (password != null) {
      driver.changePassword(password);
    } else {
      driver.email = email ?? driver.email;
      driver.name = name ?? driver.name;
      driver.phone = phone ?? driver.phone;
      driver.doB = doB ?? driver.doB;
      driver.gender = gender ?? driver.gender;
      driver.company = company ?? driver.company;
      driver.note = note ?? driver.note;

      if (image != null) {
        String ex = image.path.split('.').last;
        uploadImage(image, id, 'Driver/$id.$ex')
            .then((url) => driver.imageUrl = url);
      }

      // FirebaseFirestore.instance.collection('User').doc(id).set({
      //   'Email': driver.email,
      //   'Name': driver.name,
      //   'Phone': driver.phone,
      //   'DoB': driver.doB.microsecondsSinceEpoch,
      //   'Gender': driver.gender,
      //   'Company': driver.company,
      //   'Note': driver.note,
      //   'ImageUrl': driver.imageUrl,
      // });
    }
    return true;
  }

  bool updateUsingDriverObject(String id, Driver driver) {
    _driverLs[id] = driver;
    print('updated $id \t${driver.name}');
    return true;
  }

  @override
  bool add(
    String email,
    String name,
    String phone,
    DateTime doB,
    String gender,
    File image, {
    @required DocumentReference company,
    @required String note,
  }) {
    Driver driver = Driver.none();
    // driver.company = company;
    driver.email = email;
    driver.imageUrl =
        'https://static.wikia.nocookie.net/diepio/images/6/6e/Pogchamp.jpg';
    driver.name = name;
    driver.phone = phone;
    driver.doB = doB;
    driver.gender = gender;
    driver.note = note;
    String id = Random.secure().nextInt(1000).toString();

    // FirebaseAuth.instance
    //     .createUserWithEmailAndPassword(
    //         email: email, password: '${doB.year}${doB.month}${doB.day}')
    //     .then((user) => id = user.user.uid);

    String ex = image.path.split('.').last;
    // uploadImage(image, id, 'Driver/$id.$ex')
    //     .then((url) => driver.imageUrl = url);

    // FirebaseFirestore.instance.collection('User').doc(id).set({
    //   'Email': driver.email,
    //   'Name': driver.name,
    //   'Phone': driver.phone,
    //   'DoB': driver.doB.microsecondsSinceEpoch,
    //   'Gender': driver.gender,
    //   'Company': driver.company,
    //   'Role': 'Driver',
    //   'Note': driver.note,
    //   'ImageUrl': driver.imageUrl,
    // });

    _driverLs[id] = driver;

    print('[Debug] Created Driver');
    return true;
  }

  @override
  bool delete(String id) {
    _driverLs.remove(id);
    // FirebaseFirestore.instance.collection('User').doc(id).delete();
    return true;
  }

  Map get driverList => _driverLs;

  int len() => _driverLs.length;
}
