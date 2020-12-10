import 'dart:io';

import 'package:CoachTicketSelling/classes/DAO/accountDAO.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Manager extends AccountDAO {
  DocumentReference company;

  static Manager _manager = Manager._();
  static Manager get instance => _manager;
  Manager._() {
    // String id = FirebaseAuth.instance.currentUser.uid;
    this.company = null;
  }

  @override
  bool add(String email, String name, String phone, DateTime doB, String gender,
      File image) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  bool delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

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
    // TODO: implement update
    throw UnimplementedError();
  }
}
