import 'package:flutter/material.dart';
import 'package:meds_aid/src/providers/sign_up_model.dart';
import 'package:meds_aid/src/ui/widgets/dialogs.dart';
import 'package:meds_aid/src/ui/widgets/inputs.dart';

import 'package:provider/provider.dart';

import 'finalization/doctor_finalization.dart';

class ServiceInput extends StatefulWidget {
  @override
  _ServiceInputState createState() => _ServiceInputState();
}

class _ServiceInputState extends State<ServiceInput> {
  FocusNode rootFocus = FocusNode();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextStyle defaultTextStyle;
  SnackBar snackBar = SnackBar(content: Text(''));

  BuildContext snackbarContext;
  bool obscure = true;
  SignUpModel provider;
  double topInsets;

  bool disabled = false;
  String service;
  List services = <String>["Doctor", "Nurse", "Pharmacy", "Ambulance Service"];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = Provider.of<SignUpModel>(context);
    defaultTextStyle = Theme.of(context).textTheme.body1;
    topInsets = MediaQuery.of(context).padding.top;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          snackbarContext = context;
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(rootFocus);
            },
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Form(
                  key: _formkey,
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(40, 80 + topInsets, 40, 0),
                    children: <Widget>[
                      header(),
                      serviceDropdown(),
                      nextButton()
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget header() {
    return Column(
      children: <Widget>[
        Text('M', style: Theme.of(context).textTheme.display4),
        Text('M  e  d  s  A  i  d',
            style: defaultTextStyle.copyWith(
                fontSize: 13, fontWeight: FontWeight.w500)),
        Padding(
          padding: const EdgeInsets.only(top: 40),
        ),
        Text(
          'Select Service',
          style: defaultTextStyle.copyWith(
            fontSize: 22,
          ),
        ),
        SizedBox(height: 50)
      ],
    );
  }

  Widget serviceDropdown() {
    return Column(children: [
      DropDownField(
        label: 'Service',
        items: services,
        value: service,
        hint: "Select service (eg. doctor)",
        onChanged: (input) {
          service = input;
        },
      ),
      SizedBox(
        height: 30,
      ),
    ]);
  }

  Widget nextButton() {
    return Container(
      width: 300,
      child: RaisedButton(
        padding: EdgeInsets.all(0),
        elevation: 1,
        textColor: Colors.white,
        color: Colors.blue[700],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: () {
          verifyValues();
        },
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                  colors: [Colors.blue[500], Colors.blue[700]],
                  stops: [0, 1],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Center(
            child: Text("Continue",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5)),
          ),
        ),
      ),
    );
  }

  Future verifyValues() async {
    final formState = _formkey.currentState;
    if (formState.validate()) {
      formState.save();
      provider.service = service;

      bool isPractitioner;

      if (service != 'Ambulance Service') {
        if (service == 'Pharmacy') {
          isPractitioner = false;
        } else {
          isPractitioner = true;
        }
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DocFinalization(
                  isMedicalPractitioner: isPractitioner,
                )));
      } else {
        showSnackBar(snackbarContext, 'Selected feature currently unavailable');
      }
    }
  }
}
