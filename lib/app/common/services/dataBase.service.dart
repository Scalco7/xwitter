import 'package:firebase_database/firebase_database.dart';
import 'package:xwitter/app/common/models/user.model.dart';

class DataBaseService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future<UserModel> createUser({
    required String id,
    required String name,
    required String email,
    required String nickname,
  }) async {
    DatabaseReference ref = _database.ref("users/$id");

    await ref.set({
      "id": id,
      "name": name,
      "email": email,
      "nickname": nickname,
      "avatarPath": "assets/avatars/man_1.png",
      "bio": "",
      "numberOfFollowers": 0,
      "numberOfFollowings": 0,
    });

    UserModel newUser = UserModel(
      id: id,
      name: name,
      email: email,
      nickname: nickname,
      avatarPath: "assets/avatars/man_1.png",
      bio: "",
      numberOfFollowers: 0,
      numberOfFollowings: 0,
    );
    return newUser;
  }

  Future<UserModel?> getUser({required String id}) async {
    final ref = _database.ref('users/$id');
    final snapshot = await ref.get();
    if (snapshot.exists) {
      Map dbValue = snapshot.value as Map;

      UserModel user = UserModel(
        id: dbValue['id'],
        name: dbValue['name'],
        email: dbValue['email'],
        nickname: dbValue['nickname'],
        avatarPath: dbValue['avatarPath'],
        bio: dbValue['bio'],
        numberOfFollowers: dbValue['numberOfFollowers'],
        numberOfFollowings: dbValue['numberOfFollowings'],
      );

      return user;
    } else {
      return null;
    }
  }

  Future<UserModel?> updateUser({
    required String id,
    required String name,
    required String bio,
    required String avatarPath,
  }) async {
    DatabaseReference ref = _database.ref("users/$id");

    final snapshot = await ref.get();
    if (snapshot.exists) {
      Map dbValue = snapshot.value as Map;

      UserModel user = UserModel(
        id: dbValue['id'],
        name: name,
        email: dbValue['email'],
        nickname: dbValue['nickname'],
        avatarPath: avatarPath,
        bio: bio,
        numberOfFollowers: dbValue['numberOfFollowers'],
        numberOfFollowings: dbValue['numberOfFollowings'],
      );

      await ref.update({
        "name": name,
        "avatarPath": avatarPath,
        "bio": bio,
      });

      return user;
    } else {
      return null;
    }
  }
}
