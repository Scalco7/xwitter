class UserModel {
  final String id;
  final String email;
  final String nickname;
  final int numberOfFollowings;
  String name;
  String avatarPath;
  String bio;
  int numberOfFollowers;
  bool following;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.nickname,
    required this.avatarPath,
    required this.bio,
    required this.numberOfFollowers,
    required this.numberOfFollowings,
    required this.following,
  });
}
