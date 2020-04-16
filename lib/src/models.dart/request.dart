import 'dart:convert';

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

List<PatientRequest> parseContent(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed
      .map<PatientRequest>((json) => PatientRequest.fromJson(json))
      .toList();
}

// class RequestResult {
//   final List<PatientRequest> patientRequest;
//   final String errorMessage;
// }
