import 'dart:io';

import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:CoachTicketSelling/Utils/Route.dart';
import 'package:CoachTicketSelling/classes/actor/AppUser.dart';
import 'package:CoachTicketSelling/classes/actor/Driver.dart';
import 'package:CoachTicketSelling/classes/actor/Manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  final String role;

  const Profile({Key key, @required this.role}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState(role);
}

class _ProfileState extends State<Profile> {
  final String role;
  // String fullName = 'Nguyen Huynh Phuong Thanh';
  String email;
  // String dobText = '2000-09-01';
  // String phone = '0123456789';
  String name;
  String gender;
  String company;
  String imageUrl;
  bool isEditing = false;

  GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController phone = TextEditingController();
  final TextEditingController note = TextEditingController();
  final TextEditingController dobText = TextEditingController();

  @override
  void dispose() {
    phone.dispose();
    note.dispose();
    dobText.dispose();
    super.dispose();
  }

  DateTime dob;
  File _imageFile;
  final picker = ImagePicker();

  _ProfileState(this.role) {
    switch (role) {
      case 'Manager':
        imageUrl = Manager.instance.imageUrl;
        dob = Manager.instance.doB;
        name = Manager.instance.name;
        email = Manager.instance.email;
        gender = Manager.instance.gender;
        phone.text = Manager.instance.phone;
        company = Manager.instance.company.name;
        break;
      case 'Driver':
        imageUrl = Driver.currentDriver.imageUrl;
        dob = Driver.currentDriver.doB;
        name = Driver.currentDriver.name;
        email = Driver.currentDriver.email;
        gender = Driver.currentDriver.gender;
        phone.text = Driver.currentDriver.phone;
        company = Driver.currentDriver.company.name;
        note.text = Driver.currentDriver.note;
        break;
      case 'User':
        imageUrl = AppUser.instance.imageUrl;
        dob = AppUser.instance.doB;
        name = AppUser.instance.name;
        email = AppUser.instance.email;
        gender = AppUser.instance.gender;
        phone.text = AppUser.instance.phone;
        break;
    }
    dobText.text = '${dob.day < 10 ? ('0' + dob.day.toString()) : dob.day}' +
        '-${dob.month < 10 ? ('0' + dob.month.toString()) : dob.month}' +
        '-${dob.year}';
  }

  Future _getImg() async {
    final image = await picker.getImage(
        source: ImageSource.gallery,
        maxWidth: 128.0,
        maxHeight: 128.0,
        imageQuality: 100);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future saveEdit() async {
    switch (role) {
      case 'Manager':
        await Manager.instance.update(
            doB: dob, gender: gender, phone: phone.text, image: _imageFile);
        break;
      case 'Driver':
        await Driver.currentDriver.update(
            doB: dob, gender: gender, phone: phone.text, image: _imageFile);
        break;
      case 'User':
        await AppUser.instance.update(
            doB: dob, gender: gender, phone: phone.text, image: _imageFile);
        break;
    }
    setState(() {
      isEditing = false;
    });
    return Future.value(true);
  }

  Future<bool> _onWillPop() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Leaving Without Saving'),
              content: Text('Do you want to discard all the changes?'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('No')),
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text('Yes')),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Column(
      children: <Widget>[
        TextFormField(
          initialValue: name,
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Name',
            labelStyle: TextStyle(
                color: Utils.primaryColor, fontWeight: FontWeight.bold),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Utils.primaryColor)),
          ),
        ),
        Row(
          children: <Widget>[
            Container(
              width: 150,
              child: TextFormField(
                validator: Utils.validateEmpty,
                decoration: InputDecoration(
                  labelText: 'Date Of Birth',
                  labelStyle: TextStyle(
                      color: Utils.primaryColor, fontWeight: FontWeight.bold),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Utils.primaryColor,
                    ),
                  ),
                ),
                controller: dobText,
                readOnly: true,
              ),
            ),
            if (isEditing)
              IconButton(
                onPressed: () async {
                  DateTime now = DateTime.now();
                  DateTime _date;
                  _date = await showRoundedDatePicker(
                      context: context,
                      firstDate: DateTime(
                          DateTime.now().year - 100, now.month, now.day),
                      lastDate: DateTime(now.year - 18, now.month, now.day + 1),
                      initialDate: dob,
                      borderRadius: 16,
                      theme: ThemeData(primarySwatch: Colors.green));
                  if (_date != null) {
                    dobText.text =
                        '${_date.day < 10 ? ('0' + _date.day.toString()) : _date.day}' +
                            '-${_date.month < 10 ? ('0' + _date.month.toString()) : _date.month}' +
                            '-${_date.year}';
                    dob = _date;
                  }
                },
                icon: Icon(Icons.calendar_today),
                color: Utils.primaryColor.withBlue(10),
              ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: DropdownButton<String>(
                  underline: Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  value: gender,
                  disabledHint: Text(gender),
                  items: <String>['Male', 'Female', 'Other']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: isEditing
                      ? (String newValue) {
                          setState(() {
                            gender = newValue;
                          });
                        }
                      : null,
                ),
              ),
            ),
          ],
        ),
        TextFormField(
          cursorColor: Utils.primaryColor,
          validator: (value) => Utils.validateNumber(value, 9, 12),
          controller: phone,
          readOnly: !isEditing,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.phone,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          decoration: InputDecoration(
            hintText: '0123xxxxx',
            labelText: 'Phone',
            labelStyle: TextStyle(
                color: Utils.primaryColor, fontWeight: FontWeight.bold),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Utils.primaryColor)),
          ),
        ),
        if (role != 'User')
          TextFormField(
            readOnly: true,
            initialValue: company,
            decoration: InputDecoration(
              labelText: 'Company',
              labelStyle: TextStyle(
                  color: Utils.primaryColor, fontWeight: FontWeight.bold),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Utils.primaryColor)),
            ),
          ),
        Padding(
          padding: EdgeInsets.only(bottom: 30.0),
          child: TextFormField(
            readOnly: true,
            initialValue: email,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(
                  color: Utils.primaryColor, fontWeight: FontWeight.bold),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Utils.primaryColor)),
            ),
          ),
        ),
        if (role == 'Driver')
          TextFormField(
            minLines: 4,
            maxLines: 10,
            controller: note,
            readOnly: !isEditing,
            validator: Utils.validateEmpty,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: 'Note',
              alignLabelWithHint: true,
              labelStyle: TextStyle(
                  color: Utils.primaryColor, fontWeight: FontWeight.bold),
              hintText: 'Write something awesome about you.',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Utils.primaryColor)),
            ),
          ),
        Padding(
          padding: EdgeInsets.all(5.0),
          child: RaisedButton(
            color: Utils.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            onPressed: () async {
              if (isEditing) {
                if (_key.currentState.validate()) {
                  await saveEdit();
                }
              } else {
                Navigator.pushNamed(context, ChangePasswordViewRoute,
                    arguments: role);
              }
            },
            child: Text(
              isEditing ? 'Save' : 'Change Password',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );

    return WillPopScope(
      onWillPop: isEditing ? _onWillPop : null,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile',
            style: TextStyle(fontSize: 25.0),
          ),
          centerTitle: true,
          backgroundColor: Utils.primaryColor,
          actions: [
            if (!isEditing)
              GestureDetector(
                onTap: () {
                  setState(() {
                    isEditing = true;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey)),
                child: GestureDetector(
                  onTap: isEditing ? _getImg : null,
                  child: CircleAvatar(
                    foregroundColor: Colors.grey,
                    backgroundColor: Colors.transparent,
                    child: _imageFile == null
                        ? (imageUrl == null
                            ? Icon(
                                Icons.add,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: Image.network(
                                  imageUrl,
                                  width: 150,
                                  fit: BoxFit.fitWidth,
                                  height: 150,
                                ),
                              ))
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: Image.file(
                              _imageFile,
                              height: 150,
                              width: 150,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            Form(
                key: _key,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: body,
                )),
          ],
        ),
      ),
    );
  }
}
