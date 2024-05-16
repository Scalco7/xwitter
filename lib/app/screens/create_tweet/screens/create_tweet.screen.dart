import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/screens/create_tweet/widgets/tweet_button.widget.dart';

class CreateTweetScreen extends StatefulWidget {
  const CreateTweetScreen({
    super.key,
    required this.routePop,
    required this.publishTweet,
  });

  final void Function() routePop;
  final void Function({required String tweet}) publishTweet;

  @override
  State<StatefulWidget> createState() => _CreateTweetScreen();
}

class _CreateTweetScreen extends State<CreateTweetScreen> {
  TextEditingController tweetTextController = TextEditingController();
  late bool disabledTweetButton;

  @override
  void initState() {
    tweetTextController.text = "";
    disabledTweetButton = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void disabledButton() {
      setState(() {
        disabledTweetButton = tweetTextController.text.isEmpty;
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    onPressed: widget.routePop,
                    child: const Text(
                      "Cancelar",
                      style: TextStyle(
                          color: ColorConsts.primaryColor, fontSize: 17),
                    ),
                  ),
                  TweetButtonWidget(
                    disabled: disabledTweetButton,
                    onPressButton: () =>
                        widget.publishTweet(tweet: tweetTextController.text),
                  ),
                ],
              ),
              TextField(
                controller: tweetTextController,
                onChanged: (value) => disabledButton(),
                decoration: InputDecoration(
                  icon: Image.asset(
                    "assets/avatars/man_1.png",
                    width: 35,
                    fit: BoxFit.contain,
                  ),
                  border: InputBorder.none,
                  hintText: "Como você está?",
                ),
                maxLines: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
