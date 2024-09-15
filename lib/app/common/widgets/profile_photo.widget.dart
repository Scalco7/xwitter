import 'package:flutter/material.dart';

class ProfilePhotoWidget extends StatelessWidget {
  const ProfilePhotoWidget({
    super.key,
    required this.photoUrl,
    required this.size,
  });

  final String? photoUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(100)),
      child: photoUrl != null
          ? Image.network(
              photoUrl!,
              width: size,
              height: size,
              fit: BoxFit.fill,
            )
          : Image.asset(
              "assets/profilePicure/default.png",
              width: size,
              height: size,
              fit: BoxFit.fill,
            ),
    );
  }
}
