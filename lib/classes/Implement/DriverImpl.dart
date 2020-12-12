import 'dart:io';

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
    Timestamp timestamp;
    await FirebaseFirestore.instance
        .collection('User')
        .where('Role', isEqualTo: 'Driver')
        .get()
        .then((querySnap) {
      querySnap.docs.forEach((document) {
        if (document.data()['isAvailable']) {
          timestamp = document.data()['DoB'];

          Driver driver = Driver.create(
              document.data()['Phone'],
              document.data()['Email'],
              document.data()['Name'],
              DateTime.parse(timestamp.toDate().toString()),
              document.data()['Gender'],
              document.data()['ImageUrl'],
              document.data()['Company'],
              document.data()['Note']);

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

    return true;
  }

  @override
  bool update({
    String id,
    bool isAvailable,
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

    driver.update(
        id: id,
        email: email,
        name: name,
        password: password,
        phone: phone,
        doB: doB,
        gender: gender,
        image: image,
        company: company,
        note: note);

    return true;
  }

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

    FirebaseFirestore.instance.collection('User').doc(id).set({
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
    Driver driver =
        Driver.create(phone, email, name, doB, gender, imageUrl, company, note);
    _driverLs[id] = driver;

    print('[Debug] Created Driver ${driver.toString()}');
    return true;
  }

  bool delete(String id) {
    _driverLs.remove(id);
    FirebaseFirestore.instance
        .collection('User')
        .doc(id)
        .set({'isAvailable': false});
    return true;
  }

  Map get driverList => _driverLs;

  int len() => _driverLs.length;
}
