import 'package:flutter/material.dart';

import '../../signIn.dart';

class SuccessPage extends StatefulWidget {
  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  bool loading = true;

  void toggleLoading(int duration) {
    Future.delayed(Duration(milliseconds: duration), () {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    toggleLoading(300);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: successPage(context));
  }

  Widget successPage(context) {
    return SizedBox.expand(
      child: GestureDetector(
        onTap: () {
          toggleLoading(0);
          // Future.delayed(Duration(milliseconds: 1000), () {
            // Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignIn()));
            print('tapped');
          // });
        },
        child: loading
            ? CircularProgressIndicator()
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(38.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Account successfully created',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'You will be routed back to the sign in page',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'You will gain access your account once your details have been approved.',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        'Tap anywhere to continue',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
