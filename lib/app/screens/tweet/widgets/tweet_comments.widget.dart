import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/controllers/tweet.controller.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/common/widgets/tweet.widget.dart';

class TweetCommentsWidget extends StatefulWidget {
  const TweetCommentsWidget({
    super.key,
    required this.commentsQuantity,
    required this.tweetId,
    required this.onLikedTweet,
    required this.goToUserScreen,
  });

  final int commentsQuantity;
  final String tweetId;
  final void Function(UserModel user) goToUserScreen;
  final Future<TweetModel> Function({
    required TweetModel tweet,
    required bool liked,
    String? parentTweetId,
  }) onLikedTweet;

  @override
  State<TweetCommentsWidget> createState() => _TweetCommentsWidgetState();
}

class _TweetCommentsWidgetState extends State<TweetCommentsWidget> {
  static final ITweetController tweetController = TweetController();

  List<TweetModel> commentsList = [];

  void loadComments() async {
    commentsList = await tweetController.listComments(tweetId: widget.tweetId);
  }

  bool commentsIsLoaded() {
    return commentsList.length == widget.commentsQuantity;
  }

  @override
  void initState() {
    if (!commentsIsLoaded()) loadComments();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: commentsIsLoaded()
          ? const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: CircularProgressIndicator(
                  color: ColorConsts.primaryColor,
                ),
              ),
            )
          : Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: const BoxDecoration(color: Colors.white),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: commentsList.length,
                itemBuilder: (BuildContext context, int index) {
                  TweetModel comment = commentsList[index];
                  return GestureDetector(
                    onTap: () => widget.goToUserScreen(comment.user),
                    child: TweetWidget(
                      tweet: comment,
                      hasComments: false,
                      onLikedTweet: ({required liked}) => widget.onLikedTweet(
                        liked: liked,
                        tweet: comment,
                        parentTweetId: widget.tweetId,
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
