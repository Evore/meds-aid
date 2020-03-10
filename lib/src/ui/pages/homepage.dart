import 'package:flutter/material.dart';
import 'package:meds_aid/src/models.dart/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetch();
  }

  Future fetch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.get('token');
    await fetchPatientRequest(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF254890),
        body: Center(
          child: AspectRatio(
            aspectRatio: 10 / 1,
          ),
        ));
  }
}
