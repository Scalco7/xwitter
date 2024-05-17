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

  Future<TweetModel> getTweetWithComments({
    required TweetModel tweet,
    required String loggedUserId,
  });
}

class TweetService implements ITweetService {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final IUserService userService = UserService();

  TweetService();
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
        List<String> likes = value?["likes"] ?? [];
        UserModel? user = await userService.getUserById(id: value["userId"]);
        if (user != null) {
          TweetModel tweet = TweetModel(
            id: value["id"],
            tweet: value["tweet"],
            user: user,
            likes: likes.length,
            liked: likes.contains(loggedUserId),
          );
          tweetList.add(tweet);
        }
      }
    }

    return tweetList;
  }

  @override
  Future<TweetModel> getTweetWithComments(
      {required TweetModel tweet, required String loggedUserId}) async {
    final ref = database.ref('tweets/${tweet.id}/comments').limitToFirst(20);
    final snapshot = await ref.get();
    List<TweetModel> comments = [];

    if (snapshot.value != null) {
      Map dbValue = snapshot.value as Map;

      for (final value in dbValue.values) {
        List<String> likes = value?["likes"] ?? [];
        UserModel? user = await userService.getUserById(id: value["userId"]);
        if (user != null) {
          TweetModel tweet = TweetModel(
            id: value["id"],
            tweet: value["tweet"],
            user: user,
            likes: likes.length,
            liked: likes.contains(loggedUserId),
          );
          comments.add(tweet);
        }
      }
    }

    tweet.comments = comments;
    return tweet;
  }
}
