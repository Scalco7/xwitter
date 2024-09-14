import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/models/user.model.dart';

class UserData {
  final UserModel user;
  List<TweetModel> postedTweets;
  List<TweetModel> likedTweets;

  UserData({
    required this.user,
    required this.postedTweets,
    required this.likedTweets,
  });
}
