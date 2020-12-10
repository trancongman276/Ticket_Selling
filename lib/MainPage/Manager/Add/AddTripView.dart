import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:CoachTicketSelling/classes/Implement/DriverImpl.dart';
import 'package:CoachTicketSelling/classes/Implement/TripImpl.dart';
import 'package:CoachTicketSelling/classes/actor/Driver.dart';
import 'package:CoachTicketSelling/classes/actor/Manager.dart';
import 'package:CoachTicketSelling/classes/actor/Trip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

class AddTripView extends StatefulWidget {
  final String tripID;

  const AddTripView({Key key, this.tripID}) : super(key: key);
  @override
  _AddTripViewState createState() => _AddTripViewState(tripID);
}

class _AddTripViewState extends State<AddTripView> {
  final String tripID;
  DriverImpl driverImpl = DriverImpl.instance;
  TripImplement tripImplement = TripImplement.instance;

  _AddTripViewState(this.tripID) {
    if (tripID != null) {
      Trip trip = tripImplement.getTrip(tripID);

      source.text = trip.source;
      dest.text = trip.destination;
      price.text = trip.price.toString();
      seat.text = trip.totalSeat.toString();
      detail.text = trip.detail;
    }
    driverLs.addAll(List.generate(driverImpl.len(), (index) {
      Driver driver =
          driverImpl.driverList[driverImpl.driverList.keys.elementAt(index)];
      return '$index. ' + driver.name;
    }));
    choosingDriver = driverLs[0];
  }

  GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController source = TextEditingController();
  final TextEditingController dest = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController seat = TextEditingController();
  final TextEditingController detail = TextEditingController();
  // File _image;
  // final picker = ImagePicker();
  // Color borderColor = Colors.grey;
  String choosingDriver = 'Driver';
  List<String> driverLs = ['Driver'];

  Future<bool> _showDialog() async {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete this trip'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Are you sure you want to delete this trip?'),
                  Text(
                      'All of the payments will be return and users will be announced.'),
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

  void deleteTrip() {
    _showDialog().then((value) {
      if (value == true) {
        tripImplement.delete(tripID);
        Navigator.pop(context);
      }
    });
  }

  void saveTrip() {
    if (tripID != null) {
      // trip.source = source.text.trim();
      // trip.destination = dest.text.trim();
      // trip.price = int.tryParse(price.text);
      // trip.totalSeat = int.tryParse(seat.text);
      // trip.detail = detail.text;
      tripImplement.update(source.text.trim(), dest.text.trim(),
          int.tryParse(price.text), int.tryParse(seat.text), detail.text);
      Navigator.pop(context);
    } else {
      tripImplement.add(source.text.trim(), dest.text.trim(),
          int.parse(price.text), int.parse(seat.text), detail.text, null);
      // Manager.instance.company);
      _key.currentState.reset();
      source.text = '';
      dest.text = '';
      price.text = '';
      seat.text = '';
      choosingDriver = 'Driver';
      detail.text = '';
      setState(() {});
    }
  }

  // Future _getImg() async {
  //   final image = await picker.getImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     setState(() {
  //       _image = File(image.path);
  //     });
  //   }
  // }

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
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(bottom: 30.0, top: 10.0),
          child: DropdownButton<String>(
            underline: Container(
              height: 1,
              color: Colors.grey,
            ),
            value: choosingDriver,
            items: driverLs.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String newValue) {
              setState(() {
                choosingDriver = newValue;
              });
            },
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  color: Utils.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  onPressed: () {
                    // if (_key.currentState.validate() && _image != null)
                    if (_key.currentState.validate()) saveTrip();
                    // else
                    //   setState(() {
                    //     borderColor = Colors.red;
                    //   });
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                if (tripID != null)
                  RaisedButton(
                    color: Utils.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    onPressed: () {
                      deleteTrip();
                    },
                    child: Text(
                      'Delete',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );

    return Column(
      children: <Widget>[
        // Row(
        //   children: [
        //     Expanded(
        //       child: Padding(
        //         padding: EdgeInsets.all(10.0),
        //         child: GestureDetector(
        //           onTap: _getImg,
        //           child: _image == null
        //               ? Container(
        //                   height: 100.0,
        //                   decoration: BoxDecoration(
        //                       border:
        //                           Border.all(width: 1.0, color: borderColor)),
        //                   child: Icon(
        //                     Icons.add,
        //                     size: 50.0,
        //                     color: borderColor,
        //                   ),
        //                 )
        //               : Image.file(
        //                   _image,
        //                   fit: BoxFit.fitWidth,
        //                 ),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
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
