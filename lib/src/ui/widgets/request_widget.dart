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
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      constraints: BoxConstraints(
        minHeight: 85,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(25)),
          border: Border.all(color: Colors.grey[500], width: 0.2)),
      child: buildContents(),
    );
  }

  Widget buildContents() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[image(), center(), trailing()],
    );
  }

  Widget image() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: SizedBox(
        height: 55,
        width: 55,
        child: Image.network(
          request.imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent loadingProgress) {
            if (loadingProgress == null) return child;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes
                      : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget center() {
    return Container(
      //  color: Colors.red[600],
      padding: EdgeInsets.only(left: 25, right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(children: <Widget>[
            Container(
                width: 186,
                child: Text(
                  request.providerName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 19),
                )),
          ]),
          SizedBox(height: 5),
          Row(
            children: <Widget>[
              Icon(Icons.access_time, size: 11, color: Colors.grey[600]),
              SizedBox(width: 3),
              Text(request.requestedAt ?? '',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600])),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: <Widget>[
              Icon(Icons.location_on, size: 11, color: Colors.grey[600]),
              SizedBox(width: 3),
              Text('Abelemkpe, Accra',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600])),
            ],
          )
        ],
      ),
    );
  }

  Widget trailing() {
    return SizedBox(
      width: 40,
      height: 40,
      child: IconButton(
        icon: Icon(Icons.open_in_new),
        onPressed: () {},
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
