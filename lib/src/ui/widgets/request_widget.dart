import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:meds_aid/src/models.dart/request.dart';
import 'package:meds_aid/src/ui/widgets/dialogs.dart';
import 'dart:io';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class RequestItem extends StatefulWidget {
  final PatientRequest request;
  final BuildContext sbContext;
  const RequestItem({Key key, this.request, this.sbContext}) : super(key: key);

  RequestItemState createState() => RequestItemState();
}

class RequestItemState extends State<RequestItem> {
  int counter;
  bool isPending = true;

  PatientRequest request;
  @override
  void initState() {
    super.initState();
    request = widget.request;
    isPending = checkStatus(request.status);
  }

  bool checkStatus(String status) {
    return status.toLowerCase() == 'pending';
  }

  void apiFeedback(String type, String message) {
    showSnackBar(widget.sbContext, message);
    print('$type! $message');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(14, 10, 14, 0),
      constraints: BoxConstraints(
        minHeight: 100,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6)),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Color(0x20002b33),
              offset: Offset(0, 3.5),
              blurRadius: 5.5,
              spreadRadius: 0),
        ],
      ),
      child: buildContents(context),
    );
  }

  Widget buildContents(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[topRow(context), if (isPending) bottomRow(context)],
    );
  }

  Widget statusWidget() {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: isPending ? Color(0xb08b9090) : Colors.pink[300],
        ),
        child: Text(
          request.status,
          style: TextStyle(color: Colors.white, fontSize: 10),
        ),
      ),
    );
  }

  Widget topRow(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 14, 10, 12),
      child: Stack(
        children: <Widget>[
          statusWidget(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(request.statement,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    )),
              ),
              SizedBox(height: 6),
              Text(request.speciality,
                  style: TextStyle(
                      color: Colors.grey[700], fontWeight: FontWeight.w400)),
              SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 4, 4),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.access_time, size: 17, color: Colors.grey[700]),
                    SizedBox(width: 8),
                    // Text('Requested at : ',
                    //     style: TextStyle(
                    //         color: Colors.grey[700],
                    //         fontWeight: FontWeight.w400)),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 200),
                      child: Text(request.requestedAt,
                          softWrap: true,
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Text(
                  "\" ${request.description}\" ",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget bottomRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6))),
            onPressed: () {
              handleRequest('accept');
            },
            child: Text('Accept'),
          ),
          FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              child: Text('Reject'),
              onPressed: () {
                handleRequest('reject');
              })
        ],
      ),
    );
  }

  Future<void> handleRequest(String requestResponse) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      String token = prefs.get('token');
      Dialogs.showLoadingIndicator(context); //invoking login
      final response = await get(
          'http://medsaid.herokuapp.com/api/provider/request/status/${request.requestId}/$requestResponse',
          headers: {"Authorization": "JWT $token"});
      Navigator.of(context).pop();
      var data = json.decode(response.body);
      print(data['results']['status']);
    } on SocketException catch (e) {
      apiFeedback("SocetException", e.message);
      Navigator.pop(context);
    } on TimeoutException catch (e) {
      apiFeedback("TimeoutException", e.message);
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      if (e is FormatException) print(e.message);
    }
  }
}
