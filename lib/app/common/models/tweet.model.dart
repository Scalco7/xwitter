import 'package:xwitter/app/common/models/user.model.dart';

class TweetModel {
  final String id;
  final UserModel? user;
  final String? userId;
  final String tweet;
  final int likes;
  bool liked;
  final List<TweetModel>? comments;

  TweetModel({
    required this.id,
    this.user,
    this.userId,
    required this.tweet,
    required this.likes,
    required this.liked,
    this.comments,
  });
}
