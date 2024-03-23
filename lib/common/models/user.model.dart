class UserModel {
  final String id;
  final String name;
  final String nickname;
  final String avatarPath;
  final String bio;
  final int numberOfFollowers;
  final int numberOfFollowings;

  UserModel({
    required this.id,
    required this.name,
    required this.nickname,
    required this.avatarPath,
    required this.bio,
    required this.numberOfFollowers,
    required this.numberOfFollowings,
  });
}
