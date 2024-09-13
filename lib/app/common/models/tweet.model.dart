import 'package:xwitter/app/common/models/user.model.dart';

class TweetModel {
  final String id;
  final UserModel user;
  final String text;
  int likes;
  bool liked;
  bool isPinned;
  int commentsQuantity;
  List<TweetModel>? comments;

  TweetModel({
    required this.id,
    required this.user,
    required this.text,
    required this.likes,
    required this.liked,
    required this.isPinned,
    this.commentsQuantity = 0,
    this.comments,
  });

  factory TweetModel.fromJson(Map<String, dynamic> json) => TweetModel(
        id: json["id"],
        user: UserModel.fromJson(json["user"]),
        text: json["text"],
        likes: json["likes"],
        liked: json["liked"],
        isPinned: json["isPinned"],
        commentsQuantity: json["commentsQuantity"] ?? 0,
        comments: json["comments"] ?? [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "text": text,
        "likes": likes,
        "liked": liked,
        "isPinned": isPinned,
        "commentsQuantity": commentsQuantity,
        "comments": comments,
      };
}
