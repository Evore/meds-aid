import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:meds_aid/src/ui/homepage.dart';
import 'package:meds_aid/src/ui/widgets/dialogs.dart';
import 'package:meds_aid/src/utils/size_config.dart';

import 'signIn.dart';


class PersonalInfo extends StatefulWidget {
  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo>
    with SingleTickerProviderStateMixin {
  bool val = false;

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController fName = TextEditingController();
  final TextEditingController lName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController cPassword = TextEditingController();
  final TextEditingController phone = TextEditingController();
  String dropdownValue;

    TextStyle editTextStyle =
        TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
    TextStyle defaultTextStyle;

  Animation animation, animation1, animation2, animation3, animation4, rotate;
  AnimationController animationController, animationController1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    defaultTextStyle = Theme.of(context).textTheme.body1;
  }

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);
    animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));

    animation1 = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.3, 1.0, curve: Curves.fastOutSlowIn)));

    animation2 = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn)));

    animation3 = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.7, 1.0, curve: Curves.fastOutSlowIn)));

    animation4 = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.9, 1.0, curve: Curves.fastOutSlowIn)));
  }

//  final dateFormat = DateFormat('dd-MM-yyyy');
//  var date;
  var data;

  Future personalInfo(BuildContext context) async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();

      try {
        if (val == true) {
          Dialogs.showLoadingDialog(context, _keyLoader); //invoking login
          final response = await http
              .post('http://medsaid.herokuapp.com/api/users/signup/', body: {
            "first_name": fName.text,
            "last_name": lName.text,
            "email": email.text,
            "password": password.text,
            "confirm_password": cPassword.text,
            "phone_number": phone.text
          });
          Navigator.of(_keyLoader.currentContext, rootNavigator: true)
              .pop(); //close the dialoge

          if (response.statusCode == 201) {
            data = json.decode(response.body);
            print(data);
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) => SignIn()));
          } else {
            data = json.decode(response.body);
            var details = data["detail"];
            print(response.body);
            showDialog(
                context: context,
                barrierDismissible: true,
                child: CupertinoAlertDialog(
                  content: Text(
                    "$details",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ));
          }
        } else {
          return null;
        }
      } catch (e) {
        print(e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var _blank = FocusNode();
    final double width = MediaQuery.of(context).size.width;
    animationController.forward();
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          SizeConfig().init(context);
          return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                // leading: IconButton(
                //     color: Colors.grey[800],
                //     icon: Icon(Icons.keyboard_arrow_left),
                //     onPressed: () {
                //       Navigator.pop(context);
                //     }),
              ),
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(_blank);
                },
                child: Stack(fit: StackFit.expand, children: <Widget>[
                  // TODO Image(
                  //   image: AssetImage('images/Welcome.png'),
                  //   fit: BoxFit.cover,
                  // ),
                  ListView(
                      padding: const EdgeInsets.only(top: 30.0),
                      children: <Widget>[
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 40),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[],
                                    ),
                                  ),
                                  Transform(
                                    transform: Matrix4.translationValues(
                                        animation.value * width, 0.0, 0.0),
                                    child: Text('M',
                                        style: Theme.of(context)
                                            .textTheme
                                            .display4),
                                  ),
                                  Transform(
                                    transform: Matrix4.translationValues(
                                        animation.value * width, -12.0, 0.0),
                                    child: Text('M  e  d  s  A  i  d',
                                        style: defaultTextStyle.copyWith(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  SizedBox(height: 40),
                                  Transform(
                                    transform: Matrix4.translationValues(
                                        animation.value * width, 0.0, 0.0),
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 5),
                                      width: 300,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Profile',
                                          style: defaultTextStyle.copyWith(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w100,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30),
                                  ),
                                  Form(
                                      key: _formKey,
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Transform(
                                              transform:
                                                  Matrix4.translationValues(
                                                      animation1.value *
                                                          width,
                                                      0.0,
                                                      0.0),
                                              child: Container(
                                                width: 300,
                                                child: TextFormField(
                                                  controller: fName,
                                                  validator: (input) => input
                                                          .isEmpty
                                                      ? 'Enter First Name'
                                                      : null,
                                                  decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                              right: 16,
                                                              left: 80),
                                                      hintText:
                                                          'First Name',
                                                      hintStyle:
                                                          editTextStyle,
                                                      prefixIcon: Icon(Icons.person_outline,
                                                          color: Colors
                                                              .grey[700]),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors.grey[
                                                                  600],
                                                              width: 0.0),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  50)),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .lightBlue),
                                                          borderRadius: BorderRadius.circular(50))),
                                                  onSaved: (input) =>
                                                      this.fName,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 25),
                                            Transform(
                                              transform:
                                                  Matrix4.translationValues(
                                                      animation1.value *
                                                          width,
                                                      0.0,
                                                      0.0),
                                              child: Container(
                                                width: 300,
                                                child: TextFormField(
                                                  controller: lName,
                                                  validator: (input) =>
                                                      input.isEmpty
                                                          ? 'Enter Last Name'
                                                          : null,
                                                  decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                              right: 16,
                                                              left: 80),
                                                      hintText: 'Last Name',
                                                      hintStyle:
                                                          editTextStyle,
                                                      prefixIcon: Icon(
                                                          Icons
                                                              .person_outline,
                                                          color: Colors
                                                              .grey[700]),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors.grey[
                                                                  600],
                                                              width: 0.0),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  50)),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(color: Colors.lightBlue),
                                                              borderRadius: BorderRadius.circular(50))),
                                                  onSaved: (input) =>
                                                      this.lName,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 25),
                                            Transform(
                                              transform:
                                                  Matrix4.translationValues(
                                                      animation2.value *
                                                          width,
                                                      0.0,
                                                      0.0),
                                              child: Container(
                                                width: 300,
                                                child: TextFormField(
                                                  controller: email,
                                                  validator: (input) =>
                                                      input.isEmpty
                                                          ? 'Enter email'
                                                          : null,
                                                  decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                              right: 16,
                                                              left: 80),
                                                      hintText:
                                                          'Email Address',
                                                      hintStyle:
                                                          editTextStyle,
                                                      prefixIcon: Icon(Icons.alternate_email,
                                                          color: Colors
                                                              .grey[700]),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors.grey[
                                                                  600],
                                                              width: 0.0),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  50)),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .lightBlue),
                                                          borderRadius: BorderRadius.circular(50))),
                                                  onSaved: (input) =>
                                                      this.email,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 25),
                                            Transform(
                                              transform:
                                                  Matrix4.translationValues(
                                                      animation2.value *
                                                          width,
                                                      0.0,
                                                      0.0),
                                              child: Container(
                                                width: 300,
                                                child: TextFormField(
                                                  controller: phone,
                                                  validator: (input) => input
                                                          .isEmpty
                                                      ? 'Enter phone number'
                                                      : null,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration:
                                                      InputDecoration(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 16,
                                                                  left: 80),
                                                          hintText:
                                                              'Phone Number',
                                                          hintStyle:
                                                              editTextStyle,
                                                          prefixIcon: Icon(
                                                            FontAwesomeIcons
                                                                .idCard,
                                                            color: Colors
                                                                .grey[700],
                                                            size: 20,
                                                          )),
                                                  onSaved: (input) =>
                                                      this.phone,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 55),
                                            Transform(
                                              transform:
                                                  Matrix4.translationValues(
                                                      animation3.value *
                                                          width,
                                                      0.0,
                                                      0.0),
                                              child: Container(
                                                //height: 60,
                                                width: 300,
                                                child: TextFormField(
                                                  obscureText: true,
                                                  controller: password,
                                                  validator: (input) =>
                                                      input.isEmpty
                                                          ? 'Enter password'
                                                          : null,
                                                  decoration:
                                                      InputDecoration(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 16,
                                                                  left: 80),
                                                          hintText:
                                                              'Password',
                                                          hintStyle:
                                                              editTextStyle,
                                                          prefixIcon: Icon(
                                                            Icons.lock,
                                                            color: Colors
                                                                .grey[700],
                                                            size: 20,
                                                          )),
                                                  onSaved: (input) =>
                                                      this.password,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 25),
                                            Transform(
                                              transform:
                                                  Matrix4.translationValues(
                                                      animation3.value *
                                                          width,
                                                      0.0,
                                                      0.0),
                                              child: Container(
                                                width: 300,
                                                child: TextFormField(
                                                  obscureText: true,
                                                  controller: cPassword,
                                                  validator: (input) => input
                                                          .isEmpty
                                                      ? 'Re-enter Password'
                                                      : null,
                                                  decoration:
                                                      InputDecoration(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 16,
                                                                  left: 80),
                                                          hintText:
                                                              'Confirm password',
                                                          hintStyle:
                                                              editTextStyle,
                                                          prefixIcon: Icon(
                                                            Icons.lock,
                                                            color: Colors
                                                                .grey[700],
                                                            size: 20,
                                                          )),
                                                  onSaved: (input) =>
                                                      this.cPassword,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 25),
                                            Transform(
                                              transform:
                                                  Matrix4.translationValues(
                                                      animation4.value *
                                                          width,
                                                      0.0,
                                                      0.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                children: <Widget>[
                                                  Container(
                                                    // color: Colors.grey,
                                                    child: Checkbox(
                                                        materialTapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        value: val,
                                                        onChanged:
                                                            (bool value) {
                                                          setState(() {
                                                            val = value;
                                                          });
                                                        }),
                                                  ),
                                                  Text(
                                                    'I agree to the ',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                        wordSpacing: 3.0),
                                                  ),
                                                  InkWell(
                                                      onTap: () {},
                                                      child: Text(
                                                        "Terms & Conditions",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .blue[900],
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                            decoration:
                                                                TextDecoration
                                                                    .underline),
                                                      )),
                                                  SizedBox(width: 10),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 25),
                                            Transform(
                                              transform:
                                                  Matrix4.translationValues(
                                                      animation4.value *
                                                          width,
                                                      0.0,
                                                      0.0),
                                              child: Container(
                                                height: 50,
                                                width: 300,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.blue,
                                                ),
                                                child: RaisedButton(
                                                  elevation: 5,
                                                  child: Icon(
                                                    Icons.arrow_forward,
                                                    color: Colors.white,
                                                  ),
                                                  textColor: Colors.white,
                                                  color: Colors.blue[800],
                                                  shape: CircleBorder(
                                                    side: BorderSide(
                                                        color: Colors
                                                            .transparent),
                                                  ),
                                                  onPressed: () {
                                                    // personalInfo(context);

                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          fullscreenDialog: true,
                                                            builder:
                                                                (context) =>
                                                                    HomePage()));
                                                  },
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 50)
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ])
                ]),
              ));
        });
  }
}
