import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:meds_aid/src/auth/signup/finalization/doctor_finalization.dart';
import 'package:meds_aid/src/auth/signup/sign_up.dart';
import 'package:meds_aid/src/ui/widgets/dialogs.dart';
import 'package:meds_aid/src/ui/widgets/inputs.dart';
import 'package:meds_aid/src/ui/widgets/labels.dart';
import 'package:meds_aid/src/utils/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'signup/service_input.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> with SingleTickerProviderStateMixin {
  Animation animation, animation1, animation2, animation3, animation4, rotate;
  AnimationController animationController, animationController1;
  TextStyle defaultTextStyle;
  double width = 0;
  bool obscure = true;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  BuildContext snackbarContext;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    width = MediaQuery.of(context).size.width;
    defaultTextStyle = Theme.of(context).textTheme.body1;
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    animation = Tween(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn),
    );

    animation1 = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(0.3, 1.0, curve: Curves.fastOutSlowIn),
    ));

    animation2 = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    ));

    animation3 = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(0.7, 1.0, curve: Curves.fastOutSlowIn),
    ));

    animation4 = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(0.9, 1.0, curve: Curves.fastOutSlowIn),
    ));
  }

  var data, token, user, userProfile;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  var _blank = FocusNode();
  final TextEditingController _user = TextEditingController();
  final TextEditingController _password = TextEditingController();

  void apiFeedback(String type, String message) {
    showSnackBar(snackbarContext, message);
    print('$type! $message');
  }

  Future signIn(BuildContext context) async {
    final formState = _formkey.currentState;
    if (formState.validate()) {
      formState.save();
      setState(() {});

      try {
        Dialogs.showLoadingDialog(context, _keyLoader); //invoking login
        final response = await http
            .post('http://medsaid.herokuapp.com/api/provider/login/', body: {
          "email": _user.text,
          "password": _password.text,
        });
        Navigator.of(_keyLoader.currentContext, rootNavigator: true)
            .pop(); //close the dialog

        if (response.statusCode == 200) {
          data = json.decode(response.body);
          token = data["token"]["token"];
          user = data["user"]["user_full_name"];
          userProfile = data["user"]["userProfile"];

          // TODO add Home UI
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=> HomeUi(),));

          print(response.body);
          print(token);
          saveTokenPreference(token, user, userProfile);
          print(user);
        } else {
          data = json.decode(response.body);
          print(data['detail']);

          showSnackBar(snackbarContext, data['results'] ?? data['detail']);
        }
      } on SocketException catch (e) {
        apiFeedback("SocketException", e.message);
      } on TimeoutException catch (e) {
        apiFeedback("TimeoutException", e.message);
      } catch (e) {
        if (e is FormatException) print('Format Exception');
        // apiFeedback("FormatException", e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    animationController.forward();
    // animationController.reverse();
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return Scaffold(
            body: Builder(builder: (BuildContext buildcontext) {
              snackbarContext = buildcontext;
              return GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(_blank);
                },
                child: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    // Image(
                    //   image: AssetImage('images/Welcome.png'),
                    //   fit: BoxFit.cover,
                    // ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              header(),
                              Padding(
                                padding: const EdgeInsets.only(top: 50),
                              ),
                              form()
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
          );
        });
  }

  Widget header() {
    return Column(mainAxisSize: MainAxisSize.max, children: [
      Padding(
        padding: const EdgeInsets.only(top: (0)),
      ),
      Transform(
        transform: Matrix4.translationValues(animation.value * width, 0.0, 0.0),
        child: Text('M', style: Theme.of(context).textTheme.display4),
      ),
      Transform(
        transform: Matrix4.translationValues(animation.value * width, 0.0, 0.0),
        child: Text('M  e  d  s  A  i  d',
            style: defaultTextStyle.copyWith(
                fontSize: 13, fontWeight: FontWeight.w500)),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 40),
      ),
      Transform(
        transform:
            Matrix4.translationValues(animation1.value * width, 0.0, 0.0),
        child: Text(
          'Sign In',
          style: defaultTextStyle.copyWith(
            fontSize: 23,
          ),
        ),
      ),
    ]);
  }

  Widget form() {
    return Form(
      key: _formkey,
      child: Column(
        children: <Widget>[
          Transform(
            transform:
                Matrix4.translationValues(animation2.value * width, 0.0, 0.0),
            child: SizedBox(
                width: 300,
                child: InputField(
                  _user,
                  'Email',
                )),
          ),
          SizedBox(
            height: 25,
          ),
          Transform(
            transform:
                Matrix4.translationValues(animation2.value * width, 0.0, 0.0),
            child: SizedBox(
              width: 300,
              child: InputField(
                _password,
                'Password',
                obscureText: true,
                hasObscureToggle: true,
              ),
            ),
          ),
          SizedBox(
            height: 55,
          ),
          loginButton(),
          bottomOptions(),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  Widget loginButton() {
    return Transform(
      transform: Matrix4.translationValues(animation3.value * width, 0.0, 0.0),
      child: Container(
        width: 300,
        child: RaisedButton(
          padding: EdgeInsets.all(0),
          elevation: 1,
          textColor: Colors.white,
          color: Colors.blue[700],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onPressed: () {
            // animationController.forward();
            signIn(context);
          },
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                    colors: [Colors.blue[500], Colors.blue[700]],
                    stops: [0, 1],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
            child: Center(
              child: Text("Login",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5)),
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomOptions() {
    return Transform(
      transform: Matrix4.translationValues(animation4.value * width, 0.0, 0.0),
      child: Column(
        // crossAxisAlignment: Center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 25),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Forgot password?',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
          ),
          SizedBox(
              width: 320,
              child: Divider(
                thickness: 0.5,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('New user?',
                  style: TextStyle(
                    fontSize: 11,
                  )),
              InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProviderSignUp()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool> saveTokenPreference(
      String token, String user, String userProfile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('token', token);
      prefs.setString('user', user);
      prefs.setString('userProfile', userProfile);
      // return prefs.;
    });

    return prefs == null;
  }
}
