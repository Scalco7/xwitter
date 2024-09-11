import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/controllers/tweet.controller.dart';
import 'package:xwitter/app/common/controllers/user.controller.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/widgets/tweet.widget.dart';

class TweetsListWidget extends StatefulWidget {
  const TweetsListWidget({super.key, required this.goToTweetDetailsScreen});
  final void Function(TweetModel tweet) goToTweetDetailsScreen;

  @override
  State<TweetsListWidget> createState() => _TweetsListWidgetState();
}

class _TweetsListWidgetState extends State<TweetsListWidget> {
  static final ITweetController tweetController = TweetController();
  static final IUserController userController = UserController();
  List<TweetModel> tweets = [];

  Future<TweetModel> onLikedTweet({
    required TweetModel tweet,
    required bool liked,
  }) {
    return tweetController.onLikedTweet(
      tweet: tweet,
      liked: liked,
      loggedUserId: userController.loggedUser!.id,
    );
  }

  void reloadTweets() async {
    await tweetController.fillTweetsList(
      loggedUserId: userController.loggedUser!.id,
      isReloading: true,
    );

    print(tweetController.tweetsList[0].tweet);
    updateTweets();
  }

  void fillTweets() async {
    await tweetController.fillTweetsList(
      loggedUserId: userController.loggedUser!.id,
      isReloading: false,
    );

    print(tweetController.tweetsList[0].tweet);
    updateTweets();
  }

  void updateTweets() {
    setState(() {
      tweets = tweetController.tweetsList;
    });
  }

  @override
  void initState() {
    if (tweetController.tweetsList.isEmpty) reloadTweets();

    tweets = tweetController.tweetsList;
    super.initState();
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
                onTap: () => widget.goToTweetDetailsScreen(tweets[index]),
                child: TweetWidget(
                  key: Key("home-tweet-${tweets[index].id}"),
                  tweet: tweets[index],
                  hasComments: true,
                  onLikedTweet: ({required bool liked}) =>
                      onLikedTweet(tweet: tweets[index], liked: liked),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemCount: tweets.length,
          );
  }
}
