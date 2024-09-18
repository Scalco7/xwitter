import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/controllers/route.controller.dart';
import 'package:xwitter/app/common/controllers/tweet.controller.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/widgets/tweet.widget.dart';

class SavedTweetsListWidget extends StatefulWidget {
  const SavedTweetsListWidget({super.key});

  @override
  State<SavedTweetsListWidget> createState() => _SavedTweetsListWidgetState();
}

class _SavedTweetsListWidgetState extends State<SavedTweetsListWidget> {
  static final ITweetController tweetController = TweetController();
  static final RouteController routeController = RouteController();
  List<TweetModel>? tweets;

  Future<TweetModel> onLikedTweet({
    required TweetModel tweet,
    required bool liked,
  }) {
    return tweetController.onLikedTweet(
      tweet: tweet,
      liked: liked,
    );
  }

  void goToTweetDetailsScreen(TweetModel tweet) {
    routeController.goToTweetDetailsScreen(context, tweet, reloadPage);
  }

  void reloadPage() {
    setState(() {});
  }

  void loadTweets() async {
    List<TweetModel> savedTweets = await tweetController.listSavedTweets();

    setState(() {
      tweets = savedTweets;
    });
  }

  @override
  void initState() {
    if (tweets == null) loadTweets();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return tweets == null
        ? const Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: CircularProgressIndicator(
                color: ColorConsts.primaryColor,
              ),
            ),
          )
        : tweets!.isEmpty
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Você não tem nenhum Tweet salvo",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: ColorConsts.secondaryColor,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Salve seu primeiro Tweet na aba príncipal",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: ColorConsts.secondaryColor,
                    ),
                  ),
                ],
              )
            : ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => goToTweetDetailsScreen(tweets![index]),
                    child: TweetWidget(
                      key: Key("saved-tweet-${tweets![index].id}"),
                      tweet: tweets![index],
                      isComment: false,
                      onLikedTweet: ({required bool liked}) =>
                          onLikedTweet(tweet: tweets![index], liked: liked),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemCount: tweets!.length,
              );
  }
}
