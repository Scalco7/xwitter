import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<Response> post(
      {required String url, required Map<String, dynamic> jsonBody}) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    var body = json.encode(jsonBody);

    return http.post(Uri.parse(url), body: body, headers: headers);
  }

  Future<Response> get({required String url}) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    return http.get(Uri.parse(url), headers: headers);
  }
}
