import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:xwitter/app/common/controllers/tweet.controller.dart';
import 'package:xwitter/app/common/controllers/user.controller.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/common/services/tweet.service.dart';
import 'package:xwitter/app/common/widgets/bottom_navigation_bar.widget.dart';
import 'package:xwitter/app/common/widgets/bt_error.widget.dart';
import 'package:xwitter/app/common/widgets/loading.widget.dart';
import 'package:xwitter/app/screens/tweet/screens/tweet.screen.dart';

class TweetContainer extends StatelessWidget {
  const TweetContainer({
    super.key,
    required this.tweet,
    required this.indexNavBar,
    required this.goToUserScreen,
    required this.routePop,
    required this.updateTweetScreen,
    required this.bottomNavigationRoutes,
  });
  static final ITweetService service = TweetService();
  static final String loggedUserId = UserController().loggedUser!.id;
  static final ITweetController tweetController = TweetController();

  final TweetModel tweet;
  final int indexNavBar;
  final void Function(UserModel user) goToUserScreen;
  final void Function() routePop;
  final void Function({required TweetModel tweet}) updateTweetScreen;
  final BottomNavigationRoutesModel bottomNavigationRoutes;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TweetModel>(
      future:
          service.updateLoadedTweet(tweet: tweet, loggedUserId: loggedUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        }
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return TweetScreen(
            tweet: snapshot.data!,
            indexNavBar: indexNavBar,
            goToUserScreen: goToUserScreen,
            routePop: routePop,
            updateTweetScreen: () => updateTweetScreen(tweet: snapshot.data!),
            bottomNavigationRoutes: bottomNavigationRoutes,
            publishComment: ({required comment}) =>
                tweetController.publishTweet(
              loggedUserId: loggedUserId,
              context: context,
              tweet: comment,
              parentTweetId: snapshot.data!.id,
            ),
            onLikedTweet: ({required liked, parentTweetId, required tweet}) =>
                tweetController.onLikedTweet(
              loggedUserId: loggedUserId,
              tweet: tweet,
              liked: liked,
              parentTweetId: parentTweetId,
            ),
          );
        }
        if (snapshot.hasError) {
          return BTErrorWidget(
              error: (snapshot.error as FirebaseException).message!);
        }

        return Container();
      },
    );
  }
}
