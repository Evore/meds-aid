import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:io';

import 'package:meds_aid/src/ui/widgets/dialogs.dart';

class PatientRequest {
  final int id;
  final String statement,
      requestId,
      imageUrl,
      speciality,
      description,
      providerName,
      requestedAt,
      status;

  PatientRequest(
      {this.id,
      this.statement,
      this.requestId,
      this.imageUrl,
      this.speciality,
      this.description,
      this.providerName,
      this.status,
      this.requestedAt});

  factory PatientRequest.fromJson(Map<String, dynamic> json) {
    return PatientRequest(
        id: json['id'],
        statement: json['statement'],
        requestId: json['request_id'],
        imageUrl: json['request_by_profile'],
        speciality: json['provider_speciality'],
        description: json['description'],
        providerName: json['provider_name'],
        status: json['status'],
        requestedAt: json['requested_at']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'statement': statement,
    };
  }
}

// Returns a Future<List<PatientRequest>> object unless, an arror occurs, where it returns the error string
fetchRequest(String token, BuildContext context) async {
  try {
    final response = await get(
      'http://medsaid.herokuapp.com/api/provider/requests/',
      headers: {"Authorization": "JWT $token"},
    );
    final body = json.decode(response.body);

    print(body is String);

    bool typeCheck = body is String;

    final result =
        typeCheck ? (body['detail']) : compute(parseContent, response.body);

    return result;
  } on SocketException catch (e) {
    print(e.message);
    showSnackBar(context, e.message);
    return e.message;
  } on TimeoutException catch (e) {
    print(e.message);
    showSnackBar(context, e.message);
  } on FormatException catch (e) {
    print(e.message);
    showSnackBar(context, e.message);
  }
}

List<PatientRequest> parseContent(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed
      .map<PatientRequest>((json) => PatientRequest.fromJson(json))
      .toList();
}
