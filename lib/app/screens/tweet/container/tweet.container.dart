import 'package:flutter/widgets.dart';
import 'package:xwitter/app/common/error/failure.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/common/services/tweet.service.dart';
import 'package:xwitter/app/common/widgets/bottom_navigation_bar.widget.dart';
import 'package:xwitter/app/common/widgets/loading.widget.dart';
import 'package:xwitter/app/screens/tweet/screens/tweet.screen.dart';

class TweetContainer extends StatelessWidget {
  const TweetContainer({
    super.key,
    required this.service,
    required this.loggedUserId,
    required this.tweet,
    required this.indexNavBar,
    required this.goToUserScreen,
    required this.routePop,
    required this.bottomNavigationRoutes,
    required this.publishComment,
  });
  final ITweetService service;
  final String loggedUserId;
  final TweetModel tweet;
  final int indexNavBar;
  final void Function(UserModel user) goToUserScreen;
  final void Function() routePop;
  final BottomNavigationRoutesModel bottomNavigationRoutes;
  final void Function(
      {required String comment,
      required TweetModel parentTweet}) publishComment;

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
            bottomNavigationRoutes: bottomNavigationRoutes,
            publishComment: publishComment,
          );
        }
        if (snapshot.hasError) {
          return ErrorWidget((snapshot.error as Failure).message!);
        }

        return Container();
      },
    );
  }
}
