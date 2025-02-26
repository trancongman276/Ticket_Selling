import 'dart:io';

import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:CoachTicketSelling/classes/Implement/DriverImpl.dart';
import 'package:CoachTicketSelling/classes/actor/Driver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:image_picker/image_picker.dart';

class AddDriverView extends StatefulWidget {
  final String driverID;

  const AddDriverView({Key key, this.driverID}) : super(key: key);
  @override
  _AddDriverViewState createState() => _AddDriverViewState(driverID);
}

class _AddDriverViewState extends State<AddDriverView> {
  final String driverID;
  DriverImpl driverImpl = DriverImpl.instance;
  Driver driver;
  _AddDriverViewState(this.driverID) {
    if (driverID != null) {
      driver = driverImpl.driverList[driverID];
      name.text = driver.name;
      phone.text = driver.phone;
      email.text = driver.email;
      note.text = driver.note;
      dob.text =
          '${driver.doB.year}-${driver.doB.month < 10 ? ('0' + driver.doB.month.toString()) : driver.doB.month}' +
              '-${driver.doB.day < 10 ? ('0' + driver.doB.day.toString()) : driver.doB.day}';
      date = DateTime.parse(dob.text);
      imageUrl = driver.imageUrl;
      dropDownValue = driver.gender;
    } else {
      date = DateTime(
          DateTime.now().year - 18, DateTime.now().month, DateTime.now().day);
    }
  }

  GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController note = TextEditingController();
  final TextEditingController dob = TextEditingController();
  DateTime date;
  File _imageFile;
  String imageUrl;
  Color borderColor = Colors.grey;
  final picker = ImagePicker();
  String dropDownValue = 'Male';

  void reset() {
    name.text = '';
    phone.text = '';
    email.text = '';
    note.text = '';
    dob.text = '';
    _imageFile = null;
    borderColor = Colors.grey;
    setState(() {});
  }

  Future<bool> _showDialog() async {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete this driver'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Are you sure you want to delete this driver?'),
                  Text('By approving this, this driver will be fired.'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        });
  }

  Future<bool> _showAlertDialog() async {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Duplicate Driver'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('This Driver already existed.'),
                  Text('Please update this Driver in Manage page.'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }

  void deleteDriver() {
    _showDialog().then((value) {
      if (value == true) {
        driverImpl.delete(driverID);
        Navigator.pop(context);
      }
    });
  }

  void saveDriver() {
    if (driverID != null) {
      driverImpl.update(
        id: driverID,
        email: email.text,
        phone: phone.text,
        name: name.text,
        gender: dropDownValue,
        note: note.text,
        doB: DateTime.tryParse(dob.text),
        image: _imageFile,
      );
      Navigator.pop(context);
    } else {
      driverImpl
          .add(email.text.trim(), name.text.trim(), phone.text,
              DateTime.parse(dob.text), dropDownValue, _imageFile,
              note: note.text)
          .then((value) {
        if (!value) {
          _showAlertDialog();
        }
      });
      _key.currentState.reset();
      reset();
    }
  }

  Future _getImg() async {
    imageUrl = null;
    final image = await picker.getImage(
        source: ImageSource.gallery, maxWidth: 500, maxHeight: 500);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Column(
      children: <Widget>[
        TextFormField(
          validator: Utils.validateEmpty,
          controller: name,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            hintText: 'Driver name',
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
                controller: dob,
                enabled: false,
              ),
            ),
            IconButton(
              onPressed: () async {
                DateTime now = DateTime.now();
                DateTime _date;
                _date = await showRoundedDatePicker(
                    context: context,
                    firstDate:
                        DateTime(DateTime.now().year - 100, now.month, now.day),
                    lastDate: DateTime(now.year - 18, now.month, now.day + 1),
                    initialDate: date,
                    borderRadius: 16,
                    theme: ThemeData(primarySwatch: Colors.green));
                if (_date != null) {
                  dob.text = date.toString().substring(0, 10);
                  date = _date;
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
                  disabledHint: Text('Driver'),
                  value: dropDownValue,
                  items: <String>['Male', 'Female', 'Other']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String newValue) {
                    setState(() {
                      dropDownValue = newValue;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        TextFormField(
          cursorColor: Utils.primaryColor,
          validator: (value) => Utils.validateNumber(value, 9, 12),
          controller: phone,
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
        Padding(
          padding: EdgeInsets.only(bottom: 30.0),
          child: TextFormField(
            cursorColor: Utils.primaryColor,
            validator: Utils.validateEmail,
            controller: email,
            enabled: driverID == null ? true : false,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'abc@abc.com',
              labelText: 'Email',
              labelStyle: TextStyle(
                  color: Utils.primaryColor, fontWeight: FontWeight.bold),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Utils.primaryColor)),
            ),
          ),
        ),
        TextFormField(
          minLines: 4,
          maxLines: 10,
          controller: note,
          validator: Utils.validateEmpty,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: 'Note',
            alignLabelWithHint: true,
            labelStyle: TextStyle(
                color: Utils.primaryColor, fontWeight: FontWeight.bold),
            hintText: 'Give some note about this driver.',
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Utils.primaryColor)),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(5.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            RaisedButton(
              color: Utils.primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              onPressed: () {
                if (_key.currentState.validate()) {
                  if (_imageFile != null || imageUrl != null)
                    saveDriver();
                  else
                    setState(() {
                      borderColor = Colors.red;
                    });
                }
              },
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
            if (driverID != null)
              RaisedButton(
                color: Utils.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                onPressed: () {
                  deleteDriver();
                },
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ]),
        ),
      ],
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
                shape: BoxShape.circle, border: Border.all(color: borderColor)),
            child: GestureDetector(
              onTap: _getImg,
              child: CircleAvatar(
                foregroundColor: borderColor,
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
                              width: 200.0,
                              fit: BoxFit.fitWidth,
                            ),
                          ))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Image.file(
                          _imageFile,
                          height: 200,
                          width: 200,
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
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: body,
            )),
      ],
    );
  }
}
