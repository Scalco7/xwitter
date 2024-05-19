import 'package:flutter/material.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/widgets/bottom_navigation_bar.widget.dart';
import 'package:xwitter/app/common/widgets/create_tweet_button.widget.dart';
import 'package:xwitter/app/common/widgets/tweet.widget.dart';
import 'package:xwitter/app/screens/home/widgets/home_app_bar.widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.tweets,
    required this.goToTweetDetailsScreen,
    required this.bottomNavigationRoutes,
    required this.onLikedTweet,
  });
  final List<TweetModel> tweets;
  final void Function(TweetModel tweet) goToTweetDetailsScreen;
  final BottomNavigationRoutesModel bottomNavigationRoutes;
  final Future<TweetModel> Function({
    required TweetModel tweet,
    required bool liked,
  }) onLikedTweet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBarWidget(),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () => goToTweetDetailsScreen(tweets[index]),
            child: TweetWidget(
              key: Key("home-tweet-${tweets[index].id}"),
              tweet: tweets[index],
              hasComments: true,
              onLikedTweet: ({required bool liked}) =>
                  onLikedTweet(tweet: tweets[index], liked: liked),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: tweets.length,
      ),
      floatingActionButton: const CreateTweetButtonWidget(),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: 1,
        bottomNavigationRoutes: bottomNavigationRoutes,
      ),
    );
  }
}
