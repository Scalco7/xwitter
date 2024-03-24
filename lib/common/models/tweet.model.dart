import 'package:xwitter/common/models/user.model.dart';

class TweetModel {
  final String id;
  final UserModel user;
  final String tweet;
  final int likes;
  final bool liked;
  final List<TweetModel>? comments;

  TweetModel({
    required this.id,
    required this.user,
    required this.tweet,
    required this.likes,
    required this.liked,
    this.comments,
  });
}
