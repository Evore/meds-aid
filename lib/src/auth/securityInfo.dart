import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'accountInfo.dart';

class SecurityInfo extends StatefulWidget {
  final fname, lname, sex, date;

  const SecurityInfo(this.fname, this.lname, this.sex, this.date);
  @override
  _SecurityInfoState createState() => _SecurityInfoState(this.fname, this.lname, this.sex, this.date);
}

class _SecurityInfoState extends State<SecurityInfo> {
  String securityQuestion;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController answer = TextEditingController();
  final TextEditingController idnumber = TextEditingController();
  String idType;

  final fname, lname, sex, date;

  _SecurityInfoState(this.fname, this.lname, this.sex, this.date);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(fit: StackFit.expand, children: <Widget>[
      Image(
        image: AssetImage('images/Welcome.png'),
        fit: BoxFit.cover,
      ),
      ListView(children: <Widget>[
//            new Padding(padding: EdgeInsets.only(top: 60.0)),
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
                                'Security Info',
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
                      height: 40,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: Padding(
                        padding:  EdgeInsets.only(left: 15.0),
                        child: DropdownButtonFormField<String>(
                          value: securityQuestion,
                          hint: Text('Security Question'),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.solidQuestionCircle,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              securityQuestion = newValue;
                            });
                          },
                          items: <String>['Male', 'Female']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
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
                          controller: answer,
                          onSaved: (input) => this.answer,
                          decoration: InputDecoration(
                              hintText: 'Security Answer',
                              icon: Icon(
                                FontAwesomeIcons.checkSquare,
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
                        child: DropdownButtonFormField<String>(
                          value: idType,
                          hint: Text('National ID'),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Icon(
                                  FontAwesomeIcons.idCard,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              )),
                          onChanged: (String newValue) {
                            setState(() {
                              idType = newValue;
                            });
                          },
                          items: <String>['Male', 'Female']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
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
                          controller: idnumber,
                          onSaved: (option) => this.idnumber,
                          decoration: InputDecoration(
                            hintText: 'ID Number',
                            icon: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Icon(
                                FontAwesomeIcons.idCard,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.number,
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
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AccountInfo(this.fname, this.lname, this.sex, this.date, this.securityQuestion, this.answer, this.idType, this.idnumber)));
                        },
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
