import 'package:flutter/material.dart';

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
            onWillPop: () async => false,
            child: SimpleDialog(
                elevation: 0,
                key: key,
                backgroundColor: Colors.transparent,
                children: <Widget>[
                  Center(
                    child: Column(children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Please Wait....",
                        style: TextStyle(color: Colors.blueAccent),
                      )
                    ]),
                  )
                ]),
          );
        });
  }

  static Future<void> showLoadingIndicator(BuildContext context) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
            onWillPop: () async => false,
            child: SimpleDialog(
                elevation: 0,
                backgroundColor: Colors.transparent,
                children: <Widget>[
                  Center(
                    child: Column(children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Please Wait....",
                        style: TextStyle(color: Colors.blueAccent),
                      )
                    ]),
                  )
                ]),
          );
        });
  }
}

void showSnackBar(BuildContext context, String message, {int duration}) {
  SnackBar snackBar = SnackBar(
    duration: Duration(milliseconds: duration ?? 3000),
    content: Text(
      message,
    ),
    backgroundColor: Colors.grey[800],
  );
  Scaffold.of(context).showSnackBar(snackBar);
}
