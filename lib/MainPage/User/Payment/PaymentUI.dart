import 'package:CoachTicketSelling/MainPage/User/Payment/credit_card_form.dart';
import 'package:CoachTicketSelling/MainPage/User/Payment/credit_card_model.dart';
import 'package:CoachTicketSelling/MainPage/User/Payment/credit_card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentUI extends StatefulWidget {
  final Map<String, dynamic> checkOutDetail;

  const PaymentUI({Key key, this.checkOutDetail}) : super(key: key);
  @override
  _PaymentUIState createState() => _PaymentUIState(checkOutDetail);
}

class _PaymentUIState extends State<PaymentUI> {
  final Map<String, dynamic> checkOutDetail;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  int total;

  _PaymentUIState(this.checkOutDetail) {
    total =
        checkOutDetail['Choosing Seat'].length * checkOutDetail['Trip'].price;
  }

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
                  price: total,
                  checkOutDetail: checkOutDetail,
                ),
              ),
            ),
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
