import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'auth/signIn.dart';
import 'ui/homepage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
//  get token => null;
  String baseURL = "http://medsaid.herokuapp.com/auth/";
  BuildContext snackbarContext;

  void showSnackBar(BuildContext context, String message) {
    SnackBar snackBar = SnackBar(
      duration: Duration(seconds: 30),
      content: Text(
        message,
      ),
      action: SnackBarAction(
        label: 'RETRY',
        onPressed: () async {
          await login();
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void apiFeedback(String type, String message) {
    showSnackBar(snackbarContext, message);
    print('$type! $message');
  }

  Future<void> login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var user = prefs.get('user');
    print(token);
    print(user);
    try {
      if (token != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignIn()));
      } else {
        final verify = await post('${baseURL}verify/', body: {
          'token': token.toString(),
        });

        if (verify.statusCode == 200) {
          final refresh = await post('${baseURL}refresh/', body: {
            'token': token.toString(),
          });
          if (refresh.statusCode == 200) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => SignIn()));
          } else {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => SignIn()));
          }
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => SignIn()));
        }
      }
    } on SocketException catch (e) {
      apiFeedback("SocketException", e.message);
    } on TimeoutException catch (e) {
      apiFeedback("TimeoutException", e.message);
    } catch (e) {
      if (e is FormatException) print(true);
      apiFeedback("FormatException", e.message);
    }
  }

  @override
  void initState() {
    super.initState();
    // Timer(Duration(seconds: 3), () => login());
    login();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          snackbarContext = context;
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          AnimatedDefaultTextStyle(
                              style: GoogleFonts.butterflyKids(
                                textStyle: TextStyle(
                                    fontSize: 120, color: Colors.black),
                              ),
                              duration: const Duration(milliseconds: 200),
                              child: Text('M',
                                  style: Theme.of(context).textTheme.display4)),
                          Text(
                            'M  e  d  s  A  i  d',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w300,
                                fontSize: 28,
                                color: Colors.black),
                          )
                        ],
                      )),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  )
                ],
              ),
              Center(
                child: SpinKitChasingDots(
                  color: Colors.blueGrey,
                  duration: Duration(seconds: 3),
                  size: 60,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
