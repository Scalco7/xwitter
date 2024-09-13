import 'package:flutter/material.dart';
import 'package:xwitter/app/common/error/validatorFailure.model.dart';
import 'package:xwitter/app/common/helpers/toasts.dart';
import 'package:xwitter/app/common/helpers/validators.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/services/tweet.service.dart';
import 'package:xwitter/app/common/services/user.service.dart';

abstract class ITweetController {
  final List<TweetModel> _tweetsList = [];
  List<TweetModel> get tweetsList => _tweetsList;

  void publishTweet({required String tweet});

  void publishComment({
    required String parentTweetId,
    required String tweet,
  });

  Future<TweetModel> onLikedTweet({
    required TweetModel tweet,
    required bool liked,
  });

  Future<bool> fillTweetsList({
    required String loggedUserId,
    required bool isReloading,
  });

  Future<List<TweetModel>> listComments({required String tweetId});
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
  void publishTweet({required String tweet}) async {
    ValidatorFailure tweetValidate = validators.validateTweet(tweet);
    if (!tweetValidate.valid) {
      toasts.showErrorToast(tweetValidate.error);
      return;
    }

    TweetModel newTweet;
    try {
      newTweet = await tweetService.createTweet(text: tweet);
    } catch (e) {
      toasts.showErrorToast("Erro");
      return;
    }

    tweetsList.add(newTweet);
    notifyListeners();
  }

  @override
  Future<TweetModel> publishComment({
    required String parentTweetId,
    required String tweet,
  }) async {
    ValidatorFailure tweetValidate = validators.validateTweet(tweet);
    if (!tweetValidate.valid) {
      toasts.showErrorToast(tweetValidate
          .error); //mostrar esse toast emm outro lugar, não no controller
      throw Exception(tweetValidate.error);
    }

    TweetModel newTweet;
    try {
      newTweet =
          await tweetService.comment(tweetId: parentTweetId, text: tweet);
      return newTweet;
    } catch (e) {
      toasts.showErrorToast("Erro");
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
}
