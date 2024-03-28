import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/helpers/format_quantity.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/common/widgets/primary_button.widget.dart';

class UserDataWidget extends StatelessWidget {
  const UserDataWidget({
    super.key,
    required this.user,
    required this.avatarHeight,
    required this.editUser,
  });

  final UserModel user;
  final double avatarHeight;
  final Function() editUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                width: avatarHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                  border: Border.all(
                    width: 1,
                    color: Colors.white,
                  ),
                ),
                child: Image.asset(
                  user.avatarPath,
                  fit: BoxFit.contain,
                ),
              ),
              PrimaryButtonWidget(
                text: "ediatr",
                onPressed: editUser,
              ),
            ],
          ),
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 22,
              color: Colors.black,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            "@${user.nickname}",
            style: const TextStyle(
              fontSize: 16,
              color: ColorConsts.secondaryColor,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            user.bio,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    formatQuantity(user.numberOfFollowings),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 3),
                  const Text(
                    "Seguindo",
                    style: TextStyle(
                      color: ColorConsts.secondaryColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Row(
                children: <Widget>[
                  Text(
                    formatQuantity(user.numberOfFollowers),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 3),
                  const Text(
                    "Seguidores",
                    style: TextStyle(
                      color: ColorConsts.secondaryColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
