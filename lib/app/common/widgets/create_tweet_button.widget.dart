import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';

class CreateTweetButtonWidget extends StatelessWidget {
  const CreateTweetButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: ColorConsts.primaryColor,
      shape: const CircleBorder(),
      child: Image.asset(
        "assets/icons/add_text_icon.png",
        fit: BoxFit.contain,
        width: 23,
      ),
      onPressed: () => Navigator.pushNamed(context, "/create-tweet"),
    );
  }
}
