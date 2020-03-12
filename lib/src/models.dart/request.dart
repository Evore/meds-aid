import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart';

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

  PatientRequest({
    this.id,
    this.statement,
    this.requestId,
    this.imageUrl,
    this.speciality,
    this.description,
    this.providerName,
    this.status,
    this.requestedAt
  });

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
        requestedAt: json['requested_at'] );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'statement': statement,
    };
  }
}

Future<List<PatientRequest>> fetchRequest(String token) async {
  final response = await get(
    'http://medsaid.herokuapp.com/api/provider/requests/',
    headers: {"Authorization": "JWT $token"},
  );
  print(response.body);
  final result = compute(parseContent, response.body);
  return result;
}

List<PatientRequest> parseContent(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed
      .map<PatientRequest>((json) => PatientRequest.fromJson(json))
      .toList();
}
