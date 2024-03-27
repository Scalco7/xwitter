import 'package:flutter/material.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/widgets/bottom_navigation_bar.widget.dart';
import 'package:xwitter/app/common/widgets/create_tweet_button.widget.dart';
import 'package:xwitter/app/common/widgets/tweet.widget.dart';
import 'package:xwitter/app/screens/home/widgets/home_app_bar.widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.tweets});
  final List<TweetModel> tweets;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBarWidget(),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return TweetWidget(tweet: tweets[index]);
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: tweets.length,
      ),
      floatingActionButton: const CreateTweetButtonWidget(),
      bottomNavigationBar: const BottomNavigationBarWidget(currentIndex: 1),
    );
  }
}
