import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/controllers/tweet.controller.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/screens/create_tweet/widgets/tweet_button.widget.dart';

class CreateTweetScreen extends StatefulWidget {
  const CreateTweetScreen({
    super.key,
    required this.loggedUser,
    required this.routePop,
    required this.goToHomeScreen,
  });

  final UserModel loggedUser;
  final void Function() routePop;
  final void Function() goToHomeScreen;

  @override
  State<StatefulWidget> createState() => _CreateTweetScreen();
}

class _CreateTweetScreen extends State<CreateTweetScreen> {
  TweetController tweetController = TweetController();
  TextEditingController tweetTextController = TextEditingController();
  late bool disabledTweetButton;

  void publishTweet() {
    tweetController.publishTweet(
      loggedUserId: widget.loggedUser.id,
      context: context,
      tweet: tweetTextController.text,
    );

    widget.goToHomeScreen();
  }

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
                    onPressButton: publishTweet,
                  ),
                ],
              ),
              TextField(
                controller: tweetTextController,
                onChanged: (value) => disabledButton(),
                decoration: InputDecoration(
                  icon: Image.asset(
                    widget.loggedUser.avatarPath,
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
