import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:xwitter/app/common/controllers/user.controller.dart';

class ApiService {
  Future<Response> post(
      {required String url, required Map<String, dynamic> jsonBody}) async {
    var body = json.encode(jsonBody);

    return http.post(Uri.parse(url), body: body, headers: _getHeaders());
  }

  Future<Response> get({required String url}) async {
    return http.get(Uri.parse(url), headers: _getHeaders());
  }

  Map<String, String> _getHeaders() {
    String? loggedUserId = UserController().loggedUser?.id;
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    if (loggedUserId != null) headers['loggeduserid'] = loggedUserId;

    return headers;
  }
}
