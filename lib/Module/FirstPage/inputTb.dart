import 'package:flutter/material.dart';

class borderLessInputTb {

  borderLessInputTb();

  Widget textbox(String label, TextStyle style, bool isPassword, Color lineColor, double weight){
    return Padding(
      padding: EdgeInsets.only(),
      child: TextField(
        style: style,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: label,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: lineColor,
              width: weight,
            ),
          ),
        ),
      ),
    );
  }



}