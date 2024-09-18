import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/controllers/tweet.controller.dart';
import 'package:xwitter/app/common/controllers/user.controller.dart';
import 'package:xwitter/app/common/helpers/format_quantity.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/widgets/profile_photo.widget.dart';
import 'package:xwitter/app/common/widgets/video_player_networking.widget.dart';
import 'package:xwitter/app/common/widgets/tweet_text.widget.dart';

class TweetWidget extends StatefulWidget {
  const TweetWidget({
    super.key,
    required this.tweet,
    required this.isComment,
  });
  final TweetModel tweet;
  final bool isComment;

  @override
  State<StatefulWidget> createState() => _TweetWidget();
}

class _TweetWidget extends State<TweetWidget> {
  static final ITweetController tweetController = TweetController();
  static final IUserController userController = UserController();
  static const double paddingHorizontalWidth = 15;
  static const double avatarWidth = 55;
  static const double gapWidth = 5;
  static const double iconWidth = 30;

  late TweetModel tweet;

  Future<TweetModel> onLikedTweet({
    required bool liked,
  }) {
    return tweetController.onLikedTweet(
      tweet: tweet,
      liked: liked,
    );
  }

  void likeTweet() async {
    TweetModel updatedTweet = await onLikedTweet(liked: !tweet.liked);
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
    double paddingRight =
        (tweet.isPinned ? iconWidth : 0) + (!widget.isComment ? iconWidth : 0);

    return SizedBox(
      width: screenWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: paddingHorizontalWidth,
          vertical: 10,
        ),
        child: Column(
          children: <Widget>[
            Row(
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
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
                          Visibility(
                            visible: !widget.isComment,
                            child: SizedBox(
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
                      child: TweetTextWidget(
                        text: tweet.text,
                        mentionsIds: tweet.mentionsUserIds,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (tweet.mediaUrl != null)
              Column(
                children: <Widget>[
                  const SizedBox(height: 10),
                  SizedBox(
                    width: tweetWidth,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: !tweet.mediaUrl!.contains('.mp4')
                          ? Image.network(
                              tweet.mediaUrl!,
                              width: tweetWidth,
                              fit: BoxFit.contain,
                            )
                          : SizedBox(
                              width: tweetWidth,
                              height: 500,
                              child: Flexible(
                                child: VideoPlayerNetworkingWidget(
                                  videoUrl: tweet.mediaUrl!,
                                  iconsSize: 18,
                                  loop: false,
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => likeTweet(),
                    child: SizedBox(
                      width: 120,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            tweet.liked
                                ? "assets/icons/heart_fill_icon.png"
                                : "assets/icons/heart_icon.png",
                            fit: BoxFit.contain,
                            width: 18,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            formatQuantity(tweet.likes),
                            style: const TextStyle(
                              color: ColorConsts.secondaryColor,
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !widget.isComment,
                    child: GestureDetector(
                      child: SizedBox(
                        width: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              "assets/icons/comment_icon.png",
                              fit: BoxFit.contain,
                              width: 18,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              formatQuantity(tweet.commentsQuantity),
                              style: const TextStyle(
                                color: ColorConsts.secondaryColor,
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !widget.isComment,
                    child: GestureDetector(
                      child: SizedBox(
                        width: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Icon(
                              Icons.repeat,
                              color: ColorConsts.secondaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              formatQuantity(
                                  20), //colocar a quantidade de retweets ###
                              style: const TextStyle(
                                color: ColorConsts.secondaryColor,
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                      ),
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
