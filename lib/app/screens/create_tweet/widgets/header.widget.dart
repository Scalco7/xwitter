import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/controllers/route.controller.dart';
import 'package:xwitter/app/screens/create_tweet/widgets/tweet_button.widget.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
    required this.publishTweet,
    required this.disabledTweetButton,
  });

  final void Function() publishTweet;
  final bool disabledTweetButton;

  static final RouteController routeController = RouteController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        TextButton(
          onPressed: () => routeController.routePop(context),
          child: const Text(
            "Cancelar",
            style: TextStyle(color: ColorConsts.primaryColor, fontSize: 17),
          ),
        ),
        TweetButtonWidget(
          disabled: disabledTweetButton,
          onPressButton: publishTweet,
        ),
      ],
    );
  }
}
