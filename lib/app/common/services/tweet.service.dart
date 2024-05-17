import 'package:firebase_database/firebase_database.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/common/services/user.service.dart';

abstract class ITweetService {
  Future<bool> createTweet({
    required String userId,
    required String tweet,
    String? parentTweetId,
  });

  Future<List<TweetModel>> listTweets({required String loggedUserId});

  Future<TweetModel> updateTweet({
    required TweetModel tweet,
    required String loggedUserId,
  });
}

class TweetService implements ITweetService {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final IUserService userService = UserService();

  TweetService();

  Future<TweetModel?> getTweetFromMap(
    Map<dynamic, dynamic> json,
    String loggedUserId,
  ) async {
    List<String> likes = json["likes"] ?? [];
    UserModel? user = await userService.getUserById(id: json["userId"]);
    if (user == null) {
      return null;
    }

    List<TweetModel> comments = [];

    if (json['comments'] != null) {
      Map commentsMap = json['comments'] as Map;
      print(commentsMap);
      for (final value in commentsMap.values) {
        TweetModel? comment = await getTweetFromMap(value, loggedUserId);
        if (comment != null) {
          comments.add(comment);
        }
      }
    }

    TweetModel tweet = TweetModel(
      id: json["id"],
      tweet: json["tweet"],
      user: user,
      likes: likes.length,
      liked: likes.contains(loggedUserId),
      comments: comments,
    );

    return tweet;
  }

  @override
  Future<bool> createTweet({
    required String userId,
    required String tweet,
    String? parentTweetId,
  }) async {
    late DatabaseReference refTweet;
    if (parentTweetId != null) {
      refTweet = database.ref("tweets/$parentTweetId/comments").push();
    } else {
      refTweet = database.ref("tweets").push();
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
  Future<List<TweetModel>> listTweets({required String loggedUserId}) async {
    final ref = database.ref('tweets').limitToFirst(20);
    final snapshot = await ref.get();

    List<TweetModel> tweetList = [];

    if (snapshot.value != null) {
      Map dbValue = snapshot.value as Map;

      for (final value in dbValue.values) {
        TweetModel? tweet = await getTweetFromMap(value, loggedUserId);
        if (tweet != null) {
          tweetList.add(tweet);
        }
      }
    }

    return tweetList;
  }

  @override
  Future<TweetModel> updateTweet(
      {required TweetModel tweet, required String loggedUserId}) async {
    final ref = database.ref('tweets/${tweet.id}').limitToFirst(20);
    final snapshot = await ref.get();

    if (snapshot.value == null) {
      return tweet;
    }

    Map dbValue = snapshot.value as Map;
    TweetModel? newTweet = await getTweetFromMap(dbValue, loggedUserId);

    if (newTweet == null) {
      return tweet;
    }
    return newTweet;
  }
}
