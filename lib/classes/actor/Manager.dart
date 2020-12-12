import 'dart:io';

import 'package:CoachTicketSelling/classes/DAO/accountDAO.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Manager extends AccountDAO {
  DocumentReference company;

  static Manager _manager = Manager._();
  static Manager get instance => _manager;
  Manager._() {
    role = 'Manager';
    String id = FirebaseAuth.instance.currentUser.uid;
    FirebaseFirestore.instance
        .collection('User')
        .doc(id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      company = documentSnapshot.data()['Company'];
      name = documentSnapshot.data()['Name'];
      phone = documentSnapshot.data()['Phone'];
      Timestamp timeStamp = documentSnapshot.data()['DoB'];
      doB = DateTime.tryParse(timeStamp.toDate().toString());
      gender = documentSnapshot.data()['Gender'];
      imageUrl = documentSnapshot.data()['ImageUrl'];
    });
    print('[DEBUG] Initiated Manager information');
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
