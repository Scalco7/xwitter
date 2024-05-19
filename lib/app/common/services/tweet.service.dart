import 'package:cloud_firestore/cloud_firestore.dart';
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
  final FirebaseFirestore database = FirebaseFirestore.instance;
  final IUserService userService = UserService();

  TweetService();

  Future<TweetModel?> getTweetFromMap({
    required Map<dynamic, dynamic> json,
    required String loggedUserId,
    bool withComments = false,
    UserModel? user,
  }) async {
    CollectionReference commentsRef =
        database.collection('tweets').doc(json["id"]).collection("comments");
    List<dynamic> jsonLikeList = json["likes"] as List<dynamic>;
    List<String> likes = jsonLikeList.map((e) => e as String).toList();

    if (user == null) {
      user = await userService.getUserById(id: json["userId"]);

      if (user == null) {
        return null;
      }
    }

    List<TweetModel> comments = [];
    late int commentsQuantity;

    if (withComments) {
      final QuerySnapshot commentSnapshot = await commentsRef.get();

      for (var docSnapshot in commentSnapshot.docs) {
        Map<String, dynamic> jsonData =
            docSnapshot.data() as Map<String, dynamic>;

        TweetModel? tweet =
            await getTweetFromMap(json: jsonData, loggedUserId: loggedUserId);

        if (tweet != null) {
          comments.add(tweet);
        }
      }

      commentsQuantity = comments.length;
    } else {
      AggregateQuerySnapshot aggregateSnapshot =
          await commentsRef.count().get();

      commentsQuantity = aggregateSnapshot.count!;
    }

    TweetModel tweet = TweetModel(
      id: json["id"],
      tweet: json["tweet"],
      user: user,
      likes: likes.length,
      liked: likes.contains(loggedUserId),
      comments: comments,
      commentsQuantity: commentsQuantity,
    );

    return tweet;
  }

  @override
  Future<bool> createTweet({
    required String userId,
    required String tweet,
    String? parentTweetId,
  }) async {
    final bool isComment = parentTweetId != null;
    late DocumentReference refTweet;
    if (isComment) {
      refTweet = database
          .collection("tweets")
          .doc(parentTweetId)
          .collection("comments")
          .doc();
    } else {
      refTweet = database.collection("tweets").doc();
    }
    String? id = refTweet.id;

    Map<String, dynamic> dataJson = {
      "id": id,
      "userId": userId,
      "tweet": tweet,
      "likes": [],
    };

    if (!isComment) {
      dataJson["comments"] = [];
    }

    await refTweet.set(dataJson);

    return true;
  }

  @override
  Future<TweetModel> likeTweet({
    required TweetModel tweet,
    required String loggedUserId,
    String? parentTweetId,
  }) async {
    final bool isComment = parentTweetId != null;
    late DocumentReference refTweet;
    if (isComment) {
      refTweet = database
          .collection("tweets")
          .doc(parentTweetId)
          .collection("comments")
          .doc(tweet.id);
    } else {
      refTweet = database.collection("tweets").doc(tweet.id);
    }

    await refTweet.update({
      "likes": FieldValue.arrayUnion([loggedUserId])
    });

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
    final bool isComment = parentTweetId != null;
    late DocumentReference refTweet;
    if (isComment) {
      refTweet = database
          .collection("tweets")
          .doc(parentTweetId)
          .collection("comments")
          .doc(tweet.id);
    } else {
      refTweet = database.collection("tweets").doc(tweet.id);
    }

    await refTweet.update({
      "likes": FieldValue.arrayRemove([loggedUserId])
    });

    tweet.liked = false;
    tweet.likes--;

    return tweet;
  }

  @override
  Future<List<TweetModel>> listTweets({required String loggedUserId}) async {
    final ref = database.collection('tweets').limit(20);
    final QuerySnapshot snapshot = await ref.get();

    List<TweetModel> tweetList = [];

    for (var docSnapshot in snapshot.docs) {
      Map<String, dynamic> jsonData =
          docSnapshot.data() as Map<String, dynamic>;

      TweetModel? tweet =
          await getTweetFromMap(json: jsonData, loggedUserId: loggedUserId);

      if (tweet != null) {
        tweetList.add(tweet);
      }
    }

    return tweetList;
  }

  @override
  Future<List<TweetModel>> listPostedTweets({
    required UserModel user,
    required String loggedUserId,
  }) async {
    final tweetRef = database.collection('tweets');
    final query = tweetRef.where("userId", isEqualTo: user.id);
    final QuerySnapshot snapshot = await query.get();

    List<TweetModel> tweetList = [];

    for (var docSnapshot in snapshot.docs) {
      Map<String, dynamic> jsonData =
          docSnapshot.data() as Map<String, dynamic>;

      TweetModel? tweet = await getTweetFromMap(
          json: jsonData, loggedUserId: loggedUserId, user: user);

      if (tweet != null) {
        tweetList.add(tweet);
      }
    }

    return tweetList;
  }

  @override
  Future<TweetModel> updateLoadedTweet(
      {required TweetModel tweet, required String loggedUserId}) async {
    final ref = database.collection('tweets').doc(tweet.id);
    final DocumentSnapshot snapshot = await ref.get();

    if (!snapshot.exists) {
      return tweet;
    }

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    TweetModel? newTweet = await getTweetFromMap(
      json: data,
      loggedUserId: loggedUserId,
      withComments: true,
    );

    if (newTweet == null) {
      return tweet;
    }

    return newTweet;
  }
}
