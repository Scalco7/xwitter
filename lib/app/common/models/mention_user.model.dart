class MentionUserModel {
  final String username;
  final String? photoUrl;

  MentionUserModel({
    required this.username,
    required this.photoUrl,
  });

  factory MentionUserModel.fromJson(Map<String, dynamic> json) =>
      MentionUserModel(
        username: json["username"],
        photoUrl: json["photoUrl"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "photoUrl": photoUrl,
      };
}
