import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

abstract class AccountDAO {
  String email;
  String name;
  String phone;
  DateTime doB;
  String gender;
  String role;
  String imageUrl;

  Future<bool> update({
    String email,
    String password,
    String name,
    String phone,
    DateTime doB,
    String gender,
    File image,
  });

  @protected
  Future<String> uploadImage(File _image, String path) async {
    String url = '';
    print(path);
    Reference storageReference = FirebaseStorage.instance.ref().child(path);
    UploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.then((snap) async {
      await snap.ref.getDownloadURL().then((value) => url = value);
    });
    return Future.value(url);
  }
}
