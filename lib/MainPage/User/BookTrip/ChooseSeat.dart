import 'package:CoachTicketSelling/Utils/Route.dart';
import 'package:CoachTicketSelling/classes/Implement/TripImpl.dart';
import 'package:CoachTicketSelling/classes/actor/Trip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:CoachTicketSelling/Utils/GlobalValues.dart';

// ignore: must_be_immutable
class ChooseSeat extends StatefulWidget {
  final Trip currentTrip;

  const ChooseSeat({Key key, this.currentTrip}) : super(key: key);
  @override
  _ChooseSeatState createState() => _ChooseSeatState(currentTrip);
}

class _ChooseSeatState extends State<ChooseSeat> {
  final Trip _currentTrip;

  // String source = 'Ho Chi Minh';
  // String destination = 'Da Nang';
  // String date = '2020 - 03 - 06';
  // bool check = true;
  // List<int> stateSeat = [1, 3, 3];
  // List<int> seatSelected = [];
  // int numSeatSelected = 0;
  // int totalSeat = ;

  _ChooseSeatState(this._currentTrip) {
    source = _currentTrip.source;
    destination = _currentTrip.destination;
    date = '${_currentTrip.time['Start Time'].day}' +
        '/${_currentTrip.time['Start Time'].month}' +
        '/${_currentTrip.time['Start Time'].year}';
    stateSeat = List.generate(_currentTrip.totalSeat, (index) {
      if (_currentTrip.seat.contains(index + 1)) return 1;
      return 3;
    });
    seatSelected = [];
  }
  String source;
  String destination;
  String date;
  bool check;
  List<int> stateSeat;
  List<int> seatSelected;

  showDuplicatedSeatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Your seat is booked"),
          content: Text("Please try again ≧ ﹏ ≦"),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Okay'))
          ],
        );
      },
    );
  }

  showConfirmSeatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Your seat will be dismiss after 10 minutes"),
          content: Text("Please check out before that 🥺"),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);

                  Map<String, dynamic> tempMap = {
                    'Trip': _currentTrip,
                    'Choosing Seat': seatSelected
                  };
                  Navigator.pushNamed(this.context, UserPreviewTicketViewRoute,
                      arguments: tempMap);
                },
                child: Text('Okay'))
          ],
        );
      },
    );
  }

  Future<bool> checkSeatValid() async {
    bool isValid = await TripImplement.instance
        .checkSeatValid(_currentTrip.id, seatSelected);
    if (isValid) {
      await showConfirmSeatDialog(context);
      return Future.value(true);
    } else {
      await showDuplicatedSeatDialog(context);
      setState(() {
        stateSeat = TripImplement.instance.getTrip(_currentTrip.id).seat;
      });
      return Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Utils.primaryColor,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  color: Utils.primaryColor,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            source,
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.arrow_forward,
                            size: 32,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            destination,
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        date,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Positioned(
                    bottom: 0,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          )),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.85,
                      child: Column(
                        //tris that contain free seat
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Choose your seat",
                                style: TextStyle(fontSize: 25),
                              ),
                              Icon(
                                Icons.filter_list,
                                color: Colors.black,
                                size: 25,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Container(
                              height: 440,
                              child: GridView.builder(
                                itemCount: stateSeat.length,
                                scrollDirection: Axis.vertical,
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 100, //100
                                  crossAxisSpacing: 5, //5
                                  mainAxisSpacing: 33, //15
                                ),
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                        child: drawSeat(index),
                                        onTap: () {
                                          setState(() {
                                            if (stateSeat[index] == 3) {
                                              stateSeat[index] = 2;
                                              // numSeatSelected++;
                                              seatSelected.add(index + 1);
                                              // print("Num: $numSeatSelected");
                                              print(seatSelected);
                                            } else if (stateSeat[index] == 2) {
                                              stateSeat[index] = 3;
                                              // numSeatSelected--;
                                              seatSelected.remove(index + 1);
                                              // print("Num: $numSeatSelected");
                                              print(seatSelected);
                                            }
                                          });
                                        }),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: FlatButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0)),
                                onPressed: () async {
                                  print("Choose");

                                  await checkSeatValid().then((isValid) {
                                    if (isValid) {}
                                  });
                                },
                                color: Utils.primaryColor,
                                textColor: Colors.white,
                                child: Text(
                                  "CHOOSE",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                )),
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ));
  }

  Widget drawSeat(int index) {
    int numSeat = index + 1;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              width: 50,
              height: 50,
              child: (() {
                // your code here
                if (stateSeat[index] == 3) {
                  return Image.asset(
                    'assets/images/seat.png',
                    fit: BoxFit.fill,
                  );
                } else if (stateSeat[index] == 1) {
                  return Image.asset(
                    'assets/images/seatSelect.png',
                    fit: BoxFit.fill,
                  );
                } else if (stateSeat[index] == 2) {
                  return Image.asset(
                    'assets/images/seatChoose.png',
                    fit: BoxFit.fill,
                  );
                }
              }())),
          Text(
            "$numSeat",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  bool get wantKeepAlive => true;
}
