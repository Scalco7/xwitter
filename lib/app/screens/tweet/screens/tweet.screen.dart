import 'package:flutter/material.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/widgets/bottom_navigation_bar.widget.dart';
import 'package:xwitter/app/screens/tweet/widgets/tweet_app_bar.widget.dart';
import 'package:xwitter/app/screens/tweet/widgets/tweet_details.widget.dart';

class TweetScreen extends StatefulWidget {
  const TweetScreen({super.key, required this.tweet});
  final TweetModel tweet;

  @override
  State<StatefulWidget> createState() => _TweetScreen();
}

class _TweetScreen extends State<TweetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TweetAppBarWidget(),
      body: Column(
        children: <Widget>[
          TweetDetailsWidget(tweet: widget.tweet),
        ],
      ),
      bottomNavigationBar:
          BottomNavigationBarWidget(currentIndex: 1, user: widget.tweet.user),
    );
  }
}
