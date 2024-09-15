import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xwitter/app/common/consts/api.consts.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/services/api.service.dart';
import 'package:xwitter/app/common/services/user.service.dart';

abstract class ITweetService {
  Future<TweetModel> createTweet({required String text});

  Future<TweetModel> likeTweet({required TweetModel tweet});

  Future<TweetModel> deslikeTweet({required TweetModel tweet});

  Future<List<TweetModel>> listTweets();

  Future<List<TweetModel>> listPostedTweets({required String userId});

  Future<List<TweetModel>> listLikedTweets({required String userId});

  Future<List<TweetModel>> listSavedTweets();

  Future<TweetModel> comment({
    required String tweetId,
    required String text,
  });

  Future<List<TweetModel>> listComments({required String tweetId});

  Future<bool> pinTweet({required String tweetId});

  Future<bool> unpinTweet({required String tweetId});
}

class TweetService implements ITweetService {
  static final TweetService _singleton = TweetService._internal();

  final FirebaseFirestore database = FirebaseFirestore.instance;
  final IUserService userService = UserService();

  factory TweetService() {
    return _singleton;
  }

  TweetService._internal();

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
  Future<List<TweetModel>> listPostedTweets({required String userId}) async {
    Uri uri = Uri.parse("$getApiUrl/listPosted/$userId");

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
  Future<List<TweetModel>> listLikedTweets({required String userId}) async {
    Uri uri = Uri.parse("$getApiUrl/listLiked/$userId");

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
  Future<List<TweetModel>> listSavedTweets() async {
    Uri uri = Uri.parse("$getApiUrl/listSave");

    try {
      final response = await ApiService().get(uri: uri);
      var data = jsonDecode(response.body.toString());

      if (response.statusCode != 200) {
        throw Exception("Erro ao buscar tweets salvos");
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
  Future<TweetModel> comment({
    required String tweetId,
    required String text,
  }) async {
    final url = "$getApiUrl/comment";
    Map<String, dynamic> jsonRequest = {
      "tweetId": tweetId,
      "text": text,
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
  Future<List<TweetModel>> listComments({required String tweetId}) async {
    Uri uri = Uri.parse("$getApiUrl/comments/$tweetId");

    try {
      final response = await ApiService().get(uri: uri);
      var data = jsonDecode(response.body.toString());

      if (response.statusCode != 200) {
        throw Exception("Erro ao buscar comentários");
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
  Future<bool> pinTweet({required String tweetId}) async {
    final url = "$getApiUrl/pin";
    Map<String, dynamic> jsonRequest = {
      "tweetId": tweetId,
    };

    try {
      final response =
          await ApiService().post(uri: Uri.parse(url), jsonBody: jsonRequest);

      if (response.statusCode != 200) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> unpinTweet({required String tweetId}) async {
    final url = "$getApiUrl/unpin";
    Map<String, dynamic> jsonRequest = {
      "tweetId": tweetId,
    };

    try {
      final response =
          await ApiService().post(uri: Uri.parse(url), jsonBody: jsonRequest);

      if (response.statusCode != 200) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
