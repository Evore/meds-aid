import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meds_aid/src/auth/signIn.dart';
import 'package:meds_aid/src/auth/signup/finalization/success_page.dart';
import 'package:meds_aid/src/providers/sign_up_model.dart';
import 'package:meds_aid/src/ui/widgets/dialogs.dart';
import 'package:meds_aid/src/ui/widgets/inputs.dart';

import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart';

class DocFinalization extends StatefulWidget {
  final bool isMedicalPractitioner;
  DocFinalization({this.isMedicalPractitioner = true});
  @override
  _DocFinalizationState createState() => _DocFinalizationState();
}

class _DocFinalizationState extends State<DocFinalization> {
  FocusNode rootFocus = FocusNode();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  var data;
  TextEditingController hName, sPin;

  bool success = false;
  TextStyle defaultTextStyle;
  SnackBar snackBar = SnackBar(content: Text(''));

  BuildContext snackbarContext;
  bool obscure = true;
  SignUpModel provider;
  double topInsets;

  List services = <String>["Doctor", "Nurse", "Pharmacy", "Ambulance Service"];
  List specialisations = <String>[
    "Immunology",
    "Anesthesiology",
    "Cardiology",
    "Dermatology",
    "Endocrinology",
    "Gastroenterology",
    "Geriatric Medicine Specialy",
    "Hematology",
    "Nephrology",
    "Gynecology",
    "Oncology",
    "Osteopath",
    "Otolaryngology",
    "Pediatricians",
    "Physiatry",
    "Podiatry",
    "Phsychiatry",
    "Rheumatology",
    "Sleep Medicine Specialy",
    "Sports Medicine Specialy",
    "Urology"
  ];
  List ranks = <String>["Junior", "Senior"];

  @override
  void initState() {
    super.initState();

    hName = TextEditingController();
    sPin = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = Provider.of<SignUpModel>(context);
    defaultTextStyle = Theme.of(context).textTheme.body1;
    topInsets = MediaQuery.of(context).padding.top;
  }

  holdValues(String service) {
    provider.service = service;
  }

  void apiFeedback(String type, String message) {
    showSnackBar(snackbarContext, message);
    print('$type! $message');
  }

  Future verifyValues() async {
    final formState = _formkey.currentState;
    if (formState.validate()) {
      formState.save();
      provider.hospitalName = hName.text;
      provider.servicePin = sPin.text;
      if (widget.isMedicalPractitioner) {
        provider.specialisation = specialisation;
        provider.rank = rank;
      } else {
        provider.specialisation = 'null';
        provider.rank = 'null';
      }
      signUp(context);
    }
  }

  Future signUp(BuildContext context) async {
    // try {
    //   Dialogs.showLoadingIndicator(context);
    //   final response = await post(
    //     'http://medsaid.herokuapp.com/api/provider/signup/',
    //     body: {
    //       "email": provider.email,
    //       "first_name": provider.firstName,
    //       "last_name": provider.lastName,
    //       "position": provider.rank,
    //       "service": provider.service,
    //       "speciality": provider.specialisation,
    //       "phone_number": provider.phoneNumber,
    //       "password": provider.password,
    //       "confirm_password": provider.confirmPassword,
    //       "service_pin": sPin.text,
    //       "hospital": hName.text
    //     },
    //   );
    //   Navigator.of(context).pop();

    //   data = json.decode(response.body);
    //   if (int.parse(data['response_code']) == 100) {
    //     print(data['results']);
    //     print("Success!! $data");

    //     Future.delayed(Duration(milliseconds: 1500), () {
    //       showSnackBar(snackbarContext, data['results'] ?? data['detail']);
    //       Navigator.of(context).popUntil((route) => route.isFirst);
    //     });
    //   } else {
    //     data = json.decode(response.body);
    //     showSnackBar(snackbarContext, data['results'] ?? data['detail']);
    //     print(response.body);
    //     print("Failed!! $data");
    //   }
    // } on SocketException catch (e) {
    //   apiFeedback("SocketException", e.message);
    // } on TimeoutException catch (e) {
    //   apiFeedback("TimeoutException", e.message);
    // } on FormatException catch (e) {
    //   if (e is FormatException) print(true);
    //   apiFeedback("FormatException", e.message);
    // } catch (e) {
    //   apiFeedback("Exception", "an unidentified error occured");
    // }

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SuccessPage()));
  }

  String specialisation, rank;
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
                      widget.isMedicalPractitioner
                          ? primaryDetails()
                          : SizedBox.shrink(),
                      secondaryDetails(),
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

  Widget primaryDetails() {
    return Column(children: [
      SizedBox(
        height: 20,
      ),
      DropDownField(
        hint: 'Field of specialisation',
        label: 'Specialisation',
        items: specialisations,
        value: specialisation,
        onChanged: (input) {
          specialisation = input;
        },
      ),
      SizedBox(
        height: 20,
      ),
      DropDownField(
        hint: 'Select rank',
        label: 'Rank',
        items: ranks,
        value: rank,
        onChanged: (input) {
          rank = input;
        },
      ),
      SizedBox(
        height: 20,
      ),
    ]);
  }

  Widget secondaryDetails() {
    return Column(children: <Widget>[
      InputField(
        hName,
        widget.isMedicalPractitioner ? 'Resident Hospital' : "Location",
        hint: widget.isMedicalPractitioner ? 'Name of resident hospital' : null,
      ),
      SizedBox(height: 20),
      InputField(
          sPin, widget.isMedicalPractitioner ? 'Service pin' : 'License number',
          hint: widget.isMedicalPractitioner
              ? 'Enter service pin'
              : 'Enter license number'),
      SizedBox(
        height: 50,
      ),
    ]);
  }

  Widget nextButton() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(bottom: 20),
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
}
