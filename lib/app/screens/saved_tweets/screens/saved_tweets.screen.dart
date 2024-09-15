import 'package:flutter/material.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/widgets/bottom_navigation_bar.widget.dart';
import 'package:xwitter/app/common/widgets/create_tweet_button.widget.dart';
import 'package:xwitter/app/screens/home/widgets/home_app_bar.widget.dart';

class SavedTweetsScreen extends StatelessWidget {
  const SavedTweetsScreen({
    super.key,
    required this.goToTweetDetailsScreen,
    required this.bottomNavigationRoutes,
  });

  final void Function(TweetModel tweet) goToTweetDetailsScreen;
  final BottomNavigationRoutesModel bottomNavigationRoutes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBarWidget(),
      body: const Center(
        child: Text("tweets salvosd"),
      ),
      floatingActionButton: const CreateTweetButtonWidget(),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: 1,
        bottomNavigationRoutes: bottomNavigationRoutes,
      ),
    );
  }
}
