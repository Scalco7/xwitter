import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:xwitter/common/consts/style.consts.dart';
import 'package:xwitter/common/models/tweet.model.dart';

class TweetWidget extends StatelessWidget {
  const TweetWidget({super.key, required this.tweet});
  final TweetModel tweet;

  String formatQuantity(int quantity) {
    final result = quantity.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ');
    return result;
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
              "assets/avatars/batman.png",
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
                      onTap: () => print("curtiu"),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            "assets/icons/heart_icon.png",
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
                    GestureDetector(
                      onTap: () => print("comentou"),
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
