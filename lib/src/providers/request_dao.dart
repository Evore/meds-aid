import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:flutter/foundation.dart';
import 'package:meds_aid/src/models.dart/request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestDao extends ChangeNotifier {
  List<PatientRequest> requests = [];
  String errorMessage = '';
  bool finishedFetch = false;

  RequestDao() {
    init();
  }

  init() {
    _fetch().whenComplete(() {
      notifyListeners();
    });
  }

  Future refresh() async {
    await _fetch();
  }

  void showErrorMessage(String message) {}

  Future _fetch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.get('token');

    _fetchRequest(token).then((results) {
      //fetch request can return null values so check for those
      if (results != null) {
        if (results is List<PatientRequest>) {
          this.requests = results;
          finishedFetch = true;
          errorMessage = '';
          notifyListeners();

          print("results: $results");
        } else if (results is String) {
          errorMessage = results;
          finishedFetch = true;
          notifyListeners();

          if (results.contains('expired')) {}
          print("RequestDao results: $results");
        }
      }
    });
  }

  // Returns a Future<List<PatientRequest>> object unless, an arror occurs, where it returns the error string

  _fetchRequest(String token) async {
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
      // showSnackBar(snackbarContext, 'Connection failed', duration: 1000);
      return 'Failed to reach our servers. Try reloading the page';
    } on TimeoutException catch (e) {
      print(e.message);
      return 'Request timed out. Try reloading the page';
    } on ClientException catch (e) {
      print(e.message);
      return 'We encountered an unexpected error';
    } on FormatException catch (e) {
      print("e: ${e.message}");
      // showSnackBar(context, e.message);
    }
    notifyListeners();
  }
}
