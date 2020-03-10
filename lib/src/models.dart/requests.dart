import 'dart:io';

import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart';

class PatientRequest {
  final int id;
  final String title;

  PatientRequest({
    this.id,
    this.title,
  });

  factory PatientRequest.fromJson(Map<String, dynamic> json) {
    return PatientRequest(
      id: json['id'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }
}

Future<dynamic> fetchPatientRequest(String token) async {
  // final response =
  // await get('http://medsaid.herokuapp.com/api/provider/requests/', head  ers: {});
  String url = 'http://medsaid.herokuapp.com/api/provider/requests/';
  Map jsonMap = {
    "token": token,
  };
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
  request.headers.set('token', token);
  request.add(utf8.encode(json.encode(jsonMap)));
  HttpClientResponse response = await request.close();

  String reply = await response.transform(utf8.decoder).join();

  print(reply);
  return reply;

  // return compute(parseContent, response.body);
}

List<PatientRequest> parseContent(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed
      .map<PatientRequest>((json) => PatientRequest.fromJson(json))
      .toList();
}
