import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:CoachTicketSelling/classes/DAO/accountDAO.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Driver extends AccountDAO {
  String id;
  bool isAvailable = true;
  String email;
  String name;
  String phone;
  DateTime doB;
  String gender;
  String role = 'Driver';
  String imageUrl;
  DocumentReference company;
  String note;
  List<Map<String, DateTime>> _dayWorkLs;

  static Driver _currentDriver =
      Driver._id(FirebaseAuth.instance.currentUser.uid);

  static Driver get currentDriver => _currentDriver;

  Driver.create(this.id, this.phone, this.email, this.name, this.doB,
      this.gender, this.imageUrl, this.company, this.note) {
    _getDayWork(id).then((dayWork) => _dayWorkLs = dayWork);
  }

  Driver._id(this.id) {
    Timestamp timestamp;
    FirebaseFirestore.instance
        .collection('User')
        .doc(id)
        .get()
        .then((document) {
      this.isAvailable = document.data()['isAvalable'];
      this.company = document.data()['Company'];
      this.email = document.data()['Email'];
      this.name = document.data()['Name'];
      this.gender = document.data()['Gender'];
      timestamp = document.data()['DoB'];
      this.doB = DateTime.parse(timestamp.toDate().toString());
      this.phone = document.data()['Phone'];
      this.note = document.data()['Note'];
      this.imageUrl = document.data()['ImageUrl'];
    });
    _getDayWork(id).then((dayWork) => _dayWorkLs = dayWork);
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
    if (password != null) {
      this._changePassword(password);
    } else {
      this.isAvailable = isAvailable ?? this.isAvailable;
      this.email = email ?? this.email;
      this.name = name ?? this.name;
      this.phone = phone ?? this.phone;
      this.doB = doB ?? this.doB;
      this.gender = gender ?? this.gender;
      this.company = company ?? this.company;
      this.note = note ?? this.note;

      if (image != null) {
        String ex = image.path.split('.').last;
        uploadImage(image, id, 'Driver/$id.$ex')
            .then((url) => this.imageUrl = url);
      }

      FirebaseFirestore.instance.collection('User').doc(id).set({
        'isAvailable': this.isAvailable,
        'Email': this.email,
        'Name': this.name,
        'Phone': this.phone,
        'DoB': Timestamp.fromDate(doB),
        'Gender': this.gender,
        'Company': this.company,
        'Note': this.note,
        'ImageUrl': this.imageUrl,
      });
    }
    return true;
  }

  Future<List<Map<String, DateTime>>> _getDayWork(String id) async {
    List<Map<String, DateTime>> dayWork = [];
    await FirebaseFirestore.instance
        .collection('Trip')
        .where('Driver', isEqualTo: 'User/$id')
        .get()
        .then((query) {
      query.docs.forEach((doc) {
        Map<String, Timestamp> time = doc.data()['Time'];
        time.forEach((key, value) {
          dayWork.add({key: DateTime.parse(value.toDate().toString())});
        });
      });
    });
    return Future.value(dayWork);
  }

  List<Map<String, DateTime>> get dayWorkList => _dayWorkLs;
}
