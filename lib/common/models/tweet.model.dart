import 'package:xwitter/common/models/user.model.dart';

class TweetModel {
  final UserModel user;
  final String tweet;
  final int likes;
  final List<TweetModel>? comments;

  TweetModel({
    required this.user,
    required this.tweet,
    required this.likes,
    this.comments,
  });
}
