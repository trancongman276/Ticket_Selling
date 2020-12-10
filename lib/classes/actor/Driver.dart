import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Driver {
  String email;
  String name;
  String phone;
  DateTime doB;
  String gender;
  String role;
  String imageUrl;
  DocumentReference company;
  String note;

  Driver.none() {
    // Timestamp timestamp;
    // FirebaseFirestore.instance
    //     .collection('User')
    //     .doc(id)
    //     .get()
    //     .then((document) {
    //   this.company = document.data()['Company'];
    //   this.email = document.data()['Email'];
    //   this.name = document.data()['Name'];
    //   this.gender = document.data()['Gender'];
    //   timestamp = document.data()['DoB'];
    //   this.doB = DateTime.parse(timestamp.toDate().toString());
    //   this.phone = document.data()['Phone'];
    //   this.note = document.data()['Note'];
    //   this.imageUrl = document.data()['ImageUrl'];
    // });
  }
  Driver.id(String id) {}

  changePassword(String password) {
    FirebaseAuth.instance.currentUser.updatePassword(password);
  }
}
