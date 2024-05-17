import 'package:firebase_database/firebase_database.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/models/user.model.dart';

abstract class IDataBaseService {
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
    required String id,
    required String name,
    required String bio,
    required String avatarPath,
  });

  Future<bool> createTweet({
    required String userId,
    required String tweet,
    String? tweetId,
  });

  Future<List<TweetModel>> listTweets({required String userId});
}

class DataBaseService implements IDataBaseService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  DataBaseService();

  @override
  Future<UserModel> createUser({
    required String id,
    required String name,
    required String email,
    required String nickname,
  }) async {
    DatabaseReference refUser = _database.ref("users/$id");

    await refUser.set({
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

  @override
  Future<UserModel?> getUserById({required String id}) async {
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

  @override
  Future<String?> getUserIdByEmail({required String email}) async {
    final ref = _database.ref('users').orderByChild("email").equalTo(email);
    final snapshot = await ref.get();

    if (snapshot.exists) {
      Map dbValue = snapshot.value as Map;
      String? id = dbValue.keys.firstOrNull;

      return id;
    } else {
      return null;
    }
  }

  @override
  Future<String?> getUserIdByNickname({required String nickname}) async {
    final ref =
        _database.ref('users').orderByChild("nickname").equalTo(nickname);
    final snapshot = await ref.get();

    if (snapshot.exists) {
      Map dbValue = snapshot.value as Map;
      String? id = dbValue.keys.firstOrNull;

      return id;
    } else {
      return null;
    }
  }

  @override
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

  @override
  Future<bool> createTweet({
    required String userId,
    required String tweet,
    String? tweetId,
  }) async {
    late DatabaseReference refTweet;
    if (tweetId != null) {
      refTweet = _database.ref("tweets/$tweetId/comments").push();
    } else {
      refTweet = _database.ref("tweets").push();
    }
    String? id = refTweet.key;

    await refTweet.set({
      "id": id,
      "userId": userId,
      "tweet": tweet,
      "likes": [],
      "comments": [],
    });

    return true;
  }

  @override
  Future<List<TweetModel>> listTweets({required String userId}) async {
    final ref = _database.ref('tweets').limitToFirst(20);
    final snapshot = await ref.get();

    Map dbValue = snapshot.value as Map;
    List<TweetModel> tweetList = [];

    for (final value in dbValue.values) {
      List<String> likes = value?["likes"] ?? [];
      UserModel? user = await getUserById(id: value["userId"]);
      if (user != null) {
        TweetModel tweet = TweetModel(
          id: value["id"],
          tweet: value["tweet"],
          user: user,
          likes: likes.length,
          liked: likes.contains(userId),
        );
        tweetList.add(tweet);
      }
    }

    return tweetList;
  }
}
