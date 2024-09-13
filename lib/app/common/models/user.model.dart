class UserModel {
  final String id;
  final String email;
  final String username;
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
    required this.username,
    required this.avatarPath,
    required this.bio,
    required this.numberOfFollowers,
    required this.numberOfFollowings,
    required this.following,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      username: json["username"],
      bio: json["bio"] ?? "",
      following: json["following"] ?? false,
      numberOfFollowings: json["numberOfFollowings"] ?? 0,
      numberOfFollowers: json["numberOfFollowers"] ?? 0,
      avatarPath: "assets/avatars/apagao_1.png");

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "username": username,
        "bio": bio,
        "following": following,
        "numberOfFollowings": numberOfFollowings,
        "numberOfFollowers": numberOfFollowers,
      };
}
