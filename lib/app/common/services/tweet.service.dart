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

  Future<TweetModel> likeTweet({
    required TweetModel tweet,
    required String loggedUserId,
    String? parentTweetId,
  });

  Future<TweetModel> deslikeTweet({
    required TweetModel tweet,
    required String loggedUserId,
    String? parentTweetId,
  });

  Future<List<TweetModel>> listTweets({required String loggedUserId});

  Future<List<TweetModel>> listPostedTweets({
    required UserModel user,
    required String loggedUserId,
  });

  Future<TweetModel> updateLoadedTweet({
    required TweetModel tweet,
    required String loggedUserId,
  });
}

class TweetService implements ITweetService {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final IUserService userService = UserService();

  TweetService();

  Future<TweetModel?> getTweetFromMap({
    required Map<dynamic, dynamic> json,
    required String loggedUserId,
    UserModel? user,
  }) async {
    List<String> likes = [];

    if (json["likes"] != null) {
      Map likesMap = json["likes"] as Map;
      likes = likesMap.values
          .map(
            (e) => e as String,
          )
          .toList();
    }

    if (user == null) {
      user = await userService.getUserById(id: json["userId"]);

      if (user == null) {
        return null;
      }
    }

    List<TweetModel> comments = [];

    if (json['comments'] != null) {
      Map commentsMap = json['comments'] as Map;
      for (final value in commentsMap.values) {
        TweetModel? comment =
            await getTweetFromMap(json: value, loggedUserId: loggedUserId);
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
  Future<TweetModel> likeTweet({
    required TweetModel tweet,
    required String loggedUserId,
    String? parentTweetId,
  }) async {
    late DatabaseReference refTweet;
    if (parentTweetId != null) {
      refTweet = database
          .ref("tweets/$parentTweetId/comments/${tweet.id}/likes")
          .push();
    } else {
      refTweet = database.ref("tweets/${tweet.id}/likes").push();
    }

    await refTweet.set(loggedUserId);

    tweet.liked = true;
    tweet.likes++;

    return tweet;
  }

  @override
  Future<TweetModel> deslikeTweet({
    required TweetModel tweet,
    required String loggedUserId,
    String? parentTweetId,
  }) async {
    late DatabaseReference refTweet;

    if (parentTweetId != null) {
      refTweet = database.ref(
          "tweets/$parentTweetId/comments/${tweet.id}/likes/$loggedUserId");
    } else {
      refTweet = database.ref("tweets/${tweet.id}/likes/$loggedUserId");
    }

    await refTweet.remove();

    tweet.liked = false;
    tweet.likes--;

    return tweet;
  }

  @override
  Future<List<TweetModel>> listTweets({required String loggedUserId}) async {
    final ref = database.ref('tweets').limitToFirst(20);
    final snapshot = await ref.get();

    List<TweetModel> tweetList = [];

    if (snapshot.value != null) {
      Map dbValue = snapshot.value as Map;

      for (final value in dbValue.values) {
        TweetModel? tweet =
            await getTweetFromMap(json: value, loggedUserId: loggedUserId);
        if (tweet != null) {
          tweetList.add(tweet);
        }
      }
    }

    return tweetList;
  }

  @override
  Future<List<TweetModel>> listPostedTweets({
    required UserModel user,
    required String loggedUserId,
  }) async {
    final ref = database
        .ref('tweets')
        .orderByChild('userId')
        .equalTo(user.id)
        .limitToFirst(20);
    final snapshot = await ref.get();

    List<TweetModel> tweetList = [];

    if (snapshot.value != null) {
      Map dbValue = snapshot.value as Map;

      for (final value in dbValue.values) {
        TweetModel? tweet = await getTweetFromMap(
            json: value, loggedUserId: loggedUserId, user: user);
        if (tweet != null) {
          tweetList.add(tweet);
        }
      }
    }

    return tweetList;
  }

  @override
  Future<TweetModel> updateLoadedTweet(
      {required TweetModel tweet, required String loggedUserId}) async {
    final ref = database.ref('tweets/${tweet.id}').limitToFirst(20);
    final snapshot = await ref.get();

    if (snapshot.value == null) {
      return tweet;
    }

    Map dbValue = snapshot.value as Map;
    TweetModel? newTweet =
        await getTweetFromMap(json: dbValue, loggedUserId: loggedUserId);

    if (newTweet == null) {
      return tweet;
    }
    return newTweet;
  }
}
