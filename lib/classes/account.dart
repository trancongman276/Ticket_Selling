import 'package:cloud_firestore/cloud_firestore.dart';
import 'accountDAO.dart';

class Account implements AccountDAO {
  String id;
  String email;
  String name;
  String phone;
  DateTime doB;
  String gender;
  String role;

  static final Account _instance = Account._();

  static Account get instance => _instance;

  Account._();

  @override
  create() {
    FirebaseFirestore.instance.collection('User').doc(id).set({
      'Email': email,
      'Name': name,
      'Phone': phone,
      'DoB': doB.microsecondsSinceEpoch,
      'Gender': gender,
      'Role': role,
    });
  }

  @override
  load(String id) {
    Timestamp timestamp;
    this.id = id;
    FirebaseFirestore.instance.collection('User').doc(id).get().then((doc) => {
          email = doc.data()['Email'],
          name = doc.data()['Name'],
          phone = doc.data()['Phone'],
          timestamp = doc.data()['Dob'],
          doB = DateTime.parse(timestamp.toDate().toString()),
          gender = doc.data()['Gender'],
          role = doc.data()['Role'],
        });
  }

  @override
  update(String email, String name, String phone, DateTime doB, String gender,
      String role) {
    this.email = email.trim();
    this.name = name.trim();
    this.phone = phone.trim();
    this.doB = doB;
    this.gender = gender;
    this.role = role;
    create();
  }
}
