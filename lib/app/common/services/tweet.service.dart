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

  Future<List<TweetModel>> listTweets({required String userId});

  Future<TweetModel> getTweetWithComments({
    required TweetModel tweet,
    required String userId,
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
  Future<List<TweetModel>> listTweets({required String userId}) async {
    final ref = database.ref('tweets').limitToFirst(20);
    final snapshot = await ref.get();

    Map dbValue = snapshot.value as Map;
    List<TweetModel> tweetList = [];

    for (final value in dbValue.values) {
      List<String> likes = value?["likes"] ?? [];
      UserModel? user = await userService.getUserById(id: value["userId"]);
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

  @override
  Future<TweetModel> getTweetWithComments(
      {required TweetModel tweet, required String userId}) async {
    final ref = database.ref('tweets/${tweet.id}/comments').limitToFirst(20);
    final snapshot = await ref.get();

    Map dbValue = snapshot.value as Map;
    List<TweetModel> comments = [];

    for (final value in dbValue.values) {
      List<String> likes = value?["likes"] ?? [];
      UserModel? user = await userService.getUserById(id: value["userId"]);
      if (user != null) {
        TweetModel tweet = TweetModel(
          id: value["id"],
          tweet: value["tweet"],
          user: user,
          likes: likes.length,
          liked: likes.contains(userId),
        );
        comments.add(tweet);
      }
    }

    tweet.comments = comments;
    return tweet;
  }
}
