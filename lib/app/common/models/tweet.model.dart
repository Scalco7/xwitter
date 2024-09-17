import 'package:xwitter/app/common/models/user.model.dart';

class TweetModel {
  final String id;
  final UserModel user;
  final String text;
  final bool canRetweet;
  final String? mediaUrl;
  final String? location;
  final List<String> mentionsUserIds;
  int likes;
  bool liked;
  bool isPinned;
  bool isSaved;
  int commentsQuantity;
  List<TweetModel>? comments;

  TweetModel({
    required this.id,
    required this.user,
    required this.text,
    required this.canRetweet,
    required this.location,
    required this.mediaUrl,
    required this.likes,
    required this.liked,
    required this.isPinned,
    required this.isSaved,
    required this.mentionsUserIds,
    this.commentsQuantity = 0,
    this.comments,
  });

  factory TweetModel.fromJson(Map<String, dynamic> json) => TweetModel(
        id: json["id"],
        user: UserModel.fromJson(json["user"]),
        text: json["text"],
        likes: json["likes"],
        liked: json["liked"],
        mediaUrl: json["mediaUrl"],
        mentionsUserIds: ((json["mentionsUserIds"] ?? []) as List<dynamic>)
            .map((id) => id as String)
            .toList(),
        canRetweet: json["canRetweet"] ?? false,
        location: json["location"],
        isPinned: json["isPinned"] ?? false,
        isSaved: json["isSaved"] ?? false,
        commentsQuantity: json["commentsQuantity"] ?? 0,
        comments: json["comments"] ?? [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "text": text,
        "location": location,
        "canRetweet": canRetweet,
        "likes": likes,
        "mediaUrl": mediaUrl,
        "liked": liked,
        "isPinned": isPinned,
        "commentsQuantity": commentsQuantity,
        "comments": comments,
      };
}
