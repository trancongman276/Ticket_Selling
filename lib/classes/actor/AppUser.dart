import 'dart:io';

import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:CoachTicketSelling/classes/DAO/accountDAO.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppUser extends AccountDAO {
  static AppUser _instance = AppUser._();
  static AppUser get instance => _instance;
  AppUser._();
  @override
  bool update(
      {String id,
      String email,
      String password,
      String name,
      String phone,
      DateTime doB,
      String gender,
      File image}) {
    if (password != null) {
      FirebaseAuth.instance.currentUser.updatePassword(password);
    } else {
      this.email = email ?? this.email;
      this.name = name ?? this.name;
      this.phone = phone ?? this.phone;
      this.doB = doB ?? this.doB;
      this.gender = gender ?? this.gender;

      if (image != null) {
        String ex = image.path.split('.').last;
        uploadImage(image, id, 'User/$id.$ex')
            .then((url) => this.imageUrl = url);
      }

      FirebaseFirestore.instance.collection('User').doc(id).set({
        'Email': this.email,
        'Name': this.name,
        'Phone': this.phone,
        'DoB': Timestamp.fromDate(doB),
        'Gender': this.gender,
        'ImageUrl': this.imageUrl ?? Utils.defaultUrl,
        'Role': 'User',
      });
    }
    return true;
  }

  bool getUser([String id]) {
    FirebaseFirestore.instance
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
    });
    return true;
  }
}
