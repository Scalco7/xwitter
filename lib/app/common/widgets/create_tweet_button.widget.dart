import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/controllers/route.controller.dart';

class CreateTweetButtonWidget extends StatelessWidget {
  const CreateTweetButtonWidget({super.key});

  static final RouteController routeController = RouteController();

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
      onPressed: () => routeController.goToCreateTweetScreen(context, null),
    );
  }
}
