import 'package:flutter/material.dart';
import 'package:meds_aid/src/models.dart/request.dart';

class RequestItem extends StatefulWidget {
  final PatientRequest request;
  const RequestItem({Key key, this.request}) : super(key: key);

  RequestItemState createState() => RequestItemState();
}

class RequestItemState extends State<RequestItem> {
  int counter;
  PatientRequest request;
  @override
  void initState() {
    super.initState();
    request = widget.request;
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
      children: <Widget>[topRow(context), bottomRow(context)],
    );
  }

  Widget topRow(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(14, 16, 14, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(request.statement,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  )),
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
                padding: const EdgeInsets.symmetric(vertical: 4),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
            child: FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(6))),
          padding: EdgeInsets.symmetric(vertical: 14),
          onPressed: () {
            print('not pressed');
          },
          child: Text('Accept'),
        )),
        Expanded(
            child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(6))),
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('Cancel'),
                onPressed: () {
                  print('not pressed');
                }))
      ],
    );
  }
}
