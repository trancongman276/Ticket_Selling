import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:CoachTicketSelling/classes/Implement/DriverImpl.dart';
import 'package:CoachTicketSelling/classes/Implement/TripImpl.dart';
import 'package:CoachTicketSelling/classes/actor/Driver.dart';
import 'package:CoachTicketSelling/classes/actor/Trip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
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

      selectedEndDate = selectedStartDate = true;

      dateStart.text = Utils.dateFormat.format(trip.time['Start Time']);
      dateEnd.text = Utils.dateFormat.format(trip.time['Finish Time']);
      choosingDriver = driverImpl.driverList[trip.driver.id].name;
      freeDriverLs = [choosingDriver];
    }
  }

  List<String> getDriverLs(String start, String end) {
    List<String> _freeDriverLs = ['Driver'];
    driverLs = driverImpl.getFreeDriver(start, end);
    _freeDriverLs.addAll(List.generate(driverLs.length, (index) {
      Driver driver = driverLs[index];
      return '$index. ' + driver.name;
    }));
    return _freeDriverLs;
  }

  GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController source = TextEditingController();
  final TextEditingController dest = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController seat = TextEditingController();
  final TextEditingController detail = TextEditingController();
  final TextEditingController dateStart = TextEditingController();
  final TextEditingController dateEnd = TextEditingController();
  String errorMessage = '';
  // File _image;
  // final picker = ImagePicker();
  // Color borderColor = Colors.grey;
  String choosingDriver = 'Driver';
  List<Driver> driverLs;
  List<String> freeDriverLs = ['Driver'];
  ThemeData themeData = ThemeData(primarySwatch: Colors.green);
  bool selectedStartDate = false;
  bool selectedEndDate = false;

  Future<DateTime> dateTimePicker(DateTime initDate, TimeOfDay initTime) async {
    DateTime date;
    TimeOfDay time;
    await showRoundedDatePicker(
      context: context,
      theme: themeData,
      initialDate: initDate,
      firstDate: initDate,
    ).then((pickedDate) async {
      if (pickedDate != null) {
        date = pickedDate;

        await showRoundedTimePicker(
          context: context,
          initialTime: initTime,
          theme: themeData,
        ).then((pickedTime) {
          if (pickedTime != null) {
            time = pickedTime;
          } else
            return null;
        });
      } else
        return null;
    });

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

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
      tripImplement.update(tripID,
          source: source.text.trim(),
          destination: dest.text.trim(),
          price: int.tryParse(price.text),
          detail: detail.text);
      Navigator.pop(context);
    } else {
      tripImplement.add(
          source.text.trim(),
          dest.text.trim(),
          int.parse(price.text),
          int.parse(seat.text),
          FirebaseFirestore.instance
              .collection('User')
              .doc(driverLs[freeDriverLs.indexOf(choosingDriver)].id),
          detail.text,
          null);
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
    Widget chooseDate(
      String label,
      TextEditingController controller,
      DateTime startDate,
      TimeOfDay startTime,
    ) {
      return Container(
        child: Row(
          children: [
            Container(
              width: 135,
              child: TextFormField(
                validator: Utils.validateEmpty,
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: TextStyle(
                      color: Utils.primaryColor, fontWeight: FontWeight.bold),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Utils.primaryColor,
                    ),
                  ),
                ),
                controller: controller,
                readOnly: true,
              ),
            ),
            IconButton(
              onPressed: () async {
                dateTimePicker(startDate, startTime).then((datetime) {
                  if (datetime != null) {
                    controller.text = Utils.dateFormat.format(datetime);
                    setState(() {
                      selectedStartDate = true;
                      if (dateEnd.text.isNotEmpty) {
                        selectedEndDate = true;
                        freeDriverLs =
                            getDriverLs(dateStart.text, dateEnd.text);
                      }
                    });
                  }
                });
              },
              icon: Icon(Icons.calendar_today),
              color: Utils.primaryColor.withBlue(10),
            ),
          ],
        ),
      );
    }

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
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              chooseDate(
                  'Start at',
                  dateStart,
                  DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day + 1,
                  ),
                  TimeOfDay.now()),
              if (dateStart.text.isNotEmpty)
                chooseDate(
                    'Finish at',
                    dateEnd,
                    Utils.dateFormat.parse(dateStart.text),
                    TimeOfDay.fromDateTime(
                        Utils.dateFormat.parse(dateStart.text))),
            ]),
        TextFormField(
          validator: Utils.validateEmpty,
          controller: price,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.phone,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
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
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
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
            items: freeDriverLs.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: !selectedEndDate
                ? null
                : (String newValue) {
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
                  onPressed: () async {
                    // if (_key.currentState.validate() && _image != null)
                    if (_key.currentState.validate()) {
                      if (tripID != null) {
                        saveTrip();
                      } else if (freeDriverLs.indexOf(choosingDriver) == 0) {
                        setState(() {
                          errorMessage = 'Bad choosing Driver';
                          return;
                        });
                      } else
                        saveTrip();
                    }
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
        if (errorMessage.isNotEmpty)
          Text(
            errorMessage,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
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
