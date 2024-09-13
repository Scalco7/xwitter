import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
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
    required String photoBase64,
  });

  Future<List<UserModel>> listUsersByText({required String text});

  Future<UserModel> followUser({
    required UserModel user,
  });

  Future<UserModel> unfollowUser({
    required UserModel user,
  });
}

class UserService implements IUserService {
  static final UserService _singleton = UserService._internal();
  final FirebaseFirestore database = FirebaseFirestore.instance;

  factory UserService() {
    return _singleton;
  }

  UserService._internal();

  Future<UserModel> getUserFromMap({
    required Map<String, dynamic> data,
    String? loggedUserId,
  }) async {
    List<dynamic> jsonFollowList = data["followList"] as List<dynamic>;
    List<String> followingsList =
        jsonFollowList.map((e) => e as String).toList();
    int numberOfFollowings = followingsList.length;

    String userId = data["id"];

    final followersQuery = database
        .collection('users')
        .where("id", isNotEqualTo: userId)
        .where("followList", arrayContains: userId);
    AggregateQuerySnapshot followersSnapshot =
        await followersQuery.count().get();

    AggregateQuerySnapshot? followSnapshot;
    if (loggedUserId != null) {
      final followQuery = database
          .collection('users')
          .where("id", isEqualTo: loggedUserId)
          .where("followList", arrayContains: userId);

      followSnapshot = await followQuery.count().get();
    }

    return UserModel(
      id: userId,
      name: data['name'],
      email: data['email'],
      username: data['nickname'],
      avatarPath: data['avatarPath'],
      bio: data['bio'],
      numberOfFollowers: followersSnapshot.count!,
      numberOfFollowings: numberOfFollowings,
      following:
          followSnapshot == null ? false : (followSnapshot.count ?? 0) > 0,
    );
  }

  @override
  Future<UserModel> createUser({
    required String name,
    required String email,
    required String nickname,
    required String password,
  }) async {
    const url = "${ApiConsts.apiUrl}/user/create";
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
    const url = "${ApiConsts.apiUrl}/user/login";
    Map<String, dynamic> jsonRequest = {"email": email, "password": password};

    try {
      final response =
          await ApiService().post(uri: Uri.parse(url), jsonBody: jsonRequest);
      var data = jsonDecode(response.body.toString());

      if (response.statusCode != 200) {
        throw Error();
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
    Uri uri = Uri.parse("${ApiConsts.apiUrl}/user/$userId");

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
    required String photoBase64,
  }) async {
    const url = "${ApiConsts.apiUrl}/user/update";
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
      throw Error();
    }

    UserModel newUser = UserModel.fromJson(data);

    return newUser;
  }

  @override
  Future<List<UserModel>> listUsersByText({required String text}) async {
    final usersRef = database.collection('users');
    final query = usersRef.where(Filter.or(
      Filter("name", isEqualTo: text),
      Filter("nickname", isEqualTo: text),
    ));
    final QuerySnapshot snapshot = await query.get();

    List<UserModel> userList = [];

    for (var docSnapshot in snapshot.docs) {
      Map<String, dynamic> jsonData =
          docSnapshot.data() as Map<String, dynamic>;

      UserModel user = await getUserFromMap(data: jsonData);
      userList.add(user);
    }

    return userList;
  }

  @override
  Future<UserModel> followUser({
    required UserModel user,
  }) async {
    const url = "${ApiConsts.apiUrl}/user/follow";
    Map<String, dynamic> jsonRequest = {
      "followingId": user.id,
    };

    final response =
        await ApiService().post(uri: Uri.parse(url), jsonBody: jsonRequest);

    if (response.statusCode != 200) {
      throw Error();
    }

    user.numberOfFollowers++;
    user.following = true;

    return user;
  }

  @override
  Future<UserModel> unfollowUser({
    required UserModel user,
  }) async {
    const url = "${ApiConsts.apiUrl}/user/unfollow";
    Map<String, dynamic> jsonRequest = {
      "followingId": user.id,
    };

    final response =
        await ApiService().post(uri: Uri.parse(url), jsonBody: jsonRequest);

    if (response.statusCode != 200) {
      throw Error();
    }

    user.numberOfFollowers--;
    user.following = false;

    return user;
  }
}
