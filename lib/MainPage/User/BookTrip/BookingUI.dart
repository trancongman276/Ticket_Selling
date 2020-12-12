import 'package:CoachTicketSelling/Utils/Route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'ChooseSeat.dart';

class BookingUI extends StatefulWidget {
  @override
  _BookingUIState createState() => _BookingUIState();
}

class _BookingUIState extends State<BookingUI> {
  String source = 'Ho Chi Minh';
  String destination = 'Da Nang';
  String date = '2020 - 03 - 06';
  String timeStart = "14:00";
  String timeEnd = "20:00";
  String company = "Phuong Trang";
  double rate = 3;
  int result = 15;
  int price = 150000;
  String imageLink =
      'assets/images/logo.png'; //Create class to set link image corresponding to Company logo

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
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          source,
                          style: TextStyle(
                              fontSize: 30,
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
                              fontSize: 30,
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
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.82,
                  child: Column(
                    //tris that contain free seat
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "$result Search Results",
                            style: TextStyle(fontSize: 25),
                          ),
                          Icon(
                            Icons.filter_list,
                            color: Colors.black,
                            size: 25,
                          )
                        ],
                      ),
                      SizedBox(height: 30),
                      Container(
                          height: 470,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: result,
                            itemBuilder: (context, index) {
                              return Column(
                                children: <Widget>[
                                  _bookingItem(
                                      index,
                                      source,
                                      destination,
                                      rate,
                                      timeStart,
                                      timeEnd,
                                      company,
                                      price,
                                      imageLink,
                                      context),
                                  //Create a class that use ID to query this information : db.string(id)
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              );
                            },
                          ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget _bookingItem(
    int index,
    String source,
    String destination,
    double rate,
    String timeStart,
    String timeEnd,
    String company,
    int price,
    String imageLink,
    BuildContext context) {
  return GestureDetector(
    onTap: () {
      print(index);
      Navigator.pushNamed(context, UserChooseTripViewRoute);
    },
    child: Container(
      width: 500,
      height: 200,
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 30,
                width: 30,
                child: Image.asset(
                  imageLink,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                company,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 25,
              ),
              //Icon (FontAwesomeIcons.coins, size: 20,),
              SizedBox(
                width: 5,
              ),
              Text(
                "$price VND",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                source,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Column(
                children: [
                  _iconDestination(),
                ],
              ),
              Text(
                destination,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                timeStart,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Text(
                timeEnd,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          _rating(rate)
        ],
      ),
    ),
  );
}

Widget _iconDestination() {
  return Container(
    child: Row(
      children: <Widget>[
        Icon(
          Icons.directions_car,
          color: Utils.primaryColor,
          size: 20,
        ),
        Icon(
          Icons.fiber_manual_record,
          color: Utils.primaryColor,
          size: 9,
        ),
        Icon(
          Icons.fiber_manual_record,
          color: Utils.primaryColor,
          size: 9,
        ),
        Icon(
          Icons.fiber_manual_record,
          color: Utils.primaryColor,
          size: 9,
        ),
        Icon(
          Icons.fiber_manual_record,
          color: Color(0xFFFf89380),
          size: 9,
        ),
        Icon(
          Icons.fiber_manual_record,
          color: Color(0xFFFf89380),
          size: 9,
        ),
        Icon(
          Icons.fiber_manual_record,
          color: Color(0xFFFf89380),
          size: 9,
        ),
        Icon(
          Icons.location_on,
          color: Color(0xFFFf89380),
          size: 20,
        )
      ],
    ),
  );
}

Widget _rating(double a) {
  return SmoothStarRating(
    isReadOnly: true,
    starCount: 5,
    rating: a,
    spacing: 3,
    size: 30,
    allowHalfRating: false,
    color: Colors.yellow,
    borderColor: Colors.yellow,
  );
}
