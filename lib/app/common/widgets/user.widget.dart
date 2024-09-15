import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/common/widgets/profile_photo.widget.dart';

class UserWidget extends StatelessWidget {
  const UserWidget({
    super.key,
    required this.user,
    required this.width,
  });
  final UserModel user;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 75,
      decoration: const BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ProfilePhotoWidget(
              photoUrl: user.photoUrl,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    user.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "@${user.username}",
                    style: const TextStyle(
                      color: ColorConsts.secondaryColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
