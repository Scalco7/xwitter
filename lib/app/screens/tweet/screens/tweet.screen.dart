import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/common/widgets/bottom_navigation_bar.widget.dart';
import 'package:xwitter/app/common/widgets/tweet.widget.dart';
import 'package:xwitter/app/screens/tweet/widgets/tweet_app_bar.widget.dart';
import 'package:xwitter/app/screens/tweet/widgets/tweet_details.widget.dart';

class TweetScreen extends StatefulWidget {
  const TweetScreen({
    super.key,
    required this.tweet,
    required this.indexNavBar,
    required this.goToUserScreen,
    required this.routePop,
    required this.bottomNavigationRoutes,
  });
  final TweetModel tweet;
  final int indexNavBar;
  final void Function(UserModel user) goToUserScreen;
  final void Function() routePop;
  final BottomNavigationRoutesModel bottomNavigationRoutes;

  @override
  State<StatefulWidget> createState() => _TweetScreen();
}

class _TweetScreen extends State<TweetScreen> {
  String commentText = "";
  InputBorder inputBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(30)),
    borderSide: BorderSide(
      color: Colors.transparent,
      width: 0,
    ),
  );

  void disableKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void commentOnTweet(String text) {
    print("Comentou: $text");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConsts.backgroundColor,
      appBar: TweetAppBarWidget(routePop: widget.routePop),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TweetDetailsWidget(
                    tweet: widget.tweet,
                    goToUserScreen: widget.goToUserScreen,
                  ),
                  Visibility(
                    visible: widget.tweet.comments != null,
                    child: Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        decoration: const BoxDecoration(color: Colors.white),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.tweet.comments?.length,
                          itemBuilder: (BuildContext context, int index) {
                            TweetModel comment = widget.tweet.comments![index];
                            return GestureDetector(
                              onTap: () => widget.goToUserScreen(comment.user),
                              child: TweetWidget(tweet: comment),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onTapOutside: (event) => disableKeyboard(),
                      onChanged: (value) => commentText = value,
                      onSubmitted: (value) => commentOnTweet(value),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: "Comentar",
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 0),
                        filled: true,
                        fillColor: ColorConsts.backgroundColor,
                        border: inputBorder,
                        errorBorder: inputBorder,
                        enabledBorder: inputBorder,
                        focusedBorder: inputBorder,
                        disabledBorder: inputBorder,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  IconButton(
                    onPressed: () => commentOnTweet(commentText),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(
                          ColorConsts.primaryColor),
                    ),
                    icon: const Icon(
                      Icons.add_comment_rounded,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: widget.indexNavBar,
        bottomNavigationRoutes: widget.bottomNavigationRoutes,
      ),
    );
  }
}
