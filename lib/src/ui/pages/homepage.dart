import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meds_aid/src/models.dart/request.dart';
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

  Future fetch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.get('token');
    print(prefs.get('userProfile'));

    try {
      fetchRequest(token).then((requests) {
        this.requests = requests;
        setState(() {
          isLoading = false;
        });
      });
    } on SocketException catch (e) {
      print(e.message);
    } on TimeoutException catch (e) {
      print(e.message);
    } on FormatException catch (e) {
      print(e.message);
    }
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
              child: isLoading ? loading() : requestsListWidget());
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

    return ListView.builder(
        itemCount: requests.length,
        itemBuilder: (BuildContext context, int index) {
          return RequestItem(
            request: requests[index], sbContext: snackbarContext,
          );
        });
  }

  Widget emptyWidget() {
    return Center(
      child: Text('Nothing here at the moment'),
    );
  }
}
