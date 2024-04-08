import 'package:flutter/material.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/common/widgets/bottom_navigation_bar.widget.dart';
import 'package:xwitter/app/common/widgets/create_tweet_button.widget.dart';
import 'package:xwitter/app/common/widgets/tweet.widget.dart';
import 'package:xwitter/app/common/widgets/user_app_bar.widget.dart';
import 'package:xwitter/app/screens/user/widgets/change_section_button.widget.dart';
import 'package:xwitter/app/screens/user/widgets/user_data.widget.dart';

enum EUserInteraction {
  myAccount,
  following,
  common,
}

class UserScreen extends StatefulWidget {
  const UserScreen({
    super.key,
    required this.user,
    required this.postTweets,
    required this.likedTweets,
    required this.accountOption,
  });

  final EUserInteraction accountOption;
  final UserModel user;
  final List<TweetModel> postTweets;
  final List<TweetModel> likedTweets;

  @override
  State<UserScreen> createState() => _UserScreen();
}

class _UserScreen extends State<UserScreen> {
  late List<TweetModel> tweetsList;
  late String buttonText;
  late int indexNavBar;

  void setTweetsList(EListTweetsSection state) {
    setState(() {
      tweetsList = state == EListTweetsSection.publishedtTweets
          ? widget.postTweets
          : widget.likedTweets;
    });
  }

  void onClickButton() {
    switch (widget.accountOption) {
      case EUserInteraction.myAccount:
        openEditUsercreen();
        break;
      case EUserInteraction.following:
        unfollowUser();
        break;
      case EUserInteraction.common:
        followUser();
        break;
    }
  }

  void openEditUsercreen() {
    Navigator.of(context).pushNamed("/edit-user");
  }

  void followUser() {
    print("Você começou a seguir o ${widget.user.name}");
  }

  void unfollowUser() {
    print("Você deixou de seguir o ${widget.user.name}");
  }

  @override
  void initState() {
    tweetsList = widget.postTweets;

    switch (widget.accountOption) {
      case EUserInteraction.myAccount:
        buttonText = "Editar";
        indexNavBar = 2;
        break;
      case EUserInteraction.following:
        buttonText = "Deixar de seguir";
        indexNavBar = 0;
        break;
      case EUserInteraction.common:
        buttonText = "Seguir";
        indexNavBar = 0;
        break;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    const double appBarHeight = 64;
    const double headerHeight = 16;
    const double avatarHeight = 70;

    return Scaffold(
      appBar: UserAppBarWidget(
        nickname: widget.user.nickname,
        height: appBarHeight,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            width: screenWidth,
            height: headerHeight,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(31, 31, 31, 1),
            ),
          ),
          Column(
            children: <Widget>[
              UserDataWidget(
                user: widget.user,
                avatarHeight: avatarHeight,
                editUser: onClickButton,
                buttonText: buttonText,
              ),
              const SizedBox(height: 20),
              ChangeSectionButtonWidget(
                onChange: setTweetsList,
              ),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () => Navigator.of(context)
                          .pushNamed("/tweet", arguments: tweetsList[index]),
                      child: TweetWidget(tweet: tweetsList[index]),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  itemCount: tweetsList.length,
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: const CreateTweetButtonWidget(),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: indexNavBar,
        user: widget.user,
      ),
    );
  }
}
