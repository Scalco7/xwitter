import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xwitter/app/common/consts/api.consts.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/common/services/api.service.dart';
import 'package:xwitter/app/common/services/user.service.dart';

abstract class ITweetService {
  Future<TweetModel> createTweet({
    required String text,
  });

  Future<TweetModel> likeTweet({required TweetModel tweet});

  Future<TweetModel> deslikeTweet({required TweetModel tweet});

  Future<List<TweetModel>> listTweets();

  Future<List<TweetModel>> listPostedTweets({
    required UserModel user,
    required String loggedUserId,
  });

  Future<List<TweetModel>> listLikedTweets({
    required UserModel user,
    required String loggedUserId,
  });

  Future<TweetModel> updateLoadedTweet({
    required TweetModel tweet,
    required String loggedUserId,
  });
}

class TweetService implements ITweetService {
  static final TweetService _singleton = TweetService._internal();

  final FirebaseFirestore database = FirebaseFirestore.instance;
  final IUserService userService = UserService();

  factory TweetService() {
    return _singleton;
  }

  TweetService._internal();

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
      user = await userService.getUserById(userId: json["userId"]);

      if (user == null) {
        return null;
      }
    }

    List<TweetModel> comments = [];
    late int commentsQuantity;

    if (withComments) {
      final QuerySnapshot commentSnapshot =
          await commentsRef.orderBy("date", descending: true).get();

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

      commentsQuantity = aggregateSnapshot.count ?? 0;
    }

    TweetModel tweet = TweetModel(
      id: json["id"],
      text: json["tweet"],
      user: user,
      likes: likes.length,
      liked: likes.contains(loggedUserId),
      comments: comments,
      commentsQuantity: commentsQuantity,
    );

    return tweet;
  }

  String get getApiUrl => "${ApiConsts.apiUrl}/tweet";

  @override
  Future<TweetModel> createTweet({
    required String text,
  }) async {
    final url = "$getApiUrl/create";
    Map<String, dynamic> jsonRequest = {
      "text": text,
      "canRetweet": true,
      "location": "",
    };

    try {
      final response =
          await ApiService().post(uri: Uri.parse(url), jsonBody: jsonRequest);
      var data = jsonDecode(response.body.toString());

      if (response.statusCode != 200) {
        throw Exception(response);
      }

      TweetModel newTweet = TweetModel.fromJson(data);

      return newTweet;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TweetModel> likeTweet({required TweetModel tweet}) async {
    final url = "$getApiUrl/like";
    Map<String, dynamic> jsonRequest = {
      "tweetId": tweet.id,
    };

    try {
      final response =
          await ApiService().post(uri: Uri.parse(url), jsonBody: jsonRequest);
      var data = jsonDecode(response.body.toString());

      if (response.statusCode != 200) {
        throw Exception(response);
      }

      if (!data) throw Exception("Erro ao curtir");

      tweet.liked = true;
      tweet.likes++;

      return tweet;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TweetModel> deslikeTweet({required TweetModel tweet}) async {
    final url = "$getApiUrl/deslike";
    Map<String, dynamic> jsonRequest = {
      "tweetId": tweet.id,
    };

    try {
      final response =
          await ApiService().post(uri: Uri.parse(url), jsonBody: jsonRequest);
      var data = jsonDecode(response.body.toString());

      if (response.statusCode != 200) {
        throw Exception(response);
      }

      if (!data) throw Exception("Erro ao descurtir!");

      tweet.liked = false;
      tweet.likes--;

      return tweet;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<TweetModel>> listTweets() async {
    Uri uri = Uri.parse("$getApiUrl/list");

    try {
      final response = await ApiService().get(uri: uri);
      var data = jsonDecode(response.body.toString());

      if (response.statusCode != 200) {
        throw Exception("Erro ao buscar tweets");
      }
      List<TweetModel> tweets = [];

      for (Map<String, dynamic> index in data) {
        tweets.add(TweetModel.fromJson(index));
      }

      return tweets;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<TweetModel>> listPostedTweets({
    required UserModel user,
    required String loggedUserId,
  }) async {
    final tweetRef =
        database.collection('tweets').orderBy("date", descending: true);
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
  Future<List<TweetModel>> listLikedTweets({
    required UserModel user,
    required String loggedUserId,
  }) async {
    final tweetRef =
        database.collection('tweets').orderBy("date", descending: true);
    final query = tweetRef.where("likes", arrayContains: user.id);
    final QuerySnapshot snapshot = await query.get();

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
