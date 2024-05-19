class UserModel {
  final String id;
  final String email;
  String name;
  final String nickname;
  String avatarPath;
  String bio;
  final int numberOfFollowers;
  final int numberOfFollowings;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.nickname,
    required this.avatarPath,
    required this.bio,
    required this.numberOfFollowers,
    required this.numberOfFollowings,
  });
}
