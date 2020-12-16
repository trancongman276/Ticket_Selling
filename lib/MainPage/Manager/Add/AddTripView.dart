import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:CoachTicketSelling/classes/Implement/DriverImpl.dart';
import 'package:CoachTicketSelling/classes/Implement/TripImpl.dart';
import 'package:CoachTicketSelling/classes/actor/Driver.dart';
import 'package:CoachTicketSelling/classes/actor/Trip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

      price.text = trip.price.toString();
      seat.text = trip.totalSeat.toString();
      detail.text = trip.detail;

      dateStart.text = Utils.dateFormat.format(trip.time['Start Time']);
      dateEnd.text = Utils.dateFormat.format(trip.time['Finish Time']);

      choosingStartDate = trip.time['Start Time'];
      choosingFinishDate = trip.time['Finish Time'];

      choosingDriver = driverImpl.driverList[trip.driver.id]?.name ?? 'Driver';
      freeDriverLs = [choosingDriver];

      choosingFromPlace = trip.source;
      choosingFinishPlace = trip.destination;

      fromPlaceLs = [choosingFromPlace];
      finishPlaceLs = [choosingFinishPlace];
      route = {choosingFromPlace: finishPlaceLs};

      // route = tripImplement.company.route;
      // fromPlaceLs = route.keys.toList();
      // choosingFromPlace = fromPlaceLs[0];
    } else {
      route = tripImplement.company.route;
      fromPlaceLs = route.keys.toList();
      choosingFromPlace = fromPlaceLs[0];
      finishPlaceLs = route[choosingFromPlace];
      choosingFinishPlace = finishPlaceLs[0];
      choosingStartDate = choosingFinishDate = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
    }
  }

  Future<List<String>> getDriverLs(String start, String end) async {
    List<String> _freeDriverLs = ['Driver'];
    choosingDriver = 'Driver';
    await driverImpl.getFreeDriver(start, end).then((value) {
      driverLs = value;
      _freeDriverLs.addAll(List.generate(driverLs.length, (index) {
        Driver driver = driverLs[index];
        return '(${DateTime.now().year - driver.doB.year}) ' + driver.name;
      }));
    });

    return Future.value(_freeDriverLs);
  }

  GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController price = TextEditingController();
  final TextEditingController seat = TextEditingController();
  final TextEditingController detail = TextEditingController();
  final TextEditingController dateStart = TextEditingController();
  final TextEditingController dateEnd = TextEditingController();
  String errorMessage = '';

  String choosingDriver = 'Driver';
  List<Driver> driverLs;
  List<String> freeDriverLs = ['Driver'];

  String choosingFromPlace = '';
  List<String> fromPlaceLs = [];

  String choosingFinishPlace = '';
  List<String> finishPlaceLs = [];

  DateTime choosingStartDate;
  DateTime choosingFinishDate;

  Map<String, List<String>> route;

  ThemeData themeData = ThemeData(primarySwatch: Colors.green);

  Future<DateTime> dateTimePicker(
      DateTime initDate, DateTime firstDate, TimeOfDay initTime) async {
    DateTime date;
    TimeOfDay time;
    try {
      await showRoundedDatePicker(
        context: context,
        theme: themeData,
        initialDate: initDate,
        firstDate: firstDate,
      ).then((pickedDate) async {
        if (pickedDate != null) {
          date = pickedDate;

          await showRoundedTimePicker(
            context: context,
            initialTime: TimeOfDay(hour: 0, minute: 0),
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
    } catch (e) {
      setState(() {});
    }

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
    Map<String, DateTime> tempMap = {
      'Start Time': Utils.dateFormat.parse(dateStart.text),
      'Finish Time': Utils.dateFormat.parse(dateEnd.text)
    };
    if (tripID != null) {
      tripImplement.update(tripID,
          source: choosingFromPlace,
          destination: choosingFinishPlace,
          price: int.tryParse(price.text),
          totalSeat: int.parse(seat.text),
          detail: detail.text,
          time: tempMap);
      Navigator.pop(context);
    } else {
      tripImplement.add(
        choosingFromPlace,
        choosingFinishPlace,
        int.parse(price.text),
        int.parse(seat.text),
        driverLs[freeDriverLs.indexOf(choosingDriver) - 1],
        detail.text,
        tempMap,
      );
      _key.currentState.reset();
      choosingFromPlace = fromPlaceLs[0];
      finishPlaceLs = route[choosingFromPlace];
      choosingFinishPlace = finishPlaceLs[0];
      dateStart.text = '';
      dateEnd.text = '';
      price.text = '';
      seat.text = '';
      choosingDriver = 'Driver';
      detail.text = '';
      setState(() {});
    }
  }

  bool checkSave() {
    if (_key.currentState.validate()) {
      if (choosingDriver == 'Driver') {
        setState(() {
          errorMessage = 'Bad choosing Driver';
        });
        return false;
      } else if ((choosingFromPlace.isEmpty) | (choosingFinishPlace.isEmpty)) {
        setState(() {
          errorMessage = 'Bad choosing Source and Destination';
        });
        return false;
      } else if ((Utils.dateFormat
              .parse(dateStart.text)
              .isAfter(Utils.dateFormat.parse(dateEnd.text))) |
          (dateStart.text == dateEnd.text)) {
        setState(() {
          errorMessage = 'Bad choosing Time';
        });
        return false;
      } else
        saveTrip();
      return true;
    }
    return false;
  }

  Widget placeChoosingDropBox(
      List<String> dropDownLs, String value, bool isFrom) {
    return Container(
      child: DropdownButton<String>(
        underline: Container(
          height: 1,
          color: Colors.grey,
        ),
        value: value,
        items: dropDownLs.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: !isFrom
            ? (choosingFromPlace == 'From'
                ? null
                : (String newValue) {
                    setState(() {
                      choosingFinishPlace = newValue;
                    });
                  })
            : (String newValue) {
                setState(() {
                  choosingFromPlace = newValue;
                  finishPlaceLs = route[choosingFromPlace];
                  choosingFinishPlace = finishPlaceLs[0];
                });
              },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget chooseDate(
        String label,
        TextEditingController controller,
        DateTime startDate,
        DateTime firstDate,
        TimeOfDay startTime,
        bool isFrom) {
      return Container(
        child: Row(
          children: [
            Container(
              width: 125,
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
                enabled: false,
              ),
            ),
            IconButton(
              onPressed: () async {
                await dateTimePicker(startDate, firstDate, startTime)
                    .then((datetime) async {
                  if (datetime != null) {
                    controller.text = Utils.dateFormat.format(datetime);
                    if (isFrom)
                      choosingStartDate = datetime;
                    else
                      choosingFinishDate = datetime;
                    if (dateEnd.text.isNotEmpty) {
                      await getDriverLs(dateStart.text, dateEnd.text)
                          .then((value) {
                        setState(() {
                          freeDriverLs = value;
                        });
                      });
                    }
                    setState(() {});
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            placeChoosingDropBox(fromPlaceLs, choosingFromPlace, true),
            Icon(Icons.arrow_forward_rounded),
            placeChoosingDropBox(finishPlaceLs, choosingFinishPlace, false),
          ],
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              chooseDate(
                  'Start at',
                  dateStart,
                  choosingStartDate,
                  DateTime.now(),
                  TimeOfDay.fromDateTime(choosingStartDate),
                  true),
              if (dateStart.text.isNotEmpty)
                chooseDate(
                    'Finish at',
                    dateEnd,
                    choosingFinishDate,
                    choosingStartDate,
                    TimeOfDay.fromDateTime(choosingFinishDate),
                    false),
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
        Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(bottom: 30.0, top: 10.0),
              child: DropdownButton<String>(
                underline: Container(
                  height: 1,
                  color: Colors.grey,
                ),
                value: choosingDriver,
                items:
                    freeDriverLs.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Container(
                      width: 150.0,
                      child: Text(
                        value,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String newValue) {
                  setState(() {
                    choosingDriver = newValue;
                  });
                },
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (freeDriverLs.length == 1) {
                  await getDriverLs(dateStart.text, dateEnd.text).then((value) {
                    setState(() {
                      choosingDriver = 'Driver';
                      freeDriverLs = value;
                    });
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
                child: FaIcon(
                  FontAwesomeIcons.redo,
                  color: Utils.primaryColor,
                  size: 20.0,
                ),
              ),
            ),
          ],
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
                    checkSave();
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
