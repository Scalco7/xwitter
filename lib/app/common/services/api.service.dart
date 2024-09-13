import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:xwitter/app/common/controllers/user.controller.dart';

class ApiService {
  Future<Response> post(
      {required Uri uri, required Map<String, dynamic> jsonBody}) async {
    try {
      var body = json.encode(jsonBody);

      return http.post(uri, body: body, headers: _getHeaders());
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> get({required Uri uri}) async {
    return http.get(uri, headers: _getHeaders());
  }

  Map<String, String> _getHeaders() {
    String? loggedUserId =
        "66e0b681c0ca13c7c44740a0"; //UserController().loggedUser?.id;
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    if (loggedUserId != null) headers['loggeduserid'] = loggedUserId;

    return headers;
  }
}
