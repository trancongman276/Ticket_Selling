import 'dart:convert';
import 'dart:io';

import 'package:CoachTicketSelling/classes/Implement/DriverImpl.dart';
import 'package:CoachTicketSelling/classes/Implement/TripImpl.dart';
import 'package:CoachTicketSelling/classes/actor/Manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class Utils {
  // Variables
  static final AssetImage _loginBackground =
      AssetImage('assets/images/loginBG.png');
  static final AssetImage _registerBackground =
      AssetImage('assets/images/Login/registerBG.jpg');
  static final Image _logo = Image.asset('assets/images/logo.png');

  // FireBase
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Data
  static final FlutterSecureStorage _storage = FlutterSecureStorage();
  static final String _defaultUrl =
      'https://firebasestorage.googleapis.com/v0/b/coachticketselling.appspot.com/o/default.png?alt=media&token=f0e176fe-fcfa-46e8-af4f-5e0c85267de2';

  // Styles
  static final Map<String, TextStyle> styles = {
    'NormalText': TextStyle(),
  };
  static final Color _primaryColor = Color(0xff2ecc71);

  // Func
  static String validateEmail(String value) {
    value = value.trim();
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  static String validatePassword(String value) {
    if (value.length < 6) {
      return 'Wrong password format';
    }
    return null;
  }

  static String validateRetypePassword(String value, String password) {
    if (value != password) {
      return "Wrong password confirmation";
    }
    return null;
  }

  static String validateEmpty(String value) {
    if (value.isEmpty || value == 'yyyy-mm-dd') {
      return 'Please fill the empty';
    }
    return null;
  }

  static String validateNumber(String value, int minLen, int maxLen) {
    if (value.isEmpty) {
      return 'Please fill the empty';
    }

    if (value.length >= maxLen || value.length <= minLen) {
      return 'Wrong number length';
    }
    return null;
  }

  static Future<void> logout() async {
    await storage.delete(key: 'e');
    await storage.delete(key: 'p');
  }

  static Future<Map> toJson(CollectionReference collectionReference) async {
    Map<String, Map<String, dynamic>> allData = {};
    await FirebaseFirestore.instance.collection('User').get().then((query) {
      Map<String, Map<String, dynamic>> data = Map.fromIterable(query.docs,
          key: (e) => e.id,
          value: (e) {
            Map<String, dynamic> tempMap = e.data();
            Timestamp timestamp = e.data()['DoB'];
            tempMap['DoB'] = _dateFormat
                .format(DateTime.parse(timestamp.toDate().toString()));
            if (e.data()['Company'] != null) {
              DocumentReference ref = e.data()['Company'];
              tempMap['Company'] = '/Company/${ref.id}';
            }
            QueryDocumentSnapshot _e = e;
            if (e.data()['Role'] == 'User') {
              CollectionReference billRef = FirebaseFirestore.instance
                  .collection('User')
                  .doc(_e.id)
                  .collection('Bill');

              billRef.get().then((value) {
                Map<String, dynamic> billLs = {};
                billLs = Map.fromIterable(value.docs,
                    key: (e) => e.id,
                    value: (e) {
                      billRef
                          .doc(e.id)
                          .collection('Ticket')
                          .get()
                          .then((value) {
                        Map<String, dynamic> ticketLs =
                            Map.fromIterable(value.docs,
                                key: (e) => e.id,
                                value: (e) {
                                  Map<String, dynamic> tempMap = e.data();
                                  tempMap['Trip'] =
                                      '/Trip/${e.data()['Trip'].id}';
                                  return tempMap;
                                });
                        billLs[e.id]['Ticket'] = ticketLs;
                      });
                      Map<String, dynamic> tempMap = e.data();
                      tempMap['Time'] = _dateFormat.format(
                          DateTime.parse(e.data()['Time'].toDate().toString()));
                      return tempMap;
                    });
                tempMap['Bill'] = billLs;
              });
            }
            return tempMap;
          });
      allData['User'] = data;
    });

    await FirebaseFirestore.instance.collection('Trip').get().then((query) {
      Map<String, Map<String, dynamic>> data = Map.fromIterable(query.docs,
          key: (e) => e.id,
          value: (e) {
            Map<String, dynamic> tempMap = e.data();
            Map<String, Timestamp> tempTime =
                Map<String, Timestamp>.from(e.data()['Time']);
            Map<String, String> tempString = {
              'Start Time': _dateFormat.format(
                  DateTime.parse(tempTime['Start Time'].toDate().toString())),
              'Finish Time': _dateFormat.format(
                  DateTime.parse(tempTime['Finish Time'].toDate().toString()))
            };
            tempMap['Time'] = tempString;

            if (e.data()['Company'] != null) {
              DocumentReference ref = e.data()['Company'];
              tempMap['Company'] = '/Company/${ref.id}';
            }
            if (e.data()['Driver'] != null) {
              DocumentReference ref = e.data()['Driver'];
              tempMap['Driver'] = '/User/${ref.id}';
            }
            return tempMap;
          });
      allData['Trip'] = data;
    });

    await FirebaseFirestore.instance.collection('Company').get().then((query) {
      Map<String, Map<String, dynamic>> data = Map.fromIterable(
        query.docs,
        key: (e) => e.id,
        value: (e) {
          Map<String, dynamic> tempMap = e.data();
          return tempMap;
        },
      );
      allData['Company'] = data;
    });
    var result = json.encode(allData);

    String dir = (await getTemporaryDirectory()).path;
    File temp = new File('$dir/db.json');
    await temp.writeAsString(result);

    DriverImpl.instance.uploadImage(temp, '/db.json').then((value) {
      print('Url: $value');
      temp.delete();
    });
    return Future.value(allData);
  }
  

  static DateFormat _dateFormat = DateFormat('dd/MM/yyyy HH:mm');
  // Getter
  static AssetImage get loginBackground => _loginBackground;

  static AssetImage get registerBackground => _registerBackground;

  static Image get logo => _logo;

  static FirebaseAuth get firebaseAuth => _firebaseAuth;

  static FirebaseFirestore get firebase => _firebase;

  static GoogleSignIn get googleSignIn => _googleSignIn;

  static FlutterSecureStorage get storage => _storage;

  static Color get primaryColor => _primaryColor;

  static String get defaultUrl => _defaultUrl;

  static DateFormat get dateFormat => _dateFormat;
}
