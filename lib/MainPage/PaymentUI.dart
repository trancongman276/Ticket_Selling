import 'dart:io';

import 'package:CoachTicketSelling/Dialog/loading.dart';
import 'package:CoachTicketSelling/Dialog/msg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'UserUI.dart';
import 'credit_card_form.dart';
import 'credit_card_model.dart';
import 'credit_card_widget.dart';

class PaymentUI extends StatefulWidget {
  @override
  _PaymentUIState createState() => _PaymentUIState();
}

class _PaymentUIState extends State<PaymentUI> {

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  int total = 200000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: CreditCardForm(
                  onCreditCardModelChange: onCreditCardModelChange,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 90),
              child: Text(
                "Total cost: $total VND",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Center(
                child: Container(
                  child: FlatButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: () {
                        print("Payment");
                        LoadingDialog.showLoadingDialog(context, 'Loading...');
                      },
                      color: Colors.blue[700],
                      textColor: Colors.white,
                      child: Text(
                        "PAYMENT",
                        style: TextStyle(color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      )
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
