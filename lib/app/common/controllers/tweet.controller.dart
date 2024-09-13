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

  void publishTweet({
    required String loggedUserId,
    required BuildContext context,
    required String tweet,
    String? parentTweetId,
  });

  Future<TweetModel> onLikedTweet({
    required String loggedUserId,
    required TweetModel tweet,
    required bool liked,
    String? parentTweetId,
  });

  Future<bool> fillTweetsList({
    required String loggedUserId,
    required bool isReloading,
  });
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
  void publishTweet({
    required String loggedUserId,
    required BuildContext context,
    required String tweet,
    String? parentTweetId,
  }) async {
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
    // fillTweetsList(loggedUserId: loggedUserId, isReloading: true);
  }

  @override
  Future<TweetModel> onLikedTweet({
    required String loggedUserId,
    required TweetModel tweet,
    required bool liked,
    String? parentTweetId,
  }) async {
    if (liked) {
      tweet = await tweetService.likeTweet(
        tweet: tweet,
        loggedUserId: loggedUserId,
        parentTweetId: parentTweetId,
      );
    } else {
      tweet = await tweetService.deslikeTweet(
        tweet: tweet,
        loggedUserId: loggedUserId,
        parentTweetId: parentTweetId,
      );
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
}
