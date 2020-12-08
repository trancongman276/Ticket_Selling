import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

/**before you use these functions dont forget to add
    Firebase.initializeApp().whenComplete(() {
    print("completed");
    setState(() {});
    });

    in the UI that you want to use these functions.**/

void addTrip() {
  final firestoreInstance = FirebaseFirestore.instance;

  // CollectionReference Trip = FirebaseFirestore.instance.collection('Trip1');

  firestoreInstance.collection("Trip").add({
    "Total Seat": "25",
    "Detail": "Visit",
    "Source": "Hà Nội",
    "Destination": "Đồng Nai",
    "Price": 250000,
    "Time": Timestamp.now(),
    "Company ID": firestoreInstance.collection("Trip").doc('Trip' + "C1"),
    "Driver ID": firestoreInstance.collection("Trip").doc('Trip' + "D1"),
    "Seat": {
      "Seat ID": "1",
      "Seat Num": "15",
    },
  }).then((value) {
    print(value.id);
  });
}

void addCompany() {
  final firestoreInstance = FirebaseFirestore.instance;
  firestoreInstance.collection("Company").add({
    "Company Name": "Thành Bưởi",
    "Image": "Url",
  }).then((value) {
    print(value.id);
  });
}

void addBill() {
  final firestoreInstance = FirebaseFirestore.instance;
  firestoreInstance.collection("Bill").add({
    "Cost": 1000000,
    "Ticket": "Thành Bưởi",
    "Time": Timestamp.now(),

  }).then((value) {
    print(value.id);
  ;
  firestoreInstance.collection('Bill').doc(value.id).collection('Ticket').add({
    "Seat Num": 25,
    "Trip ID":1,
    "Rating": "Good",
  });

    });
}

void addUser(){
  final firestoreInstance = FirebaseFirestore.instance;
  firestoreInstance.collection("User").add({
    "Name": "NVS",
    "Role":"Manager",
    "Phone":"01238794564",
    "Dob":"1606150800000000",
    "Gender":"Male",
    "Image":"https://cdn4.iconfinder.com/data/icons/small-n-flat/24/user-alt-512.png",
    "Mail":"NVS@gmail.com",
    "Company ID":"C1",
    "Detail":"Vist",
    "Bill": firestoreInstance.collection("User").doc('User' + "B1"),
    "Trip": firestoreInstance.collection("Trip").doc('Trip' + "T1"),

  }).then((value) {
    print(value.id);
  });
}

void getAllTrip() {
  final firestoreInstance = FirebaseFirestore.instance;
  firestoreInstance.collection("Trip").get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      print(result.data());
    });
  });
}

void getCompany() {
  final firestoreInstance = FirebaseFirestore.instance;
  firestoreInstance.collection("Company").get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      print(result.data());
    });
  });
}
void getAllUser() {
  final firestoreInstance = FirebaseFirestore.instance;
  firestoreInstance.collection("User").get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      print(result.data());
    });
  });
}
void getAllBill() {
  final firestoreInstance = FirebaseFirestore.instance;
  firestoreInstance.collection("Bill").get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      print(result.data());
    });
  });
}


void getTicket() {
  final firestoreInstance = FirebaseFirestore.instance;
  firestoreInstance.collection("Company").get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      firestoreInstance
          .collection("Company")
          .doc(result.id)
          .collection("Ticket")
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          print(result.data());
        });
      });
    });
  });
}

Future<void> updatePassword(String password) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var firebaseUser = await _auth.currentUser;
  firebaseUser.updatePassword(password);
}



