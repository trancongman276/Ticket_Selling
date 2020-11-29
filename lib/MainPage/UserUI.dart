import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserUI extends StatefulWidget {
  @override
  _UserUIState createState() => _UserUIState();
}

List<String> _origin = <String>['Ho Chi Minh','Khanh Hoa','Ha Noi','Hue','Binh Duong','Da Nang'];
String _oriValue;

List<String> _destination = <String> ['Ho Chi Minh','Khanh Hoa','Ha Noi','Hue','Binh Duong','Da Nang'];
String _desValue;

class _UserUIState extends State<UserUI> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8F5E9),
      body: SingleChildScrollView (
        child: SafeArea (
          child: Container (
            margin: EdgeInsets.all(20),
            child: Column (
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                 alignment: AlignmentDirectional.center,
                 padding: EdgeInsets.symmetric(horizontal: 20),
                 width: double.infinity,
                 height: 170,
                 decoration: BoxDecoration (
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                  ),
                 child: Row (
                   mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _iconDestination(),
                    Container (
                      child: Column (
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: <Widget>[
                          Padding (
                           padding: EdgeInsets.fromLTRB(30, 10, 0, 0),
                           child: Text (
                              "Origin",
                              style: TextStyle (
                              color: Colors.grey,
                              fontSize: 16
                             ),
                            ),
                          ),
                          Padding (
                           padding: EdgeInsets.fromLTRB(30, 0, 0, 10),
                           child: Container(
                             width: 250,
                             //color: Colors.blue,
                             child: DropdownButton (
                                      hint: Text ("Select Origin"),
                                      dropdownColor: Colors.green[200],
                                      isExpanded: true,
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 30,
                                      style: TextStyle (fontSize: 16, color: Colors.black),
                                      value: _oriValue,
                                      onChanged: (value) {
                                        setState(() {
                                          _oriValue = value;
                                        });
                                      },
                                      items: _origin.map((value) {
                                        return DropdownMenuItem (
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                             ),
                           ),
                          ),
                         Padding (
                           padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                           child: Text(
                             "Destination",
                             style: TextStyle (
                               color: Colors.grey,
                               fontSize: 16
                             ),
                           ),
                         ),
                         Padding (
                           padding: EdgeInsets.fromLTRB(30, 0, 0, 10),
                           child: Container (
                             width: 250,
                             child: DropdownButton (
                               hint: Text ("Select Destination"),
                               dropdownColor: Colors.green[200],
                               isExpanded: true,
                               icon: Icon(Icons.arrow_drop_down),
                               iconSize: 30,
                               style: TextStyle(fontSize: 16, color: Colors.black),
                               value: _desValue,
                               onChanged: (value) {
                                 setState(() {
                                   _desValue = value;
                                 });
                             },
                               items: _destination.map((value) {
                                 return DropdownMenuItem (
                                   value: value,
                                   child: Text(value),
                                 );
                               }).toList(),
                             ),
                           ),
                         )
                        ],
                      ),
                    )
                  ],
                 )
                ),
                //Todo next
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _iconDestination () {
  return Container (
    child: Column (
      children: <Widget>[
        Icon (Icons.directions_car,
          color: Colors.green,
          size: 30,),

        Icon (Icons.fiber_manual_record,
          color: Colors.green,
          size: 12,),

        Icon (Icons.fiber_manual_record,
          color: Colors.green,
          size: 12,),

        Icon (Icons.fiber_manual_record,
          color: Colors.green,
          size: 12,),

        Icon (Icons.fiber_manual_record,
          color: Colors.green,
          size: 12,),

        Icon (Icons.fiber_manual_record,
          color: Colors.green,
          size: 12,),

        Icon (Icons.fiber_manual_record,
          color: Color(0xFFFf89380),
          size: 12,),

        Icon (Icons.fiber_manual_record,
          color: Color(0xFFFf89380),
          size: 12,),

        Icon (Icons.fiber_manual_record,
          color: Color(0xFFFf89380),
          size: 12,),

        Icon (Icons.location_on,
          color: Color(0xFFFf89380),
          size: 30,)
      ],
    ),
  );
}

