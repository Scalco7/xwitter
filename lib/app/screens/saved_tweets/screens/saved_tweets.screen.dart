import 'package:flutter/material.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/widgets/bottom_navigation_bar.widget.dart';
import 'package:xwitter/app/common/widgets/user_app_bar.widget.dart';
import 'package:xwitter/app/screens/saved_tweets/widgets/saved_tweets_list.widget.dart';

class SavedTweetsScreen extends StatelessWidget {
  const SavedTweetsScreen({
    super.key,
    required this.goToTweetDetailsScreen,
    required this.bottomNavigationRoutes,
    required this.routePop,
  });

  final void Function(TweetModel tweet) goToTweetDetailsScreen;
  final BottomNavigationRoutesModel bottomNavigationRoutes;
  final void Function() routePop;

  @override
  Widget build(BuildContext context) {
    const double appBarHeight = 64;

    return Scaffold(
      appBar: UserAppBarWidget(
        text: "Tweets Salvos",
        height: appBarHeight,
        routePop: routePop,
      ),
      body: SavedTweetsListWidget(
        goToTweetDetailsScreen: goToTweetDetailsScreen,
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: 2,
        bottomNavigationRoutes: bottomNavigationRoutes,
      ),
    );
  }
}
