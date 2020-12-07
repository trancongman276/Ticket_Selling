import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AddTripView extends StatefulWidget {
  @override
  _AddTripViewState createState() => _AddTripViewState();
}

class _AddTripViewState extends State<AddTripView> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController source = TextEditingController();
  final TextEditingController dest = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController seat = TextEditingController();
  final TextEditingController detail = TextEditingController();
  File _image;
  final picker = ImagePicker();
  Color borderColor = Colors.grey;

  void save_trip() {
    // TODO: Save to db
  }

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
        Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                controller: source,
                validator: Utils.validateEmpty,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    hintText: 'From',
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Utils.primaryColor))),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Icon(Icons.arrow_forward_rounded),
            Expanded(
              child: TextFormField(
                controller: dest,
                validator: Utils.validateEmpty,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    hintText: 'To',
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Utils.primaryColor))),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        TextFormField(
          validator: Utils.validateEmpty,
          controller: price,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: 'Input price',
            labelText: 'Price',
            labelStyle: TextStyle(
                color: Utils.primaryColor, fontWeight: FontWeight.bold),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Utils.primaryColor)),
          ),
        ),
        TextFormField(
          cursorColor: Utils.primaryColor,
          validator: Utils.validateEmpty,
          controller: seat,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: 'Input available seat',
            labelText: 'Available Seat',
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
            validator: Utils.validateEmpty,
            controller: seat,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'Driver ID',
              labelText: 'Driver',
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
            labelText: 'Detail',
            alignLabelWithHint: true,
            labelStyle: TextStyle(
                color: Utils.primaryColor, fontWeight: FontWeight.bold),
            hintText: 'Give some detail about the trip',
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
                  save_trip();
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
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: _getImg,
                  child: _image == null
                      ? Container(
                          height: 100.0,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1.0, color: borderColor)),
                          child: Icon(
                            Icons.add,
                            size: 50.0,
                            color: borderColor,
                          ),
                        )
                      : Image.file(
                          _image,
                          fit: BoxFit.fitWidth,
                        ),
                ),
              ),
            ),
          ],
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
