import 'package:flutter/material.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/widgets/bottom_navigation_bar.widget.dart';
import 'package:xwitter/app/common/widgets/user.widget.dart';
import 'package:xwitter/app/screens/tweet/widgets/tweet_app_bar.widget.dart';

class TweetScreen extends StatelessWidget {
  const TweetScreen({super.key, required this.tweet});
  final TweetModel tweet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TweetAppBarWidget(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.of(context)
                  .pushReplacementNamed("/user", arguments: tweet.user),
              child: UserWidget(user: tweet.user),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          BottomNavigationBarWidget(currentIndex: 1, user: tweet.user),
    );
  }
}
