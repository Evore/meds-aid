import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart';

class Specialty {
  // final int userId;
  final int id;
  final String title;
  // final String body;

  Specialty({
    this.id,
    this.title,
  });

  factory Specialty.fromJson(Map<String, dynamic> json) {
    return Specialty(
      // userId: json['userId'],
      id: json['id'],
      title: json['title'],
      // body: json['body'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }
}

Future<List<Specialty>> fetchSpecialty() async {
  final response =
      await get('http://medsaid.herokuapp.com/api/request/specialities/');

  return compute(parseContent, response.body);
}

List<Specialty> parseContent(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Specialty>((json) => Specialty.fromJson(json)).toList();
}
