import 'package:flutter/foundation.dart';
import 'package:meds_aid/src/models.dart/request.dart';
import 'package:meds_aid/src/providers/request_dao.dart';

class RequestProvider extends ChangeNotifier {
  final RequestDao dao;

  bool doneWithFetch = false;
  List<PatientRequest> _requests = [];
  String errorMessage = '';

  RequestProvider(this.dao) {
    if (dao != null) {
      _init();
    }
  }
  List<PatientRequest> get requests {
    return _requests;
  }

  void _init() {
    _requests = dao.requests;
    errorMessage = dao.errorMessage;
    doneWithFetch = dao.finishedFetch;
    print("RequestProvider doneWithFetch() :  $doneWithFetch");
    notifyListeners();
  }

  Future refreshRequests() async {
    errorMessage = '';
    doneWithFetch = false;
    notifyListeners();
    await dao.refresh();
  }

  List<PatientRequest> getAcceptedRequests() {
    List<PatientRequest> requests = _requests.where((PatientRequest request) {
      return request.status.toLowerCase() == 'accepted';
    }).toList();

    return requests;
  }
}
