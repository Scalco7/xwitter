import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xwitter/app/common/models/user.model.dart';

abstract class IUserService {
  Future<UserModel> createUser({
    required String id,
    required String name,
    required String email,
    required String nickname,
  });

  Future<UserModel?> getUserById({
    required String id,
    String? loggedUserId,
  });

  Future<String?> getUserIdByEmail({required String email});

  Future<String?> getUserIdByNickname({required String nickname});

  Future<UserModel?> updateUser({
    required UserModel user,
    required String name,
    required String bio,
    required String avatarPath,
  });

  Future<List<UserModel>> listUsersByText({required String text});

  Future<UserModel> followUser({
    required UserModel user,
    required String loggedUserId,
  });

  Future<UserModel> unfollowUser({
    required UserModel user,
    required String loggedUserId,
  });
}

class UserService implements IUserService {
  final FirebaseFirestore database = FirebaseFirestore.instance;
  UserService();

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
      nickname: data['nickname'],
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
      "followList": [],
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
      following: false,
    );
    return newUser;
  }

  @override
  Future<UserModel?> getUserById({
    required String id,
    String? loggedUserId,
  }) async {
    final docRef = database.collection('users').doc(id);
    final DocumentSnapshot snapshot = await docRef.get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      UserModel user =
          await getUserFromMap(data: data, loggedUserId: loggedUserId);

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
    required String loggedUserId,
  }) async {
    DocumentReference refUser = database.collection("users").doc(loggedUserId);

    await refUser.update({
      "followList": FieldValue.arrayUnion([user.id])
    });

    user.numberOfFollowers++;
    user.following = true;

    return user;
  }

  @override
  Future<UserModel> unfollowUser({
    required UserModel user,
    required String loggedUserId,
  }) async {
    DocumentReference refUser = database.collection("users").doc(loggedUserId);

    await refUser.update({
      "followList": FieldValue.arrayRemove([user.id])
    });

    user.numberOfFollowers--;
    user.following = false;

    return user;
  }
}
