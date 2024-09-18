import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/common/widgets/tweet.widget.dart';

class TweetCommentsWidget extends StatelessWidget {
  const TweetCommentsWidget({
    super.key,
    required this.commentsList,
    required this.commentsQuantity,
    required this.tweetId,
    required this.goToUserScreen,
  });

  final List<TweetModel> commentsList;
  final int commentsQuantity;
  final String tweetId;
  final void Function(UserModel user) goToUserScreen;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: commentsList.length < commentsQuantity
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
                    key: Key(comment.id),
                    onTap: () => goToUserScreen(comment.user),
                    child: TweetWidget(
                      tweet: comment,
                      isComment: true,
                    ),
                  );
                },
              ),
            ),
    );
  }
}
