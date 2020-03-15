import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:meds_aid/src/auth/signIn.dart';
import 'package:meds_aid/src/models.dart/request.dart';
import 'package:meds_aid/src/ui/widgets/dialogs.dart';
import 'package:meds_aid/src/ui/widgets/request_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool isLoading = true;
  List<PatientRequest> requests = <PatientRequest>[];
  BuildContext snackbarContext;
  String errorMessage;

  final refreshKey = GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetch();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Returns a Future<List<PatientRequest>> object unless, an arror occurs, where it returns the error string
  fetchRequest(String token, BuildContext context) async {
    try {
      final response = await get(
        'http://medsaid.herokuapp.com/api/provider/requests/',
        headers: {"Authorization": "JWT $token"},
      );
      final body = json.decode(response.body);

      bool typeCheck;

      try {
        typeCheck = (body['detail'] == null);
      } catch (e) {
        print(e.toString());
        typeCheck = true;
      }

      final result =
          typeCheck ? compute(parseContent, response.body) : body['detail'];

      return result;
    } on SocketException catch (e) {
      print(e.message);
      showSnackBar(snackbarContext, 'Connection failed', duration: 1000);
      return 'Failed to reach our servers. Try reloading the page';
    } on TimeoutException catch (e) {
      print(e.message);
      return 'Request timed out. Try reloading the page';
    } on ClientException catch (e) {
      print(e.message);
      return 'We encountered an unexpected error';
    } on FormatException catch (e) {
      print(e.message);
      showSnackBar(context, e.message);
    }
  }

  Future fetch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.get('token');
    print(prefs.get('userProfile'));

    fetchRequest(token, snackbarContext).then((results) {
      //fetch request can return null values so check for those
      if (results != null) {
        if (results is List<PatientRequest>) {
          this.requests = results;
          print(true);
        } else if (results is String) {
          errorMessage = results;
          if (results.contains('expired')) {
            showSnackBar(snackbarContext, 'Routing to login...');
            Future.delayed(Duration(milliseconds: 400), () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => SignIn()));
            });
          }
          print(results);
        }
      }

      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(
        builder: (snackbarContext) {
          this.snackbarContext = snackbarContext;
          return Container(
              decoration: verticalGradient(),
              child: isLoading
                  ? loading()
                  : requests == null ? emptyWidget() : requestsListWidget());
        },
      ),
    );
  }

  BoxDecoration verticalGradient() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xffffffff),
          Colors.lightBlue[100],
          Colors.blue[300],
        ],
        stops: [0, 0.4, 1],
      ),
    );
  }

  Widget loading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget requestsListWidget() {
    return requests.isNotEmpty ? requestList() : emptyWidget();
  }

  Widget requestList() {
    //TODO: Change to futurebuilder

    return RefreshIndicator(
      key: refreshKey,
      onRefresh: fetch,
      child: ListView.builder(
        itemCount: requests.length,
        itemBuilder: (BuildContext context, int index) {
          return RequestItem(
            request: requests[index],
            sbContext: snackbarContext,
          );
        },
      ),
    );
  }

  Widget emptyWidget() {
    return RefreshIndicator(
      key: refreshKey,
      onRefresh: fetch,
      child: ListView(
        children: [
          ConstrainedBox(
            constraints: (BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
              maxWidth: MediaQuery.of(context).size.width,
            )),
            child: Center(
              child: Text(errorMessage),
            ),
          ),
        ],
      ),
    );
  }
}
