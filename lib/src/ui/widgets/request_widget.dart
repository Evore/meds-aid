import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
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
      margin: EdgeInsets.fromLTRB(16, 7, 6, 7),
      constraints: BoxConstraints(
        minHeight: 100,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Color(0x10002733),
              offset: Offset(0, 3.5),
              blurRadius: 2.5,
              spreadRadius: 0),
        ],
      ),
      child: buildContents(),
    );
  }

  Widget buildContents() {
    return Row(
      children: <Widget>[
        SizedBox(height: 50, width: 50, child: CachedNetworkImage(
        imageUrl: request.imageUrl,
        progressIndicatorBuilder: (context, url, downloadProgress) => 
                CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => Icon(Icons.error),
     ),)
      ],
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
      setState(() {
        isPending = false;
      });
    } on SocketException catch (e) {
      apiFeedback("SocketException", e.message);
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
