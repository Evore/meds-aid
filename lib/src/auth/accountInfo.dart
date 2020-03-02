import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AccountInfo extends StatefulWidget {
  final fname, lname, sex, date, question, answer, idType, idnumber;

  const AccountInfo(this.fname, this.lname, this.sex, this.date, this.question, this.answer, this.idType, this.idnumber);
  @override
  _AccountInfoState createState() => _AccountInfoState(fname, lname, sex, date, question, answer, idType, idnumber);
}

class _AccountInfoState extends State<AccountInfo> {
  final fname, lname, sex, date, question, answer, idType, idnumber;
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  String dropdownValue;

  _AccountInfoState(this.fname, this.lname, this.sex, this.date, this.question, this.answer, this.idType, this.idnumber);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(fit: StackFit.expand, children: <Widget>[
      Image(
        image: AssetImage('images/Welcome.png'),
        fit: BoxFit.cover,
      ),
      ListView(children: <Widget>[
        //new Padding(padding: EdgeInsets.only(top: 60.0)),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 20,
                            width: 150,
                            color: Colors.black,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 25.0),
                              child: Text(
                                'Account Info',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'OpenSans'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'M',
                      style:
                          TextStyle(fontFamily: 'ButterflyKiss', fontSize: 100),
                    ),
                    Text(
                      'M  e  d  s  A  i  d',
                      style: TextStyle(fontSize: 20, fontFamily: 'OpenSans'),
                    ),
                    Padding(padding: const EdgeInsets.only(top: 40)),
                    Text(
                      'SIGN UP',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans-SemiBold'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                    ),
                    Container(
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              hintText: 'E - mail',
                              icon: Icon(
                                FontAwesomeIcons.at,
                                color: Colors.black,
                                size: 20,
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                    ),
                    Container(
                      height: 40,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              hintText: 'Password',
                              icon: Icon(
                                FontAwesomeIcons.lock,
                                color: Colors.black,
                                size: 18,
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                    ),
                    Container(
                      height: 40,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              hintText: 'Confirm Password',
                              icon: Icon(
                                FontAwesomeIcons.lock,
                                color: Colors.black,
                                size: 18,
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                    ),
                    Container(
                      height: 40,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              hintText: 'Phone Number',
                              icon: Icon(
                                FontAwesomeIcons.phone,
                                color: Colors.black,
                                size: 18,
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    Padding(padding: const EdgeInsets.only(top: 30)),
                    Container(
                      height: 40,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50)),
                        color: Colors.blue,
                      ),
                      child: RaisedButton(
                        elevation: 5,
                        child: Text(
                          'Next  >',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        textColor: Colors.white,
                        color: Colors.blue[800],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(50),
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50))),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ])
    ]));
  }
}
