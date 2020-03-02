import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:meds_aid/src/ui/widgets/dialogs.dart';
import 'package:meds_aid/src/utils/size_config.dart';
import 'signIn.dart';

final String baseUrl = 'http://medsaid.herokuapp.com/api/';

class ConfirmEmail extends StatefulWidget {
  @override
  _ConfirmEmailState createState() => _ConfirmEmailState();
}

class _ConfirmEmailState extends State<ConfirmEmail> with SingleTickerProviderStateMixin {

  Animation animation, animation1, animation2, animation3, animation4, rotate;
  AnimationController animationController, animationController1;

  @override
  void initState() {
    super.initState();
//    animationController1 = AnimationController(duration: Duration(milliseconds: 500), vsync: this,
//    upperBound: pi* 2);
    // RotationTransition(turns: null)
    // rotate =
    animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
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
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  final TextEditingController _email = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  var data, newData;

  Future confirmEmail(BuildContext context) async{
    final formState = _formkey.currentState;
    if(formState.validate()){
      Dialogs.showLoadingDialog(context, _keyLoader);//invoking login
      final response = await http.post("${baseUrl}users/confirm/email/", body: {
        'email': _email.text
      });
      print(response.body);
      if(response.statusCode == 200){
        data = json.decode(response.body);
        newData = data["results"];
        print(newData);
        Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop(); //close the dialoge
         Navigator.push(context, MaterialPageRoute(builder: (context) => AnswersPage(newData)));
      }else {
        Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();//close the dialoge
        data = json.decode(response.body);
        var details =data["detail"];
        print(response.body);
        showDialog(context: context,
            barrierDismissible: true,
            child: CupertinoAlertDialog(
              content: Text(
                "$details",
                style: TextStyle(fontSize: 16.0),
              ),
            ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var _blank = FocusNode();
    final double width = MediaQuery
    .of(context)
    .size.width;
    animationController.forward();
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context , Widget child){
          SizeConfig().init(context);
          return Scaffold(
            appBar: PreferredSize(
                child: AppBar(
                  backgroundColor: Colors.white,

                  iconTheme: IconThemeData(
                    color: Colors.black,
                  ),

                ), preferredSize: Size.fromHeight(40)),
            body: GestureDetector(
              onTap: (){
                FocusScope.of(context).requestFocus(_blank);
              },
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image(image: AssetImage('images/Welcome.png'),fit: BoxFit.cover,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: ListView(
                            children: <Widget>[
                              Container(
                                height: SizeConfig.safeBlockVertical * 96,
                                width: SizeConfig.screenWidth,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Transform(
                                      transform: Matrix4.translationValues(animation.value*width, 0.0, 0.0),
                                      child: Text('M',style: TextStyle(
                                          fontFamily: 'ButterflyKiss',
                                          fontSize: 150
                                      ),),
                                    ),
                                    Transform(
                                      transform: Matrix4.translationValues(animation.value*width, 0.0, 0.0),
                                      child: Text(
                                        'M  e  d  s  A  i  d',
                                        style: TextStyle(fontSize: 20, fontFamily: 'OpenSans'),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top:50.0),
                                      child: Transform(
                                        transform: Matrix4.translationValues(animation1.value*width, 0.0, 0.0),
                                        child: Text("Confirm your email", style: TextStyle(
                                            fontFamily: 'OpenSans',
                                            color: Colors.black87, fontSize: 35),
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(top:50.0),
                                      child: Form(
                                        key: _formkey,
                                        child: Column(
                                          children: <Widget>[
                                            Transform(
                                              transform: Matrix4.translationValues(animation2.value*width, 0.0, 0.0),
                                              child: Container(
                                                width: 300,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.black),
                                                    borderRadius: BorderRadius.circular(50)
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left:10.0),
                                                  child: TextFormField(
                                                    onSaved: (input) => this._email,
                                                    controller: _email,
                                                    style: TextStyle(fontSize: 20),
                                                    decoration: InputDecoration(hintText: "Email",
                                                        hintStyle: TextStyle(
                                                            fontFamily: 'ReemKufi'
                                                        ),
                                                        icon: Icon(Icons.email, size: 20,), border: InputBorder.none),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top:45.0),
                                              child: Transform(
                                                transform: Matrix4.translationValues(animation3.value*width, 0.0, 0.0),
                                                child: Container(
                                                    width: 300,
                                                    height: 50,
//                                    decoration: BoxDecoration(
//                                        color: Colors.blue,
//                                        border: Border.all(color: Colors.blue),
//                                        borderRadius: BorderRadius.only(
//                                            topRight: Radius.circular(30),
//                                            bottomLeft: Radius.circular(30),
//
//                                        )
//                                    ),
                                                    child: RaisedButton(
                                                        color: Colors.blue,
                                                        textColor: Colors.black,
                                                        shape: CircleBorder(
                                                            side: BorderSide(
                                                                color: Colors.blue
                                                            )
                                                        ),
//                                      RoundedRectangleBorder(
//                                          borderRadius: BorderRadius.only(
//                                              topRight: Radius.circular(30),
//                                              bottomLeft: Radius.circular(30),
//                                              topLeft: Radius.circular(30),
//                                          )
//                                      ),
                                                        onPressed: (){
                                                          confirmEmail(context);
                                                        },
                                                        elevation: 5,
                                                        child:Icon(FontAwesomeIcons.arrowRight,
                                                        color: Colors.white,)
                                                    )
                                                ),
                                              ),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(top:40.0),
                                                child: GestureDetector(
                                                  child: Transform(
                                                      transform: Matrix4.translationValues(animation4.value*width, 0.0, 0.0),
                                                      child: Text("Go back to login", style: TextStyle(fontSize: 20),)), onTap: (){
                                                  Navigator.of(context).pop();
                                                },)
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
//                    Align(alignment: Alignment.topCenter, child: Padding(
//                      padding: const EdgeInsets.fromLTRB(85.0, 40, 70, 20),
//                      child: Image(image: AssetImage("assets/meds.PNG"), width: 250, height: 250,),
//                    )
//                    ),

                    ],
                  ),
                ],
              ),
            ),
          );
        });

  }
}


class AnswersPage extends StatefulWidget {
  final userData;
  @override

 AnswersPage(this.userData);
  _AnswersPageState createState() => _AnswersPageState(this.userData);
}

class _AnswersPageState extends State<AnswersPage> with SingleTickerProviderStateMixin {

  Animation animation, animation1, animation2, animation3, animation4, rotate;
  AnimationController animationController, animationController1;

  @override
  void initState() {
    super.initState();
//    animationController1 = AnimationController(duration: Duration(milliseconds: 500), vsync: this,
//    upperBound: pi* 2);
    // RotationTransition(turns: null)
    // rotate =
    animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
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

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  final TextEditingController _answer = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final userData;

  var data;
  var newData;

  _AnswersPageState(this.userData);

  Future confirmAnswer(BuildContext context) async{
    final formState = _formkey.currentState;
    if(formState.validate()){
      Dialogs.showLoadingDialog(context, _keyLoader);//invoking login
      final response = await http.post("${baseUrl}users/confirm/answer/", body: {
        'answer': _answer.text, 'user_id': this.userData["user_id"].toString()
      });
      print(response.body);
      if(response.statusCode == 200){
        data = json.decode(response.body);
        newData = data["results"];
        print(newData);
        Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();//close the dialoge
        Navigator.of(context).pop();
         Navigator.push(context, MaterialPageRoute(builder: (context) => SetPassword(newData)));
      }else{
        {
          Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();//close the dialoge
          data = json.decode(response.body);
          var details =data["detail"];
          print(response.body);
          showDialog(context: context,
              barrierDismissible: true,
              child: CupertinoAlertDialog(
                content: Text(
                  "$details",
                  style: TextStyle(fontSize: 16.0),
                ),
              ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var _blank = FocusNode();
    final double width = MediaQuery
    .of(context)
    .size.width;
    animationController.forward();
    return AnimatedBuilder(animation: animationController,
        builder: (BuildContext context, Widget child){
      SizeConfig().init(context);
      return Scaffold(
        appBar: PreferredSize(
            child: AppBar(
              backgroundColor: Colors.white,

              iconTheme: IconThemeData(
                color: Colors.black,
              ),

            ), preferredSize: Size.fromHeight(40)),
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(_blank);
          },
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image(image: AssetImage('images/Welcome.png'),fit: BoxFit.cover,),
              Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: ListView(
                          children: <Widget>[
                            Container(
                              height: SizeConfig.screenHeight,
                              width: SizeConfig.screenWidth,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Transform(
                                    transform: Matrix4.translationValues(animation.value*width, 0.0, 0.0),
                                    child: Text('M',style: TextStyle(
                                        fontFamily: 'ButterflyKiss',
                                        fontSize: 150
                                    ),),
                                  ),
                                  Transform(
                                    transform: Matrix4.translationValues(animation.value*width, 0.0, 0.0),
                                    child: Text(
                                      'M  e  d  s  A  i  d',
                                      style: TextStyle(fontSize: 20, fontFamily: 'OpenSans'),
                                    ),
                                  ),
                                  Padding(padding: const EdgeInsets.only(top: 20)),

//                    Align(alignment: Alignment.topCenter, child: Padding(
//                      padding: const EdgeInsets.fromLTRB(85.0, 40, 70, 20),
//                      child: Image(image: AssetImage("assets/meds.PNG"), width: 250, height: 250,),
//                    )
//                    ),
                                  Padding(
                                    padding: const EdgeInsets.only(left:10.0),
                                    child: Transform(
                                      transform: Matrix4.translationValues(animation.value*width, 0.0, 0.0),
                                      child: Text("Hi ${this.userData["first_name"]}, your email ${this.userData["email"]} checks out!",
                                        style: TextStyle(color: Colors.black87, fontSize: 23, fontFamily:'OpenSans'),),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top:15.0, left: 10),
                                    child: Transform(
                                      transform: Matrix4.translationValues(animation1.value*width, 0.0, 0.0),
                                      child: Text("Please answer the question below with the exact"
                                          " answer you gave whiles signing up", style: TextStyle(
                                          color: Colors.black87, fontSize: 23, fontFamily:'OpenSans'),),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top:20.0, left:10),
                                    child: Align(alignment: Alignment.centerLeft,
                                        child: Transform(
                                            transform: Matrix4.translationValues(animation2.value*width, 0.0, 0.0),
                                            child: Text("Security Question:", style: TextStyle(color: Colors.black87, fontSize: 23,fontFamily:'OpenSans'),))),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Transform(
                                      transform: Matrix4.translationValues(animation2.value*width, 0.0, 0.0),
                                        child: Text("${this.userData["security_questions"]}", style: TextStyle(color: Colors.redAccent, fontSize: 20, fontFamily:'OpenSans'),)),
                                  ),
                                  Form(
                                    key: _formkey,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: Transform(
                                            transform: Matrix4.translationValues(animation3.value*width, 0.0, 0.0),
                                            child: Container(
                                              width: 300,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.black),
                                                  borderRadius: BorderRadius.circular(50)
                                              ),
                                              child: TextFormField(
                                                onSaved: (input) => this._answer,
                                                controller: _answer,
                                                style: TextStyle(fontSize: 20),
                                                decoration: InputDecoration(hintText: "Answer",
                                                    hintStyle: TextStyle(fontFamily: 'ReemKufi'),
                                                    icon: Padding(
                                                      padding: const EdgeInsets.only(left:8.0),
                                                      child: Icon(Icons.check_box, size: 20,),
                                                    ), border: InputBorder.none),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top:35.0),
                                          child: Transform(
                                            transform: Matrix4.translationValues(animation4.value*width, 0.0, 0.0),
                                            child: Container(
                                                width: 300,
                                                height: 50,
//                                      decoration: BoxDecoration(
//                                          color: Colors.blue,
//                                          border: Border.all(color: Colors.blue),
////                                          borderRadius: BorderRadius.only(
////                                              topRight: Radius.circular(30),
////                                              bottomLeft: Radius.circular(30)
////                                          )
//                                      ),
                                                child: RaisedButton(
                                                  color: Colors.blue,
                                                  textColor: Colors.black,
                                                  shape: CircleBorder(
                                                      side: BorderSide(
                                                        color: Colors.blue,

                                                      )
                                                  ),
                                                  onPressed: (){
                                                    confirmAnswer(context);
                                                  },
                                                  elevation: 5,
                                                  child: Icon(FontAwesomeIcons.arrowRight,
                                                    color:Colors.white ,),
                                                )
                                            ),
                                          ),
                                        ),
                                          Padding(
                                              padding: const EdgeInsets.only(top:35.0),
                                              child: GestureDetector(
                                                child: Transform(
                                                    transform: Matrix4.translationValues(animation4.value*width, 0.0, 0.0),
                                                    child: Text("Not me! Change email", style: TextStyle(fontSize: 20),)), onTap: (){
                                                Navigator.of(context).pop();
                                              },)
                                          )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
        });

  }
}


class SetPassword extends StatefulWidget {
  final data;

  const SetPassword(this.data);
  @override
  _SetPasswordState createState() => _SetPasswordState(this.data);
}

class _SetPasswordState extends State<SetPassword> with SingleTickerProviderStateMixin{

  Animation animation, animation1, animation2, animation3, animation4, rotate;
  AnimationController animationController, animationController1;

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  void initState() {
    super.initState();
//    animationController1 = AnimationController(duration: Duration(milliseconds: 500), vsync: this,
//    upperBound: pi* 2);
    // RotationTransition(turns: null)
    // rotate =
    animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
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


  final TextEditingController _newPassword = TextEditingController();

  final TextEditingController _confirmPassword = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final userData;

  var data;
  var newData;

  _SetPasswordState(this.userData);

  Future setPassword(BuildContext context) async{
    final formState = _formkey.currentState;
    if(formState.validate()){
      Dialogs.showLoadingDialog(context, _keyLoader);//invoking login
      final response = await http.post("${baseUrl}users/reset/password/", body: {
        "user_id": this.userData["user_id"],
        "new_password": _newPassword.text,
        "confirm_password": _confirmPassword.text,
      });

      print(response.body);
      if(response.statusCode == 200){
        data = json.decode(response.body);
        newData = data["results"];
        Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();//close the dialoge
        Navigator.of(context).pop();
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn()));
      }else{
        {
          Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();//close the dialoge
          data = json.decode(response.body);
          var details =data["detail"];
          print(response.body);
          showDialog(context: context,
              barrierDismissible: true,
              child: CupertinoAlertDialog(
                content: Text(
                  "$details",
                  style: TextStyle(fontSize: 16.0),
                ),
              ));
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    var _blank = FocusNode();
    final double width = MediaQuery
    .of(context)
    .size.width;
    animationController.forward();

    return AnimatedBuilder(animation: animationController,
        builder: (BuildContext context, Widget child){
      SizeConfig().init(context);
      return Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(_blank);
          },
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image(image: AssetImage('images/Welcome.png'), fit: BoxFit.cover,),
             Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ListView(
                        children: <Widget>[
                          Container(
                            height: SizeConfig.screenHeight,
                            width: SizeConfig.screenWidth,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top:30.0),
                                  child: Transform(
                                    transform: Matrix4.translationValues(animation.value*width, 0.0, 0.0),
                                    child: Text('M',style: TextStyle(
                                      fontFamily: 'ButterflyKiss',
                                      fontSize: 150,
                                    ),),
                                  ),
                                ),
                                Transform(
                                  transform: Matrix4.translationValues(animation.value*width, 0.0, 0.0),
                                  child: Text(
                                    'M  e  d  s  A  i  d',
                                    style: TextStyle(fontSize: 20, fontFamily: 'OpenSans'),
                                  ),
                                ),
//                    Align(alignment: Alignment.topCenter, child: Padding(
//                      padding: const EdgeInsets.fromLTRB(85.0, 40, 70, 20),
//                      child: Image(image: AssetImage("assets/meds.PNG"), width: 250, height: 250,),
//                    )
//                    ),
                                Padding(
                                  padding: const EdgeInsets.only(top:20.0),
                                  child: Transform(
                                    transform: Matrix4.translationValues(animation.value*width, 0.0, 0.0),
                                    child: Text("Set Password", style: TextStyle(fontSize: 35,
                                        fontFamily: 'OpenSans'),),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8, top: 20),
                                  child: Transform(
                                    transform: Matrix4.translationValues(animation1.value*width, 0.0, 0.0),
                                    child: Text(
                                      "Congrats ${this.userData["first_name"]}! You can now create a new password",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(top:25.0),
                                  child: Form(
                                    key: _formkey,
                                    child: Column(
                                      children: <Widget>[
                                        Transform(
                                          transform: Matrix4.translationValues(animation2.value*width, 0.0, 0.0),
                                          child: Container(
                                            width: 300,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                border: Border.all(color: Colors.black),
                                                borderRadius: BorderRadius.circular(50)
                                            ),
                                            child: TextFormField(
                                              onSaved: (input) => this._newPassword,
                                              controller: _newPassword,
                                              obscureText: true,
                                              style: TextStyle(fontSize: 23),
                                              decoration: InputDecoration(hintText: "New Password",
                                                  hintStyle: TextStyle(fontFamily: 'ReemKufi', fontSize: 20),
                                                  icon: Padding(
                                                    padding: const EdgeInsets.only(left:8.0),
                                                    child: Icon(Icons.check_box, size: 20,),
                                                  ), border: InputBorder.none),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 40.0),
                                          child: Transform(
                                            transform:  Matrix4.translationValues(animation3.value*width, 0.0, 0.0),
                                            child: Container(
                                              width: 300,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.black),
                                                  borderRadius: BorderRadius.circular(50)
                                              ),
                                              child: TextFormField(
                                                onSaved: (input) => this._confirmPassword,
                                                controller: _confirmPassword,
                                                obscureText: true,
                                                style: TextStyle(fontSize: 23),
                                                decoration: InputDecoration(hintText: "Confirm Password",
                                                    hintStyle: TextStyle(fontFamily: 'ReemKufi', fontSize: 20),
                                                    icon: Padding(
                                                      padding: const EdgeInsets.only(left:8.0),
                                                      child: Icon(Icons.check_box, size: 20,),
                                                    ), border: InputBorder.none),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top:40.0),
                                          child: Transform(
                                            transform: Matrix4.translationValues(animation4.value*width, 0.0, 0.0),
                                            child: Container(
                                                width: 300,
                                                height: 50,
//                                        decoration: BoxDecoration(
//                                            color: Colors.blue,
//                                            border: Border.all(color: Colors.blue),
//                                            borderRadius: BorderRadius.only(
//                                                topRight: Radius.circular(30),
//                                                bottomLeft: Radius.circular(30)
//                                            )
//                                        ),
                                                child: RaisedButton(
                                                    color: Colors.blue,
                                                    textColor: Colors.black,
                                                    shape:CircleBorder(
                                                        side: BorderSide(color: Colors.blue)
                                                    ),
                                                    onPressed: (){
                                                      setPassword(context);
                                                    },
                                                    elevation: 5,
                                                    child:Icon(FontAwesomeIcons.arrowRight,
                                                    color: Colors.white)
                                                )
                                            ),
                                          ),
                                        ),
//                      Padding(
//                          padding: const EdgeInsets.only(top:70.0),
//                          child: GestureDetector(child: Text("Not me! Change email", style: TextStyle(fontSize: 20),), onTap: (){
//                            Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmEmail()));
//                          },)
//                      )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
        }
        );

  }
}
