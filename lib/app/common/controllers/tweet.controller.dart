import 'package:flutter/material.dart';
import 'package:xwitter/app/common/error/validatorFailure.model.dart';
import 'package:xwitter/app/common/helpers/toasts.dart';
import 'package:xwitter/app/common/helpers/validators.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/services/tweet.service.dart';
import 'package:xwitter/app/common/services/user.service.dart';

abstract class ITweetController {
  final List<TweetModel> tweetsList = [];

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

class TweetController implements ITweetController {
  static final TweetController _singleton = TweetController._internal();
  final IUserService userService = UserService();
  final ITweetService tweetService = TweetService();
  final Validators validators = Validators();
  final Toasts toasts = Toasts();

  @override
  final List<TweetModel> tweetsList = [];

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

    bool success = await tweetService.createTweet(
      userId: loggedUserId,
      tweet: tweet,
      parentTweetId: parentTweetId,
    );

    if (!success) {
      toasts.showErrorToast("Erro");
      return;
    }
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
    try {
      if (isReloading) tweetsList.clear();

      tweetsList
          .addAll(await tweetService.listTweets(loggedUserId: loggedUserId));
      return true;
    } catch (e) {
      return false;
    }
  }
}
