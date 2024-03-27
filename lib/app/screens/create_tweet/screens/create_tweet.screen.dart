import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/screens/create_tweet/widgets/tweet_button.widget.dart';

class CreateTweetScreen extends StatefulWidget {
  const CreateTweetScreen({super.key});

  void publishTweet() {
    print("publicou");
  }

  @override
  State<StatefulWidget> createState() => _CreateTweetScreen();
}

class _CreateTweetScreen extends State<CreateTweetScreen> {
  late String tweetText;
  late bool disabledTweetButton;

  @override
  void initState() {
    tweetText = "";
    disabledTweetButton = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void updateText(String text) {
      setState(() {
        tweetText = text;
        disabledTweetButton = tweetText.isEmpty;
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
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Cancelar",
                      style: TextStyle(
                          color: ColorConsts.primaryColor, fontSize: 17),
                    ),
                  ),
                  TweetButtonWidget(
                    disabled: disabledTweetButton,
                    onPressButton: widget.publishTweet,
                  ),
                ],
              ),
              TextField(
                onChanged: (text) => updateText(text),
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
