import 'package:flutter/material.dart';
import 'package:meds_aid/src/auth/signIn.dart';
import 'package:meds_aid/src/models.dart/request.dart';
import 'package:meds_aid/src/providers/request_provider.dart';
import 'package:meds_aid/src/ui/widgets/dialogs.dart';
import 'package:meds_aid/src/ui/widgets/request_widget.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  RequestProvider provider;
  List<PatientRequest> requests = [];
  bool doneLoading;
  String error;
  BuildContext snackbarContext;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = Provider.of<RequestProvider>(context);
    requests = provider.getAcceptedRequests();
    doneLoading = provider.doneWithFetch;
    errorListener();
  }

  errorListener() {
    error = provider.errorMessage;
    if (error.isNotEmpty && snackbarContext != null) {
      showSnackBar(snackbarContext, error);
      if (error.contains('expired'))
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignIn(),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDFDFD),
      body: Builder(
        builder: (BuildContext context) {
          snackbarContext = context;
          return SafeArea(
            child: doneLoading
                ? body()
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          );
        },
      ),
    );
  }

  Widget body() {
    return error.isEmpty
        ? ListView(
            shrinkWrap: true,
            children: <Widget>[acceptedRequests()],
          )
        : Center(
            child: IconButton(
              padding: EdgeInsets.all(0),
              icon: Icon(Icons.replay),
              onPressed: () {
                provider.refreshRequests();
              },
            ),
          );
  }

  Widget acceptedRequests() {
    var acceptedRequests = provider.getAcceptedRequests();
    return Column(
      children: acceptedRequests
          .map((request) => RequestItem(
                request: request,
              ))
          .toList(),
    );
  }
}
