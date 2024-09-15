import 'dart:convert';

import 'package:xwitter/app/common/consts/api.consts.dart';
import 'package:xwitter/app/common/services/api.service.dart';

abstract class ILocationService {
  Future<List<String>> listLocations({required String searchText});
}

class LocationService implements ILocationService {
  static final LocationService _singleton = LocationService._internal();

  factory LocationService() {
    return _singleton;
  }

  LocationService._internal();

  String get getApiUrl => "${ApiConsts.apiUrl}/listLocations";

  @override
  Future<List<String>> listLocations({required String searchText}) async {
    Uri uri = Uri.parse("$getApiUrl/");

    Map<String, dynamic> jsonRequest = {
      "cityName": searchText,
    };

    try {
      final response = await ApiService().post(uri: uri, jsonBody: jsonRequest);

      if (response.statusCode != 200) {
        throw Exception("Erro ao buscar tweets");
      }

      List<String> locations =
          (jsonDecode(response.body) as List<dynamic>).cast<String>();

      return locations;
    } catch (e) {
      rethrow;
    }
  }
}
