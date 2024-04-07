import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/widgets/bottom_navigation_bar.widget.dart';
import 'package:xwitter/app/common/widgets/tweet.widget.dart';
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
      backgroundColor: ColorConsts.backgroundColor,
      appBar: const TweetAppBarWidget(),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            TweetDetailsWidget(tweet: widget.tweet),
            Visibility(
              visible: widget.tweet.comments != null,
              child: Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.tweet.comments?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return TweetWidget(tweet: widget.tweet.comments![index]);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          BottomNavigationBarWidget(currentIndex: 1, user: widget.tweet.user),
    );
  }
}
