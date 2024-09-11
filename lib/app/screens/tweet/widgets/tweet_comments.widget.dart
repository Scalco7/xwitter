import 'package:flutter/material.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/widgets/tweet.widget.dart';

class TweetCommentsWidget extends StatefulWidget {
  const TweetCommentsWidget({
    super.key,
    required this.commentsQuantity,
    required this.comments,
    required this.tweetId,
    required this.onLikedTweet,
    required this.goToUserScreen,
  });

  final int commentsQuantity;
  final String tweetId;
  final List<TweetModel> comments;
  final void Function(String userId) goToUserScreen;
  final Future<TweetModel> Function({
    required TweetModel tweet,
    required bool liked,
    String? parentTweetId,
  }) onLikedTweet;

  @override
  State<TweetCommentsWidget> createState() => _TweetCommentsWidgetState();
}

class _TweetCommentsWidgetState extends State<TweetCommentsWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: const BoxDecoration(color: Colors.white),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.comments.length,
          itemBuilder: (BuildContext context, int index) {
            TweetModel comment = widget.comments[index];
            return GestureDetector(
              onTap: () => widget.goToUserScreen(comment.user.id),
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
