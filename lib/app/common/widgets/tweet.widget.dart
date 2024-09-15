import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/controllers/user.controller.dart';
import 'package:xwitter/app/common/helpers/format_quantity.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/widgets/profile_photo.widget.dart';

class TweetWidget extends StatefulWidget {
  const TweetWidget({
    super.key,
    required this.tweet,
    required this.hasComments,
    required this.onLikedTweet,
  });
  final TweetModel tweet;
  final bool hasComments;
  final Future<TweetModel> Function({required bool liked})
      onLikedTweet; // refatorar para não passar a função por cima

  @override
  State<StatefulWidget> createState() => _TweetWidget();
}

class _TweetWidget extends State<TweetWidget> {
  static IUserController userController = UserController();
  static const double paddingHorizontalWidth = 15;
  static const double avatarWidth = 55;
  static const double gapWidth = 5;
  static const double iconWidth = 30;

  late TweetModel tweet;

  void likeTweet() async {
    TweetModel updatedTweet = await widget.onLikedTweet(liked: !tweet.liked);
    setState(() {
      tweet = updatedTweet;
    });
  }

  void toogleSaveTweet() async {
    TweetModel updatedTweet =
        await userController.toogleSaveTweet(tweet: tweet);

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
    double tweetWidth =
        screenWidth - (paddingHorizontalWidth * 2) - gapWidth - avatarWidth;
    double paddingRight = tweet.isPinned ? 2 * iconWidth : 30;

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
            ProfilePhotoWidget(
              photoUrl: tweet.user.photoUrl,
              size: avatarWidth,
            ),
            const SizedBox(width: gapWidth),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: tweetWidth,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: tweetWidth - paddingRight,
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            Text(
                              tweet.user.name,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '@${tweet.user.username}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: ColorConsts.secondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: iconWidth,
                        height: iconWidth,
                        child: IconButton(
                          onPressed: toogleSaveTweet,
                          padding: const EdgeInsets.all(1),
                          icon: Icon(
                            tweet.isSaved
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            size: iconWidth - 2,
                            color: ColorConsts.secondaryColor,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: tweet.isPinned,
                        child: Transform.rotate(
                          angle: 3.17 / 12,
                          child: const Icon(
                            Icons.push_pin_rounded,
                            size: iconWidth,
                            color: ColorConsts.secondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: tweetWidth,
                  child: Text(
                    tweet.text,
                    overflow: TextOverflow.clip,
                    softWrap: true,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => likeTweet(),
                      child: SizedBox(
                        width: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                    ),
                    Visibility(
                      visible: widget.hasComments,
                      child: GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              "assets/icons/comment_icon.png",
                              fit: BoxFit.contain,
                              width: 15,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              formatQuantity(tweet.commentsQuantity),
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
