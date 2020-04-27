import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:meds_aid/src/models.dart/request.dart';
import 'package:meds_aid/src/ui/widgets/dialogs.dart';
import 'dart:io';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class AcceptedRequestWidget extends StatefulWidget {
  final PatientRequest request;
  final BuildContext sbContext;
  const AcceptedRequestWidget({Key key, this.request, this.sbContext})
      : super(key: key);

  AcceptedRequestWidgetState createState() => AcceptedRequestWidgetState();
}

class AcceptedRequestWidgetState extends State<AcceptedRequestWidget> {
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
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(children: <Widget>[
            Container(
                width: 190,
                child: Text(
                  request.providerName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 17),
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Test()),
          );
        },
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

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: RequestItem()),
    );
  }
}

class RequestItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      height: 280,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(40)),
          border: Border.all(color: Colors.grey[500], width: 0.2)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Column(
          children: <Widget>[top(), details(), optionRow()],
        ),
      ),
    );
  }

  Widget top() {
    return Container(
      color: Color(0xff3088f8),
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Booking request',
                style: TextStyle(fontSize: 12, color: Colors.white)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(children: [
                  Icon(Icons.access_time, size: 14, color: Colors.white),
                  SizedBox(width: 3),
                  Text('4 Apr 2020, 10 am',
                      style: TextStyle(fontSize: 13, color: Colors.white)),
                ]),
                Row(children: [
                  Icon(Icons.location_on, size: 14, color: Colors.white),
                  SizedBox(width: 3),
                  Text('Abelemkpe, Accra',
                      style: TextStyle(fontSize: 13, color: Colors.white)),
                ])
              ],
            )
          ]),
    );
  }

  Widget details() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 75,
            width: 75,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            // color: Colors.red,
            width: 225,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mark Bediako',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4),
                Text(
                  ''
                          'Thomas Tallis\'s six-part Gaude gloriosa Dei Mater is a Votive Antiphon for the Virgin Mary, '
                          'an early work, possibly composed late in the reign of Henry VIII, considerably before the '
                          'accession of Queen Mary, although some scholars place it during Mary\'s reign'
                          ''
                      .substring(0, 155),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                  style: TextStyle(
                    fontSize: 11,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget optionRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 10, 50, 0),
      child: SizedBox(
        height: 32,
        child: Row(
          children: <Widget>[
            Expanded(
              child: FlatButton(
                onPressed: () {},
                // elevation: 0,
                color: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  'ACCEPT',
                  style: TextStyle(
                    letterSpacing: 0.5,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: FlatButton(
                onPressed: () {},
                // elevation: 0,
                color: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  'ACCEPT',
                  style: TextStyle(
                    letterSpacing: 0.5,
                    fontSize: 13,
                    color: Colors.black,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
