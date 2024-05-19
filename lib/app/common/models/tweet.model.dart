import 'package:xwitter/app/common/models/user.model.dart';

class TweetModel {
  final String id;
  final UserModel user;
  final String tweet;
  int likes;
  bool liked;
  int commentsQuantity;
  List<TweetModel>? comments;

  TweetModel({
    required this.id,
    required this.user,
    required this.tweet,
    required this.likes,
    required this.liked,
    this.commentsQuantity = 0,
    this.comments,
  });
}
