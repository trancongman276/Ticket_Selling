import 'dart:io';

import 'package:CoachTicketSelling/classes/actor/Company.dart';
import 'package:CoachTicketSelling/classes/actor/Trip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:CoachTicketSelling/classes/DAO/accountDAO.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Driver extends AccountDAO {
  bool isInit = false;
  String id;
  bool isAvailable = true;
  String email;
  String name;
  String phone;
  DateTime doB;
  String gender;
  String role = 'Driver';
  String imageUrl;
  Company company;
  String note;
  DocumentReference documentReference;
  List<Map<String, DateTime>> _dayWorkLs = [];
  List<Trip> _tripWorkLs = [];
  static Driver _currentDriver = Driver._();

  static Driver get currentDriver => _currentDriver;

  Driver.create(
      this.id,
      this.phone,
      this.email,
      this.name,
      this.doB,
      this.gender,
      this.imageUrl,
      this.company,
      this.note,
      this.documentReference);

  Driver._();

  Driver.id(this.id) {
    init();
  }

  static bool kill() {
    _currentDriver = Driver._();
    return true;
  }

  Future init() async {
    if (this.id == null) this.id = FirebaseAuth.instance.currentUser.uid;
    Timestamp timestamp;
    documentReference = FirebaseFirestore.instance.collection('User').doc(id);
    await documentReference.get().then((document) async {
      this.isAvailable = document.data()['isAvalable'];
      this.company = Company.none();
      await company.getData(document.data()['Company']);
      this.email = document.data()['Email'];
      this.name = document.data()['Name'];
      this.gender = document.data()['Gender'];
      timestamp = document.data()['DoB'];
      this.doB = DateTime.parse(timestamp.toDate().toString());
      this.phone = document.data()['Phone'];
      this.note = document.data()['Note'];
      this.imageUrl = document.data()['ImageUrl'];
    });
    _dayWorkLs = await getDayWork(this.id);
  }

  _changePassword(String password) {
    FirebaseAuth.instance.currentUser.updatePassword(password);
  }

  @override
  String toString() {
    return '[Name :$name ,\nEmail: $email,\nPhone: ${phone.toString()},' +
        '\nDoB: $doB,\nGender: $gender,\nImageUrl: $imageUrl,\nCompany: $company,\nNote: $note]';
  }

  @override
  Future<bool> update({
    String id,
    String email,
    String password,
    String name,
    String phone,
    DateTime doB,
    String gender,
    File image,
    String note,
  }) async {
    if (password != null) {
      this._changePassword(password);
    } else {
      this.email = email ?? this.email;
      this.name = name ?? this.name;
      this.phone = phone ?? this.phone;
      this.doB = doB ?? this.doB;
      this.gender = gender ?? this.gender;
      this.note = note ?? this.note;

      if (image != null) {
        String ex = image.path.split('.').last;
        uploadImage(image, 'Driver/$id.$ex').then((url) => this.imageUrl = url);
      }
      await FirebaseFirestore.instance.collection('User').doc(id).set({
        'isAvailable': this.isAvailable,
        'Email': this.email,
        'Name': this.name,
        'Phone': this.phone,
        'DoB': Timestamp.fromDate(this.doB),
        'Gender': this.gender,
        'Company': this.company.documentReference,
        'Role': 'Driver',
        'Note': this.note,
        'ImageUrl': this.imageUrl,
      });
    }
    return true;
  }

  Future<List<Map<String, DateTime>>> getDayWork(String id) async {
    _dayWorkLs = [];
    if (_dayWorkLs.isEmpty) {
      await FirebaseFirestore.instance
          .collection('Trip')
          .where('Driver', isEqualTo: this.documentReference)
          .get()
          .then((query) {
        query.docs.forEach((doc) {
          _tripWorkLs.add(Trip(
              source: doc.data()['Source'],
              destination: doc.data()['Destination']));

          Map<String, Timestamp> time =
              Map<String, Timestamp>.from(doc.data()['Time']);

          _dayWorkLs.add(time.map((key, value) =>
              MapEntry(key, DateTime.parse(value.toDate().toString()))));
        });
      });
    }
    return Future.value(_dayWorkLs);
  }

  List<Map<String, DateTime>> get dayWorkList => _dayWorkLs;
  List<Trip> get tripWorkList => _tripWorkLs;
}
