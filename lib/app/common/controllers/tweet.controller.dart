import 'package:flutter/material.dart';
import 'package:xwitter/app/common/controllers/user.controller.dart';
import 'package:xwitter/app/common/error/validatorFailure.model.dart';
import 'package:xwitter/app/common/helpers/toasts.dart';
import 'package:xwitter/app/common/helpers/validators.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/services/tweet.service.dart';
import 'package:xwitter/app/common/services/user.service.dart';

abstract class ITweetController {
  final List<TweetModel> _tweetsList = [];
  List<TweetModel> get tweetsList => _tweetsList;

  void publishTweet({required String text});

  Future<TweetModel> publishComment({
    required String parentTweetId,
    required String text,
  });

  Future<TweetModel> onLikedTweet({
    required TweetModel tweet,
    required bool liked,
  });

  Future<bool> fillTweetsList({
    required String loggedUserId,
    required bool isReloading,
  });

  Future<List<TweetModel>> tooglePinTweet({required TweetModel tweet});

  Future<List<TweetModel>> listComments({required String tweetId});

  Future<List<TweetModel>> listSavedTweets();
}

class TweetController extends ChangeNotifier implements ITweetController {
  static final TweetController _singleton = TweetController._internal();
  final IUserService userService = UserService();
  final ITweetService tweetService = TweetService();
  final Validators validators = Validators();
  final Toasts toasts = Toasts();
  bool isReloadingTweetList = false;

  @override
  final List<TweetModel> _tweetsList = [];
  @override
  List<TweetModel> get tweetsList => _tweetsList;

  factory TweetController() {
    return _singleton;
  }

  TweetController._internal();

  @override
  void publishTweet({required String text}) async {
    ValidatorFailure tweetValidate = validators.validateTweet(text);
    if (!tweetValidate.valid) {
      toasts.showErrorToast(tweetValidate.error);
      return;
    }

    TweetModel newTweet;
    try {
      newTweet = await tweetService.createTweet(text: text);
    } catch (e) {
      toasts.showErrorToast("Erro");
      return;
    }

    tweetsList.insert(0, newTweet);
    notifyListeners();
  }

  @override
  Future<TweetModel> publishComment({
    required String parentTweetId,
    required String text,
  }) async {
    ValidatorFailure tweetValidate = validators.validateTweet(text);
    if (!tweetValidate.valid) {
      throw Exception(tweetValidate.error);
    }

    TweetModel newTweet;
    try {
      newTweet = await tweetService.comment(tweetId: parentTweetId, text: text);
      return newTweet;
    } catch (e) {
      throw Exception('Erro ao comentar');
    }
  }

  @override
  Future<TweetModel> onLikedTweet({
    required TweetModel tweet,
    required bool liked,
  }) async {
    if (liked) {
      tweet = await tweetService.likeTweet(tweet: tweet);
    } else {
      tweet = await tweetService.deslikeTweet(tweet: tweet);
    }

    return tweet;
  }

  @override
  Future<bool> fillTweetsList({
    required String loggedUserId,
    required bool isReloading,
  }) async {
    if (isReloadingTweetList) return true;

    try {
      isReloadingTweetList = true;
      List<TweetModel> list = await tweetService.listTweets();

      if (isReloading) _tweetsList.clear();
      _tweetsList.addAll(list);

      notifyListeners();
      isReloadingTweetList = false;
      return true;
    } catch (e) {
      isReloadingTweetList = false;
      return false;
    }
  }

  @override
  Future<List<TweetModel>> listComments({required String tweetId}) async {
    return tweetService.listComments(tweetId: tweetId);
  }

  @override
  Future<List<TweetModel>> tooglePinTweet({
    required TweetModel tweet,
  }) async {
    if (tweet.isPinned) {
      await tweetService.unpinTweet(tweetId: tweet.id);
    } else {
      await tweetService.pinTweet(tweetId: tweet.id);
    }

    String loggedUserId = UserController().loggedUser!.id;
    List<TweetModel> postedTweets =
        await tweetService.listPostedTweets(userId: loggedUserId);

    return postedTweets;
  }

  @override
  Future<List<TweetModel>> listSavedTweets() async {
    return tweetService.listSavedTweets();
  }
}
