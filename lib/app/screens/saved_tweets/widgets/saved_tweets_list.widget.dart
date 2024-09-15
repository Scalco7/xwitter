import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/controllers/tweet.controller.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/widgets/tweet.widget.dart';

class SavedTweetsListWidget extends StatefulWidget {
  const SavedTweetsListWidget(
      {super.key, required this.goToTweetDetailsScreen});
  final void Function(TweetModel tweet) goToTweetDetailsScreen;

  @override
  State<SavedTweetsListWidget> createState() => _SavedTweetsListWidgetState();
}

class _SavedTweetsListWidgetState extends State<SavedTweetsListWidget> {
  static final ITweetController tweetController = TweetController();
  List<TweetModel> tweets = [];

  Future<TweetModel> onLikedTweet({
    required TweetModel tweet,
    required bool liked,
  }) {
    return tweetController.onLikedTweet(
      tweet: tweet,
      liked: liked,
    );
  }

  void loadTweets() async {
    List<TweetModel> savedTweets = await tweetController.listSavedTweets();

    setState(() {
      tweets = savedTweets;
    });
  }

  @override
  void initState() {
    if (tweets.isEmpty) loadTweets();

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
                  key: Key("saved-tweet-${tweets[index].id}"),
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
