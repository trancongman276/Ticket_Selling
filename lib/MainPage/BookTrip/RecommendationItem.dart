import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecommendationItem extends StatelessWidget {

  final String origin;
  final String destination;
  final String price;
  final String date;
  final Color color;

  const RecommendationItem({Key key, this.origin, this.destination, this.price, this.color, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print ("Hello World");
      },
      child: Container(
        height: 250,
        width: 190,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration (
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(14))
        ),
        child: Column (
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _icon(color),
            SizedBox(height: 10),
            Text (date, style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),),
            SizedBox(height: 10),
            _place(origin, destination),
            SizedBox (height: 10),
            Row(
              children: [
                Icon (Icons.attach_money, size: 25,color: Colors.black,),
                Text (price + " VND ", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),),
              ],
            )
          ],
        ),
      ),
    );
  }
}
Widget _place(String origin, String destination) {

    return Container (
      padding: EdgeInsets.only(left: 15),
      child: Column (
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text (
            origin,
            style: TextStyle (
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox (width: 10),
          Icon (
            Icons.arrow_downward, size: 32, color: Colors.white,
          ),
          SizedBox(width: 10),
          Text (
            destination,
            style: TextStyle (
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
}

Widget _icon(Color color) {

  return Container (
    height: 40,
    width: 40,
    decoration: BoxDecoration (
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(10))
    ),
    child: Icon (
      Icons.directions_car,
      color: color,
      size: 32,
    ),
  );
}
