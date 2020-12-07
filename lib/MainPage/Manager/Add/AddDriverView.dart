import 'dart:io';

import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:image_picker/image_picker.dart';

class AddDriverView extends StatefulWidget {
  @override
  _AddDriverViewState createState() => _AddDriverViewState();
}

class _AddDriverViewState extends State<AddDriverView> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController source = TextEditingController();
  final TextEditingController dest = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController seat = TextEditingController();
  final TextEditingController detail = TextEditingController();
  final TextEditingController dob = TextEditingController();
  DateTime date;
  File _image;
  Color borderColor = Colors.grey;
  final picker = ImagePicker();
  String dropDownValue = 'Male';

  void save_driver(
      // TODO: Save to db
      ) {}

  Future _getImg() async {
    final image = await picker.getImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Column(
      children: <Widget>[
        TextFormField(
          validator: Utils.validateEmpty,
          controller: price,
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
                readOnly: true,
              ),
            ),
            IconButton(
              onPressed: () async {
                date = await showRoundedDatePicker(
                    context: context,
                    firstDate: DateTime(DateTime.now().year - 100),
                    borderRadius: 16,
                    theme: ThemeData(primarySwatch: Colors.green));
                date != null
                    ? dob.text = date.toString().substring(0, 10)
                    // ignore: unnecessary_statements
                    : Null;
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
          controller: seat,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.phone,
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
            controller: seat,
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
          controller: detail,
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
          child: Center(
            child: RaisedButton(
              color: Utils.primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              onPressed: () {
                if (_key.currentState.validate() && _image != null)
                  save_driver();
                else
                  setState(() {
                    borderColor = Colors.red;
                  });
              },
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
                shape: BoxShape.circle, border: Border.all(color: borderColor)),
            child: CircleAvatar(
              foregroundColor: borderColor,
              backgroundColor: Colors.transparent,
              child: GestureDetector(
                onTap: _getImg,
                child: _image == null
                    ? Icon(Icons.add)
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Image.file(
                          _image,
                          height: 200,
                          fit: BoxFit.fitHeight,
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
