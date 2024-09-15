import 'dart:convert';

import 'package:xwitter/app/common/consts/api.consts.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/common/services/api.service.dart';

abstract class IUserService {
  Future<UserModel> createUser({
    required String name,
    required String email,
    required String nickname,
    required String password,
  });

  Future<UserModel> userLogin({
    required String email,
    required String password,
  });

  Future<UserModel?> getUserById({
    required String userId,
  });

  Future<UserModel?> updateUser({
    required UserModel user,
    required String name,
    required String bio,
    required String? photoBase64,
  });

  Future<List<UserModel>> listUsersByText({required String text});

  Future<UserModel> followUser({
    required UserModel user,
  });

  Future<UserModel> unfollowUser({
    required UserModel user,
  });

  Future<bool> saveTweet({required String tweetId});

  Future<bool> unsaveTweet({required String tweetId});
}

class UserService implements IUserService {
  static final UserService _singleton = UserService._internal();

  factory UserService() {
    return _singleton;
  }

  UserService._internal();

  String get getApiUrl => "${ApiConsts.apiUrl}/user";

  @override
  Future<UserModel> createUser({
    required String name,
    required String email,
    required String nickname,
    required String password,
  }) async {
    final url = "$getApiUrl/create";
    Map<String, dynamic> jsonRequest = {
      "name": name,
      "email": email,
      "username": nickname,
      "password": password
    };

    try {
      final response =
          await ApiService().post(uri: Uri.parse(url), jsonBody: jsonRequest);
      var data = jsonDecode(response.body.toString());

      if (response.statusCode != 200) {
        throw Exception(response);
      }

      UserModel newUser = UserModel.fromJson(data);

      return newUser;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> userLogin({
    required String email,
    required String password,
  }) async {
    final url = "$getApiUrl/login";
    Map<String, dynamic> jsonRequest = {"email": email, "password": password};

    try {
      final response =
          await ApiService().post(uri: Uri.parse(url), jsonBody: jsonRequest);
      var data = jsonDecode(response.body.toString());

      if (response.statusCode != 200) {
        throw Exception("Erro na api");
      }

      UserModel loggedUser = UserModel.fromJson(data);

      return loggedUser;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel?> getUserById({
    required String userId,
  }) async {
    Uri uri = Uri.parse("$getApiUrl/$userId");

    try {
      final response = await ApiService().get(uri: uri);
      var data = jsonDecode(response.body.toString());

      if (response.statusCode != 200) {
        return null;
      }

      UserModel user = UserModel.fromJson(data);

      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel?> updateUser({
    required UserModel user,
    required String name,
    required String bio,
    required String? photoBase64,
  }) async {
    final url = "$getApiUrl/update";
    Map<String, dynamic> jsonRequest = {
      "id": user.id,
      "name": name,
      "bio": bio,
      "photoBase64": photoBase64
    };

    final response =
        await ApiService().post(uri: Uri.parse(url), jsonBody: jsonRequest);
    var data = jsonDecode(response.body.toString());

    if (response.statusCode != 200) {
      throw Exception("Erro na api");
    }

    UserModel newUser = UserModel.fromJson(data);

    return newUser;
  }

  @override
  Future<List<UserModel>> listUsersByText({required String text}) async {
    return [];
  }

  @override
  Future<UserModel> followUser({
    required UserModel user,
  }) async {
    final url = "$getApiUrl/follow";
    Map<String, dynamic> jsonRequest = {
      "followingId": user.id,
    };

    final response =
        await ApiService().post(uri: Uri.parse(url), jsonBody: jsonRequest);

    if (response.statusCode != 200) {
      throw Exception("Erro na api");
    }

    user.numberOfFollowers++;
    user.following = true;

    return user;
  }

  @override
  Future<UserModel> unfollowUser({
    required UserModel user,
  }) async {
    final url = "$getApiUrl/unfollow";
    Map<String, dynamic> jsonRequest = {
      "followingId": user.id,
    };

    final response =
        await ApiService().post(uri: Uri.parse(url), jsonBody: jsonRequest);

    if (response.statusCode != 200) {
      throw Exception("Erro na api");
    }

    user.numberOfFollowers--;
    user.following = false;

    return user;
  }

  @override
  Future<bool> saveTweet({required String tweetId}) async {
    final url = "$getApiUrl/savetweet";
    Map<String, dynamic> jsonRequest = {
      "tweetId": tweetId,
    };

    try {
      final response =
          await ApiService().post(uri: Uri.parse(url), jsonBody: jsonRequest);

      if (response.statusCode != 200) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> unsaveTweet({required String tweetId}) async {
    final url = "$getApiUrl/savetweet/remove";
    Map<String, dynamic> jsonRequest = {
      "tweetId": tweetId,
    };

    try {
      final response =
          await ApiService().post(uri: Uri.parse(url), jsonBody: jsonRequest);

      if (response.statusCode != 200) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
