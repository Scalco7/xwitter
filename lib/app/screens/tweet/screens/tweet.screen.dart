import 'package:flutter/material.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/widgets/bottom_navigation_bar.widget.dart';

class TweetScreen extends StatelessWidget {
  const TweetScreen({super.key, required this.tweet});
  final TweetModel tweet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Tweet",
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Center(
        child: Text(tweet.tweet),
      ),
      bottomNavigationBar:
          BottomNavigationBarWidget(currentIndex: 1, user: tweet.user),
    );
  }
}
