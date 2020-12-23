import 'package:CoachTicketSelling/MainPage/User/Dialog/loading.dart';
import 'package:CoachTicketSelling/Utils/Route.dart';
import 'package:CoachTicketSelling/classes/actor/AppUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'localized_text_model.dart';
import '../BookTrip/../Payment/credit_card_model.dart';
import 'flutter_credit_card.dart';

class CreditCardForm extends StatefulWidget {
  const CreditCardForm({
    Key key,
    this.cardNumber,
    this.expiryDate,
    this.cardHolderName,
    this.cvvCode,
    @required this.onCreditCardModelChange,
    this.themeColor,
    this.textColor = Colors.black,
    this.cursorColor,
    this.localizedText = const LocalizedText(),
    this.price,
    this.checkOutDetail,
  })  : assert(localizedText != null),
        super(key: key);

  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final void Function(CreditCardModel) onCreditCardModelChange;
  final Color themeColor;
  final Color textColor;
  final Color cursorColor;
  final LocalizedText localizedText;
  final int price;
  final Map<String, dynamic> checkOutDetail;
  @override
  _CreditCardFormState createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  String cardNumber;
  String expiryDate;
  String cardHolderName;
  String cvvCode;
  bool isCvvFocused = false;
  Color themeColor;
  int price;
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  void Function(CreditCardModel) onCreditCardModelChange;
  CreditCardModel creditCardModel;

  final MaskedTextController _cardNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController _expiryDateController =
      MaskedTextController(mask: '00/00');
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _cvvCodeController =
      MaskedTextController(mask: '0000');

  FocusNode cvvFocusNode = FocusNode();

  void textFieldFocusDidChange() {
    creditCardModel.isCvvFocused = cvvFocusNode.hasFocus;
    onCreditCardModelChange(creditCardModel);
  }

  void createCreditCardModel() {
    cardNumber = widget.cardNumber ?? '';
    expiryDate = widget.expiryDate ?? '';
    cardHolderName = widget.cardHolderName ?? '';
    cvvCode = widget.cvvCode ?? '';
    price = widget.price ?? 0;

    creditCardModel = CreditCardModel(
        cardNumber, expiryDate, cardHolderName, cvvCode, isCvvFocused);
  }

  @override
  void initState() {
    super.initState();

    createCreditCardModel();

    onCreditCardModelChange = widget.onCreditCardModelChange;

    cvvFocusNode.addListener(textFieldFocusDidChange);

    _cardNumberController.addListener(() {
      setState(() {
        cardNumber = _cardNumberController.text;
        creditCardModel.cardNumber = cardNumber;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _expiryDateController.addListener(() {
      setState(() {
        expiryDate = _expiryDateController.text;
        creditCardModel.expiryDate = expiryDate;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cardHolderNameController.addListener(() {
      setState(() {
        cardHolderName = _cardHolderNameController.text;
        creditCardModel.cardHolderName = cardHolderName;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cvvCodeController.addListener(() {
      setState(() {
        cvvCode = _cvvCodeController.text;
        creditCardModel.cvvCode = cvvCode;
        onCreditCardModelChange(creditCardModel);
      });
    });
  }

  @override
  void didChangeDependencies() {
    themeColor = widget.themeColor ?? Theme.of(context).primaryColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: themeColor.withOpacity(0.8),
        primaryColorDark: themeColor,
      ),
      child: Form(
        key: _key,
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
              child: TextFormField(
                controller: _cardNumberController,
                cursorColor: widget.cursorColor ?? themeColor,
                validator: (value) => value.isEmpty
                    ? 'Fill me up please ＞︿＜'
                    : value.length < 12
                        ? 'Wrong Format Card Number (ノへ￣、)'
                        : null,
                style: TextStyle(
                  color: widget.textColor,
                ),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: widget.localizedText.cardNumberLabel,
                  hintText: widget.localizedText.cardNumberHint,
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
              child: TextFormField(
                controller: _expiryDateController,
                cursorColor: widget.cursorColor ?? themeColor,
                validator: (value) {
                  if (value.isNotEmpty) {
                    List<String> mmyy = value.split('/');
                    if ((int.parse(mmyy[0]) > 12) | (int.parse(mmyy[0]) == 0))
                      return 'Wrong Format Month (01 -> 12) (っ °Д °;)っ';

                    String curYear =
                        DateTime.now().year.toString().substring(2);
                    String curMonth = DateTime.now().month.toString();
                    if (int.parse(mmyy[1]) < int.parse(curYear)) {
                      return 'Out Of Date card!!!';
                    } else if (((int.parse(mmyy[0])) < (int.parse(curMonth))) &
                        (int.parse(mmyy[1]) == int.parse(curYear))) {
                      return 'Out Of Date card!!!';
                    }
                    return null;
                  }
                  return 'Fill me up please ＞︿＜';
                },
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    List<String> mmyy = value.split('/');
                    if ((value[0] != '0') & (value[0] != '1')) {
                      _expiryDateController.text =
                          '0' + value[0] + (mmyy.length == 2 ? mmyy[1] : '');
                    } else if ((value[0] == '1') & (value.length > 1)) {
                      if ((mmyy[0][1] != '0') &
                          (mmyy[0][1] != '1') &
                          (mmyy[0][1] != '2')) {
                        _expiryDateController.text =
                            value[0] + '2' + (mmyy.length == 2 ? mmyy[1] : '');
                      }
                    }
                    return null;
                  }
                },
                style: TextStyle(
                  color: widget.textColor,
                ),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: widget.localizedText.expiryDateLabel,
                  hintText: widget.localizedText.expiryDateHint,
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
              child: TextFormField(
                focusNode: cvvFocusNode,
                controller: _cvvCodeController,
                validator: (value) {
                  if (value.isNotEmpty) {
                    if ((value.length != 3) & (value.length != 4))
                      return 'Invalid CVV (っ °Д °;)っ';
                    return null;
                  }
                  return 'Fill me up please ＞︿＜';
                },
                cursorColor: widget.cursorColor ?? themeColor,
                style: TextStyle(
                  color: widget.textColor,
                ),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: widget.localizedText.cvvLabel,
                  hintText: widget.localizedText.cvvHint,
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onChanged: (String text) {
                  setState(() {
                    cvvCode = text;
                  });
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
              child: TextFormField(
                controller: _cardHolderNameController,
                cursorColor: widget.cursorColor ?? themeColor,
                validator: (value) =>
                    value.isEmpty ? 'Fill me up please ＞︿＜' : null,
                style: TextStyle(
                  color: widget.textColor,
                ),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: widget.localizedText.cardHolderLabel,
                  hintText: widget.localizedText.cardHolderHint,
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Text(
                "Total cost: $price VND",
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
                        if (_key.currentState.validate()) {
                          AppUser.instance
                              .doPayment(
                            trip: widget.checkOutDetail['Trip'],
                            seatLs: widget.checkOutDetail['Choosing Seat'],
                          )
                              .then((value) {
                            LoadingDialog.showLoadingDialog(
                                context, 'Loading...');
                          });
                        }
                      },
                      color: Color(0xff1b447b),
                      textColor: Colors.white,
                      child: Text(
                        "PAYMENT",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
