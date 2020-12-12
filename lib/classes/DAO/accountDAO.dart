import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

abstract class AccountDAO {
  String email;
  String name;
  String phone;
  @protected
  DateTime doB;
  @protected
  String gender;
  @protected
  String role;
  @protected
  String imageUrl;

  bool update({
    @required String id,
    String email,
    String password,
    String name,
    String phone,
    DateTime doB,
    String gender,
    File image,
  });

  @protected
  Future<String> uploadImage(File _image, String id, String path) async {
    String url;
    Reference storageReference = FirebaseStorage.instance.ref().child(path);
    UploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.then((snap) async {
      await snap.ref.getDownloadURL().then((value) => url = value);
    });
    return url;
  }
}
