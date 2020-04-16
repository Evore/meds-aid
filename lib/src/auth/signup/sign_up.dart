import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:meds_aid/src/auth/signup/service_input.dart';
import 'package:meds_aid/src/providers/sign_up_model.dart';
import 'dart:convert';

import 'package:meds_aid/src/ui/widgets/dialogs.dart';
import 'package:meds_aid/src/ui/widgets/inputs.dart';
import 'package:provider/provider.dart';

class ProviderSignUp extends StatefulWidget {
  @override
  _ProviderSignUpState createState() => _ProviderSignUpState();
}

class _ProviderSignUpState extends State<ProviderSignUp>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController fName = TextEditingController();
  final TextEditingController lName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController cPassword = TextEditingController();
  final TextEditingController phone = TextEditingController();
  FocusNode rootFocus = FocusNode();

  var data;
  String dropDownValue;

  double width;

  TextStyle defaultTextStyle;
  SnackBar snackBar = SnackBar(content: Text(''));

  Animation animation, animation1, animation2, animation3, animation4, rotate;
  AnimationController animationController, animationController1;
  BuildContext snackbarContext;
  bool obscure = true;
  SignUpModel provider;
  double topInsets;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    width = MediaQuery.of(context).size.width;
    provider = Provider.of<SignUpModel>(context);
    defaultTextStyle = Theme.of(context).textTheme.body1;
    topInsets = MediaQuery.of(context).padding.top;
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

    animationController.forward();
  }

  Future holdValues() async {
    provider.firstName = fName.text;
    provider.lastName = lName.text;
    provider.email = email.text;
    provider.phoneNumber = phone.text;
    provider.password = password.text;
    provider.confirmPassword = cPassword.text;
  }

  void apiFeedback(String type, String message) {
    showSnackBar(snackbarContext, message);
    print('$type! $message');
  }

  Future verifyValues(BuildContext context) async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();

      try {
        Dialogs.showLoadingIndicator(context);
        final response = await post(
          'http://medsaid.herokuapp.com/api/provider/email/verify/',
          body: {
            "email": email.text,
            "password": password.text,
            "password2": cPassword.text
          },
        );
        Navigator.of(context).pop(); //close the dialog

        data = json.decode(response.body);
        if (int.parse(data['response_code']) == 100) {
          print(data['results']);
          await holdValues();
          print(data);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ServiceInput()));
        } else {
          data = json.decode(response.body);
          showSnackBar(snackbarContext, data['results'] ?? data['detail']);
          print(response.body);
          print(data);
        }
      } on SocketException catch (e) {
        apiFeedback("SocketException", e.message);
        Navigator.pop(context);
      } on TimeoutException catch (e) {
        apiFeedback("TimeoutException", e.message);
        Navigator.pop(context);

      } catch (e) {
        if (e is FormatException) print(true);
        apiFeedback("FormatException", e.toString());
        Navigator.pop(context);

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) => Scaffold(
        body: Builder(builder: (BuildContext context) {
          snackbarContext = context;
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(rootFocus);
            },
            child: ListView(
              padding: EdgeInsets.only(top: 50 + topInsets),
              children: <Widget>[header(), inputFields()],
            ),
          );
        }),
      ),
    );
  }

  Widget header() {
    return Column(
      children: <Widget>[
        Transform.translate(
          offset: Offset(animation.value * width, 0),
          child: Text('M', style: Theme.of(context).textTheme.display4),
        ),
        Transform.translate(
          offset: Offset(animation.value * width, 0),
          child: Text('M  e  d  s  A  i  d',
              style: defaultTextStyle.copyWith(
                  fontSize: 13, fontWeight: FontWeight.w500)),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40),
        ),
        Transform.translate(
          offset: Offset(animation1.value * width, 0),
          child: Text(
            'Create an account',
            style: defaultTextStyle.copyWith(
              fontSize: 22,
            ),
          ),
        ),
        SizedBox(
          height: 50,
        ),
      ],
    );
  }

  Widget inputFields() {
    return Form(
      key: _formKey,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Transform.translate(
            offset: Offset(animation1.value * width, 0),
            child: Container(
              width: 300,
              child: InputField(
                fName,
                'First Name',
                validator: (input) => input.isEmpty ? 'Enter First Name' : null,
              ),
            ),
          ),
          SizedBox(height: 20),
          Transform.translate(
            offset: Offset(animation1.value * width, 0),
            child: Container(
              width: 300,
              child: InputField(
                lName,
                'Last Name',
                validator: (input) => input.isEmpty ? 'Enter Last Name' : null,
              ),
            ),
          ),
          SizedBox(height: 20),
          Transform.translate(
            offset: Offset(animation2.value * width, 0),
            child: Container(
              width: 300,
              child: InputField(
                email,
                'Email',
                hint: 'Email Address',
                validator: (input) =>
                    input.isEmpty ? 'Enter a valid email address' : null,
              ),
            ),
          ),
          SizedBox(height: 20),
          Transform.translate(
            offset: Offset(animation2.value * width, 0),
            child: Container(
              width: 300,
              child: InputField(
                phone,
                'Phone Number',
                textInputType: TextInputType.number,
                validator: (input) =>
                    input.isEmpty ? 'Enter your phone number' : null,
              ),
            ),
          ),
          SizedBox(height: 55),
          Transform.translate(
            offset: Offset(animation3.value * width, 0),
            child: Container(
              width: 300,
              child: InputField(
                password,
                'Password',
                hasObscureToggle: true,
                obscureText: true,
                validator: (input) => input.isEmpty ? 'Enter a password' : null,
              ),
            ),
          ),
          SizedBox(height: 20),
          Transform.translate(
            offset: Offset(animation4.value * width, 0),
            child: Container(
              width: 300,
              child: InputField(
                cPassword,
                'Confirm Password',
                hasObscureToggle: true,
                obscureText: true,
                validator: (input) => input.isEmpty ? 'Field is empty' : null,
              ),
            ),
          ),
          SizedBox(height: 50),
          nextButton(),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget nextButton() {
    return Transform.translate(
      offset: Offset(animation.value * width, 0),
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
            verifyValues(context);
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
              child: Text("Continue",
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
}
