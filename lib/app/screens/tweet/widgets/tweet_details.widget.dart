import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/widgets/user.widget.dart';

class TweetDetailsWidget extends StatefulWidget {
  const TweetDetailsWidget({
    super.key,
    required this.tweet,
    required this.goToUserScreen,
    required this.onLikedTweet,
  });
  final TweetModel tweet;
  final void Function(String userId) goToUserScreen;
  final Future<TweetModel> Function({
    required TweetModel tweet,
    required bool liked,
  }) onLikedTweet;

  @override
  State<TweetDetailsWidget> createState() => _TweetDetailsWidgetState();
}

class _TweetDetailsWidgetState extends State<TweetDetailsWidget> {
  late TweetModel tweet;

  void likeTweet() async {
    TweetModel updatedTweet =
        await widget.onLikedTweet(liked: !tweet.liked, tweet: tweet);
    setState(() {
      tweet = updatedTweet;
    });
  }

  @override
  void initState() {
    tweet = widget.tweet;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border.symmetric(
          horizontal: BorderSide(
            width: 0.7,
            color: ColorConsts.borderColor,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: () => widget.goToUserScreen(tweet.user.id),
              child: UserWidget(user: tweet.user),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(tweet.tweet),
            ),
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              decoration: const BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(
                    width: 0.6,
                    color: ColorConsts.borderColor,
                  ),
                ),
              ),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: tweet.likes.toString(),
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const TextSpan(text: " Likes"),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => likeTweet(),
                    child: Image.asset(
                      tweet.liked
                          ? "assets/icons/heart_fill_icon.png"
                          : "assets/icons/heart_icon.png",
                      fit: BoxFit.contain,
                      width: 20,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => print("comentou"),
                    child: Image.asset(
                      "assets/icons/comment_icon.png",
                      fit: BoxFit.contain,
                      width: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
