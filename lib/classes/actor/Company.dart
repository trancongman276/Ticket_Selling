import 'package:cloud_firestore/cloud_firestore.dart';

class Company {
  String _id;
  String _name;
  String _imageUrl;
  Map<String, List<String>> _route = {};
  DocumentReference documentReference;

  Company.none();

  Future getData(DocumentReference companyDoc) async {
    documentReference = companyDoc;
    await companyDoc.get().then((doc) {
      this._id = doc.id;
      this._name = doc.data()['Name'];
      this._imageUrl = doc.data()['ImageUrl'];
      this._route = Map<String, dynamic>.from(doc.data()['Route'])
          .map((key, value) => MapEntry(key, List<String>.from(value)));
    });
  }

  String get name => _name;
  String get id => _id;
  String get imageUrl => _imageUrl;
  Map<String, List<String>> get route => _route;
}
