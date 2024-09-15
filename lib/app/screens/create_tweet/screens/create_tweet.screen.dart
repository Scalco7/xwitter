import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/controllers/tweet.controller.dart';
import 'package:xwitter/app/common/controllers/user.controller.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/common/widgets/profile_photo.widget.dart';
import 'package:xwitter/app/screens/create_tweet/widgets/tweet_button.widget.dart';

class CreateTweetScreen extends StatefulWidget {
  const CreateTweetScreen({
    super.key,
    required this.routePop,
    required this.goToHomeScreen,
  });

  final void Function() routePop;
  final void Function() goToHomeScreen;

  @override
  State<StatefulWidget> createState() => _CreateTweetScreen();
}

class _CreateTweetScreen extends State<CreateTweetScreen> {
  final UserModel loggedUser = UserController().loggedUser!;

  ITweetController tweetController = TweetController();
  TextEditingController tweetTextController = TextEditingController();
  late bool disabledTweetButton;
  bool? canRetweet = true;

  void publishTweet() {
    tweetController.publishTweet(
      text: tweetTextController.text,
      canRetweet: canRetweet ?? false,
    );

    widget.goToHomeScreen();
  }

  void disabledButton() {
    setState(() {
      disabledTweetButton = tweetTextController.text.isEmpty;
    });
  }

  void setCanRetweet(bool? value) {
    setState(() {
      canRetweet = value;
    });
  }

  @override
  void initState() {
    tweetTextController.text = "";
    disabledTweetButton = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
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
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Checkbox(
                      activeColor: ColorConsts.primaryColor,
                      value: canRetweet,
                      onChanged: (bool? value) => setCanRetweet(value),
                    ),
                    GestureDetector(
                      onTap: () => setCanRetweet(
                        canRetweet != null ? !canRetweet! : true,
                      ),
                      child: const Text(
                        "Pode retweetar",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: tweetTextController,
                  onChanged: (value) => disabledButton(),
                  decoration: InputDecoration(
                    icon: ProfilePhotoWidget(
                      photoUrl: loggedUser.photoUrl,
                      size: 35,
                    ),
                    border: InputBorder.none,
                    hintText: "Como você está?",
                  ),
                  maxLines: null,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  maxLength: 280,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
