import 'dart:io';

import 'package:CoachTicketSelling/classes/DAO/accountDAO.dart';
import 'package:CoachTicketSelling/classes/actor/Company.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Manager extends AccountDAO {
  Company company;
  String id;

  static Manager _manager = Manager._();
  static Manager get instance => _manager;
  Manager._() {
    print('[DEBUG] Initiated Manager information');
  }
  static bool kill() {
    _manager = Manager._();
    return true;
  }

  Future getData() async {
    role = 'Manager';
    id = FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance
        .collection('User')
        .doc(id)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      this.company = Company.none();
      await company.getData(documentSnapshot.data()['Company']);
      this.name = documentSnapshot.data()['Name'];
      this.phone = documentSnapshot.data()['Phone'];
      this.email = documentSnapshot.data()['Email'];
      Timestamp timeStamp = documentSnapshot.data()['DoB'];
      this.doB = DateTime.tryParse(timeStamp.toDate().toString());
      this.gender = documentSnapshot.data()['Gender'];
      this.imageUrl = documentSnapshot.data()['ImageUrl'];
    });
  }

  @override
  Future<bool> update(
      {String email,
      String password,
      String name,
      String phone,
      DateTime doB,
      String gender,
      File image}) async {
    if (password != null) {
      FirebaseAuth.instance.currentUser.updatePassword(password);
    } else {
      this.phone = phone;
      this.doB = doB;
      this.gender = gender;
      if (image != null) {
        String ex = image.path.split('.').last;
        await uploadImage(image, '/Manager/${this.id}.$ex')
            .then((value) => this.imageUrl = value);
      }
      await FirebaseFirestore.instance.collection('User').doc(id).set({
        'Company': this.company.documentReference,
        'Name': this.name,
        'Phone': this.phone,
        'Email': this.email,
        'DoB': Timestamp.fromDate(this.doB),
        'Gender': this.gender,
        'ImageUrl': this.imageUrl,
        'Role': 'Manager',
      });
    }

    return true;
  }
}
