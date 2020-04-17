import 'dart:convert';

class PatientRequest {
  final int id, provider;
  final String statement,
      requestId,
      imageUrl,
      speciality,
      description,
      providerName,
      providerImg,
      providerHospital,
      requestByProfile,
      createdBy,
      createdAt,
      requestedAt,
      newId,
      status;
  bool isRequested;

  PatientRequest({
    this.id,
    this.statement,
    this.requestId,
    this.imageUrl,
    this.speciality,
    this.description,
    this.providerName,
    this.status,
    this.requestedAt,
    this.providerImg,
    this.providerHospital,
    this.requestByProfile,
    this.createdBy,
    this.createdAt,
    this.provider,
    this.newId,
    this.isRequested,
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
      requestedAt: json['requested_at'],
      providerImg: json['provider_image'],
      providerHospital: json['provider_hospital'],
      requestByProfile: json['request_by_profile'],
      createdBy: json['created_by'],
      createdAt: json['created_at'],
      provider: json['provider'],
      newId: json['new_id'],
      isRequested: json['is_requested'],
    );
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
