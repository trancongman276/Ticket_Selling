import 'dart:io';

import 'package:CoachTicketSelling/classes/DAO/accountDAO.dart';
import 'package:CoachTicketSelling/classes/actor/Company.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Manager extends AccountDAO {
  Company company;

  static Manager _manager = Manager._();
  static Manager get instance => _manager;
  Manager._() {
    print('[DEBUG] Initiated Manager information');
  }

  Future getData() async {
    role = 'Manager';
    String id = FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance
        .collection('User')
        .doc(id)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      this.company = Company.none();
      await company.getData(documentSnapshot.data()['Company']);
      this.name = documentSnapshot.data()['Name'];
      this.phone = documentSnapshot.data()['Phone'];
      Timestamp timeStamp = documentSnapshot.data()['DoB'];
      this.doB = DateTime.tryParse(timeStamp.toDate().toString());
      this.gender = documentSnapshot.data()['Gender'];
      this.imageUrl = documentSnapshot.data()['ImageUrl'];
    });
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
