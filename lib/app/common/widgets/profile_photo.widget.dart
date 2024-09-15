import 'package:flutter/material.dart';

class ProfilePhotoWidget extends StatelessWidget {
  const ProfilePhotoWidget({
    super.key,
    required this.photoUrl,
    this.width,
  });

  final String? photoUrl;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return photoUrl != null
        ? Image.network(
            photoUrl!,
            width: width,
            fit: BoxFit.contain,
          )
        : Image.asset(
            "assets/profilePicure/default.png",
            width: width,
            fit: BoxFit.contain,
          );
  }
}
