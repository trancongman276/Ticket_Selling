import 'dart:io';

import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:CoachTicketSelling/classes/actor/AppUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:image_picker/image_picker.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypepasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String dropDownValue = 'Male';
  DateTime date;
  bool isSuccess = true;
  String ex;

  File _imageFile;
  String imageUrl;
  Color borderColor = Colors.grey;
  final picker = ImagePicker();

  Future _getImg() async {
    imageUrl = null;
    final image = await picker.getImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  @override
  void initState() {
    _dateController.text = "yyyy-mm-dd";
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _retypepasswordController.dispose();
    _nameController.dispose();
    _dateController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _background = Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: Utils.registerBackground,
        fit: BoxFit.fill,
      )),
    );

    Widget avatar = Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
            shape: BoxShape.circle, border: Border.all(color: borderColor)),
        child: CircleAvatar(
          foregroundColor: borderColor,
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: _getImg,
            child: _imageFile == null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Icon(Icons.add))
                : ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Image.file(
                      _imageFile,
                      height: 200,
                      width: 200,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
          ),
        ),
      ),
    );

    Widget _email = TextFormField(
      textInputAction: TextInputAction.next,
      controller: _emailController,
      validator: Utils.validateEmail,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(color: Utils.primaryColor),
        hintText: 'Ex: abc@abc.com',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Utils.primaryColor,
            width: 1.5,
          ),
        ),
      ),
    );

    Widget _password(String hint) {
      return TextFormField(
        textInputAction: TextInputAction.next,
        controller:
            hint[0] == 'P' ? _passwordController : _retypepasswordController,
        obscureText: true,
        validator: hint[0] == 'P'
            ? Utils.validatePassword
            : (value) =>
                Utils.validateRetypePassword(value, _passwordController.text),
        decoration: InputDecoration(
          labelText: hint[0] == 'P' ? 'Password' : 'Retype password',
          labelStyle: TextStyle(color: Utils.primaryColor),
          hintText: hint,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Utils.primaryColor,
              width: 1.5,
            ),
          ),
        ),
      );
    }

    Widget _name = TextFormField(
      textInputAction: TextInputAction.next,
      controller: _nameController,
      validator: Utils.validateEmpty,
      decoration: InputDecoration(
        labelText: 'Name',
        labelStyle: TextStyle(color: Utils.primaryColor),
        hintText: 'Ex: Nguyen Van A',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Utils.primaryColor,
            width: 1.5,
          ),
        ),
      ),
    );

    Widget _phone = TextFormField(
      textInputAction: TextInputAction.done,
      controller: _phoneController,
      keyboardType: TextInputType.number,
      validator: (value) => Utils.validateNumber(value, 9, 12),
      decoration: InputDecoration(
        labelText: 'Phone',
        labelStyle: TextStyle(color: Utils.primaryColor),
        hintText: 'Ex: 0123*******',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Utils.primaryColor,
            width: 1.5,
          ),
        ),
      ),
    );

    Widget _doB = Row(
      children: <Widget>[
        Container(
          width: 100,
          child: TextFormField(
            validator: Utils.validateEmpty,
            decoration: InputDecoration(
              labelText: 'Date Of Birth',
              labelStyle: TextStyle(color: Utils.primaryColor),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Utils.primaryColor,
                  width: 1.5,
                ),
              ),
            ),
            controller: _dateController,
            readOnly: true,
          ),
        ),
        IconButton(
          onPressed: () async {
            date = await showRoundedDatePicker(
                context: context,
                firstDate: DateTime(DateTime.now().year - 100),
                borderRadius: 16,
                theme: ThemeData(primarySwatch: Colors.green));
            date != null
                ? _dateController.text = date.toString().substring(0, 10)
                // ignore: unnecessary_statements
                : Null;
          },
          icon: Icon(Icons.calendar_today),
          color: Utils.primaryColor.withBlue(10),
        ),
      ],
    );

    Widget _gender() {
      return DropdownButton<String>(
        underline: Container(
          height: 1,
          color: Colors.grey,
        ),
        value: dropDownValue,
        items: <String>['Male', 'Female', 'Other']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String newValue) {
          setState(() {
            dropDownValue = newValue;
          });
        },
      );
    }

    void register() async {
      try {
        final UserCredential user = await Utils.firebaseAuth
            .createUserWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim());

        user.user.updateProfile(displayName: _nameController.text);
        user.user.reload();
        AppUser appUser = AppUser.instance;
        appUser.update(
          id: user.user.uid,
          email: _emailController.text.trim(),
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          gender: dropDownValue,
          doB: date,
          image: _imageFile,
        );
        Navigator.pop(context);
        //TODO: Verification
        // await user.user.sendEmailVerification();
      } catch (e) {
        setState(() {
          if (e.code == 'email-already-in-use') {
            ex = e.message;
            isSuccess = false;
          }
        });
      }
    }

    Widget _body = Container(
      padding: EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ], color: Colors.white, borderRadius: BorderRadius.circular(30.0)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    'Register Account',
                    style: TextStyle(fontSize: 20),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                avatar,
                _email,
                _password('Password (More than 6 characters)'),
                _password('Retype password'),
                _name,
                _phone,
                _doB,
                Container(
                  alignment: Alignment.centerLeft,
                  child: _gender(),
                ),
                RaisedButton(
                    onPressed: () {
                      if (_key.currentState.validate()) register();
                    },
                    color: Utils.primaryColor,
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(color: Colors.white),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
                Container(
                  child: Text(
                    isSuccess ? '' : ex,
                    style: TextStyle(color: Colors.red),
                  ),
                )
              ],
            ),
          )),
    );

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Form(
        key: _key,
        child: Stack(
          children: <Widget>[_background, _body],
        ),
      ),
    );
  }
}
