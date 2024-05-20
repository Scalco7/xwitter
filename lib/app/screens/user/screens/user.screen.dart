import 'package:flutter/material.dart';
import 'package:xwitter/app/common/controllers/tweet.controller.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/common/services/user.service.dart';
import 'package:xwitter/app/common/widgets/bottom_navigation_bar.widget.dart';
import 'package:xwitter/app/common/widgets/create_tweet_button.widget.dart';
import 'package:xwitter/app/common/widgets/tweet.widget.dart';
import 'package:xwitter/app/common/widgets/user_app_bar.widget.dart';
import 'package:xwitter/app/screens/user/widgets/change_section_button.widget.dart';
import 'package:xwitter/app/screens/user/widgets/user_data.widget.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({
    super.key,
    required this.loggedUserId,
    required this.user,
    required this.postTweets,
    required this.indexNavBar,
    required this.likedTweets,
    required this.goToTweetDetailsScreen,
    required this.goToEditUserScreen,
    required this.goToSettingsScreen,
    required this.routePop,
    required this.bottomNavigationRoutes,
  });
  final String loggedUserId;
  final UserModel user;
  final int indexNavBar;
  final List<TweetModel> postTweets;
  final List<TweetModel> likedTweets;
  final void Function(TweetModel tweet) goToTweetDetailsScreen;
  final void Function() goToEditUserScreen;
  final void Function() goToSettingsScreen;
  final void Function() routePop;
  final BottomNavigationRoutesModel bottomNavigationRoutes;

  @override
  State<UserScreen> createState() => _UserScreen();
}

class _UserScreen extends State<UserScreen> {
  ITweetController tweetController = TweetController();
  IUserService userService = UserService();

  late List<TweetModel> tweetsList;
  late String buttonText;
  late UserModel user;
  late bool isMyAccount;

  void setTweetsList(EListTweetsSection state) {
    setState(() {
      tweetsList = state == EListTweetsSection.publishedtTweets
          ? widget.postTweets
          : widget.likedTweets;
    });
  }

  void onClickButton() {
    if (isMyAccount) {
      widget.goToEditUserScreen();
    } else {
      if (user.following) {
        unfollowUser();
      } else {
        followUser();
      }
    }
  }

  void followUser() async {
    UserModel newUser = await userService.followUser(
        user: user, loggedUserId: widget.loggedUserId);

    setState(() {
      user = newUser;
      buttonText = user.following ? "Deixar de seguir" : "Seguir";
    });
  }

  void unfollowUser() async {
    UserModel newUser = await userService.unfollowUser(
        user: user, loggedUserId: widget.loggedUserId);

    setState(() {
      user = newUser;
      buttonText = user.following ? "Deixar de seguir" : "Seguir";
    });
  }

  @override
  void initState() {
    user = widget.user;
    tweetsList = widget.postTweets;
    isMyAccount = user.id == widget.loggedUserId;

    if (isMyAccount) {
      buttonText = "Editar";
    } else {
      buttonText = user.following ? "Deixar de seguir" : "Seguir";
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
        nickname: user.nickname,
        height: appBarHeight,
        routePop: widget.routePop,
        goToSettingsScreen: isMyAccount ? widget.goToSettingsScreen : null,
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
                user: user,
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
                      key: Key("user-tweet-${tweetsList[index].id}"),
                      onTap: () =>
                          widget.goToTweetDetailsScreen(tweetsList[index]),
                      child: TweetWidget(
                        tweet: tweetsList[index],
                        hasComments: true,
                        onLikedTweet: ({required liked}) =>
                            tweetController.onLikedTweet(
                          loggedUserId: widget.loggedUserId,
                          tweet: tweetsList[index],
                          liked: liked,
                        ),
                      ),
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
        currentIndex: widget.indexNavBar,
        bottomNavigationRoutes: widget.bottomNavigationRoutes,
      ),
    );
  }
}
