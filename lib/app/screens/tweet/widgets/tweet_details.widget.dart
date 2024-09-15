import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/controllers/user.controller.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/common/widgets/user.widget.dart';

class TweetDetailsWidget extends StatefulWidget {
  const TweetDetailsWidget({
    super.key,
    required this.tweet,
    required this.commentTextFieldFocus,
    required this.goToUserScreen,
    required this.onLikedTweet,
  });
  final TweetModel tweet;
  final FocusNode commentTextFieldFocus;
  final void Function(UserModel user) goToUserScreen;
  final Future<TweetModel> Function({
    required TweetModel tweet,
    required bool liked,
  }) onLikedTweet;

  @override
  State<TweetDetailsWidget> createState() => _TweetDetailsWidgetState();
}

class _TweetDetailsWidgetState extends State<TweetDetailsWidget> {
  static final IUserController userController = UserController();
  static const double iconWidth = 40;
  late TweetModel tweet;

  void likeTweet() async {
    TweetModel updatedTweet =
        await widget.onLikedTweet(liked: !tweet.liked, tweet: tweet);
    setState(() {
      tweet = updatedTweet;
    });
  }

  void commentFocus() {
    widget.commentTextFieldFocus.requestFocus();
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
    double perfilWidth = MediaQuery.of(context).size.width - iconWidth - 20;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () => widget.goToUserScreen(tweet.user),
                  child: UserWidget(
                    user: tweet.user,
                    width: perfilWidth,
                  ),
                ),
                SizedBox(
                  width: iconWidth,
                  height: iconWidth,
                  child: IconButton(
                    onPressed: toogleSaveTweet,
                    padding: const EdgeInsets.all(3),
                    icon: Icon(
                      tweet.isSaved ? Icons.bookmark : Icons.bookmark_border,
                      size: iconWidth - 8,
                      color: ColorConsts.secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
            if (tweet.location != null)
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.location_on_rounded,
                      color: ColorConsts.primaryColor,
                      size: 25,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      tweet.location!,
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(tweet.text),
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
                    TextSpan(text: " Curtida${tweet.likes <= 1 ? "" : "s"}"),
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
                    onTap: () => commentFocus(),
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
