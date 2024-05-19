import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/helpers/format_quantity.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';

class TweetWidget extends StatefulWidget {
  const TweetWidget({
    super.key,
    required this.tweet,
    required this.hasComments,
    required this.onLikedTweet,
  });
  final TweetModel tweet;
  final bool hasComments;
  final Future<TweetModel> Function({required bool liked}) onLikedTweet;

  @override
  State<StatefulWidget> createState() => _TweetWidget();
}

class _TweetWidget extends State<TweetWidget> {
  late TweetModel tweet;

  void likeTweet() async {
    TweetModel updatedTweet = await widget.onLikedTweet(liked: !tweet.liked);
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
    double screenWidth = MediaQuery.of(context).size.width;
    const double paddingHorizontalWidth = 15;
    const double avatarWidth = 55;
    const double gapWidth = 5;
    double tweetWidth =
        screenWidth - (paddingHorizontalWidth * 2) - gapWidth - avatarWidth;

    return SizedBox(
      width: screenWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: paddingHorizontalWidth,
          vertical: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              tweet.user.avatarPath,
              width: avatarWidth,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: gapWidth),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      tweet.user.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '@${tweet.user.nickname}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: ColorConsts.secondaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: tweetWidth,
                  child: Text(
                    tweet.tweet,
                    overflow: TextOverflow.clip,
                    softWrap: true,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => likeTweet(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            tweet.liked
                                ? "assets/icons/heart_fill_icon.png"
                                : "assets/icons/heart_icon.png",
                            fit: BoxFit.contain,
                            width: 15,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            formatQuantity(tweet.likes),
                            style: const TextStyle(
                              color: ColorConsts.secondaryColor,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: tweetWidth / 5),
                    Visibility(
                      visible: widget.hasComments,
                      child: GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              "assets/icons/comment_icon.png",
                              fit: BoxFit.contain,
                              width: 15,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              formatQuantity(tweet.comments?.length ?? 0),
                              style: const TextStyle(
                                color: ColorConsts.secondaryColor,
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
