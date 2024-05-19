import 'package:flutter/material.dart';
import 'package:xwitter/app/common/error/validatorFailure.model.dart';
import 'package:xwitter/app/common/helpers/toasts.dart';
import 'package:xwitter/app/common/helpers/validators.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/services/tweet.service.dart';
import 'package:xwitter/app/common/services/user.service.dart';

class TweetController {
  final IUserService userService = UserService();
  final ITweetService tweetService = TweetService();
  final Validators validators = Validators();
  final Toasts toasts = Toasts();

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

    // goToHomeScreen(context); -> chamar quando publicar
    // chamar função pra home

    // Navigator.of(context)
    //     .pushReplacementNamed("/tweet", arguments: parentTweet); -> chamar quando comentar

    // vai chamar o controller e dps fora daqui vai chamar a função de mudar de rota
  }

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
}
