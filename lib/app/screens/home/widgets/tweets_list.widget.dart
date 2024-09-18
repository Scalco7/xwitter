import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/controllers/route.controller.dart';
import 'package:xwitter/app/common/controllers/tweet.controller.dart';
import 'package:xwitter/app/common/controllers/user.controller.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/widgets/tweet.widget.dart';

class TweetsListWidget extends StatefulWidget {
  const TweetsListWidget({super.key});

  @override
  State<TweetsListWidget> createState() => _TweetsListWidgetState();
}

class _TweetsListWidgetState extends State<TweetsListWidget> {
  static final ITweetController tweetController = TweetController();
  static final IUserController userController = UserController();
  static final RouteController routeController = RouteController();
  List<TweetModel> tweets = tweetController.tweetsList;

  void goToTweetDetailsScreen(TweetModel tweet) {
    routeController.goToTweetDetailsScreen(context, tweet, reloadPage);
  }

  void reloadPage() {
    setState(() {});
  }

  void reloadTweets() async {
    await tweetController.fillTweetsList(
      loggedUserId: userController.loggedUser!.id,
      isReloading: true,
    );
  }

  void fillTweets() async {
    await tweetController.fillTweetsList(
      loggedUserId: userController.loggedUser!.id,
      isReloading: false,
    );
  }

  void updateTweets() {
    setState(() {
      tweets = tweetController.tweetsList;
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    TweetController().addListener(updateTweets);
    if (tweetController.tweetsList.isEmpty) reloadTweets();

    super.initState();
  }

  @override
  void dispose() {
    TweetController().removeListener(updateTweets);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return tweets.isEmpty
        ? const Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: CircularProgressIndicator(
                color: ColorConsts.primaryColor,
              ),
            ),
          )
        : ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () => goToTweetDetailsScreen(tweets[index]),
                child: TweetWidget(
                  key: Key("home-tweet-${tweets[index].id}"),
                  tweet: tweets[index],
                  isComment: false,
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemCount: tweets.length,
          );
  }
}
