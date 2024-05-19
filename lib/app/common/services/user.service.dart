import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xwitter/app/common/models/user.model.dart';

abstract class IUserService {
  Future<UserModel> createUser({
    required String id,
    required String name,
    required String email,
    required String nickname,
  });

  Future<UserModel?> getUserById({required String id});

  Future<String?> getUserIdByEmail({required String email});

  Future<String?> getUserIdByNickname({required String nickname});

  Future<UserModel?> updateUser({
    required UserModel user,
    required String name,
    required String bio,
    required String avatarPath,
  });

  Future<List<UserModel>> listUsersByText({required String text});
}

class UserService implements IUserService {
  final FirebaseFirestore database = FirebaseFirestore.instance;
  UserService();

  UserModel getUserFromMap(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      nickname: data['nickname'],
      avatarPath: data['avatarPath'],
      bio: data['bio'],
      numberOfFollowers: data['numberOfFollowers'],
      numberOfFollowings: data['numberOfFollowings'],
    );
  }

  @override
  Future<UserModel> createUser({
    required String id,
    required String name,
    required String email,
    required String nickname,
  }) async {
    Map<String, dynamic> userJson = {
      "id": id,
      "name": name,
      "email": email,
      "nickname": nickname,
      "avatarPath": "assets/avatars/man_1.png",
      "bio": "",
      "numberOfFollowers": 0,
      "numberOfFollowings": 0,
    };

    await database.collection("users").doc(id).set(userJson);

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

  @override
  Future<UserModel?> getUserById({required String id}) async {
    final docRef = database.collection('users').doc(id);
    final DocumentSnapshot snapshot = await docRef.get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      UserModel user = getUserFromMap(data);

      return user;
    } else {
      return null;
    }
  }

  @override
  Future<String?> getUserIdByEmail({required String email}) async {
    final usersRef = database.collection('users');
    final query = usersRef.where('email', isEqualTo: email);
    late QuerySnapshot snapshot;

    try {
      snapshot = await query.get();
    } catch (error) {
      return null;
    }

    if (snapshot.docs.firstOrNull == null) {
      return null;
    }

    final data = snapshot.docs.firstOrNull;
    String? id = data!.id;

    return id;
  }

  @override
  Future<String?> getUserIdByNickname({required String nickname}) async {
    final usersRef = database.collection('users');
    final query = usersRef.where('nickname', isEqualTo: nickname);
    late QuerySnapshot snapshot;

    try {
      snapshot = await query.get();
    } catch (error) {
      return null;
    }

    if (snapshot.docs.firstOrNull == null) {
      return null;
    }

    final data = snapshot.docs.firstOrNull;
    String? id = data!.id;

    return id;
  }

  @override
  Future<UserModel?> updateUser({
    required UserModel user,
    required String name,
    required String bio,
    required String avatarPath,
  }) async {
    final ref = database.collection("users").doc(user.id);

    Map<String, dynamic> updatesJson = {
      "name": name,
      "avatarPath": avatarPath,
      "bio": bio,
    };

    try {
      await ref.update(updatesJson);
    } catch (error) {
      return null;
    }

    user.name = name;
    user.bio = bio;
    user.avatarPath = avatarPath;

    return user;
  }

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

      UserModel user = getUserFromMap(jsonData);
      userList.add(user);
    }

    return userList;
  }
}
