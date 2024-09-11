import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/controllers/tweet.controller.dart';
import 'package:xwitter/app/common/controllers/user.controller.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/common/models/user_data.model.dart';
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
    required this.user,
    required this.indexNavBar,
    required this.goToTweetDetailsScreen,
    required this.goToEditUserScreen,
    required this.goToSettingsScreen,
    required this.routePop,
    required this.bottomNavigationRoutes,
  });
  final UserModel user;
  final int indexNavBar;
  final void Function(TweetModel tweet) goToTweetDetailsScreen;
  final void Function() goToEditUserScreen;
  final void Function() goToSettingsScreen;
  final void Function() routePop;
  final BottomNavigationRoutesModel bottomNavigationRoutes;

  @override
  State<UserScreen> createState() => _UserScreen();
}

class _UserScreen extends State<UserScreen> {
  final IUserController userController = UserController();
  final ITweetController tweetController = TweetController();
  final IUserService userService = UserService();

  final loggedUserId = UserController().loggedUser!.id;

  UserData? userDataLists;
  List<TweetModel> tweetsList = [];

  late String buttonText;
  late UserModel user;
  late bool isMyAccount;

  void initLists() async {
    userDataLists = await userController.getUserData(oldUser: widget.user);
    if (userDataLists == null) return;

    setTweetsList(EListTweetsSection.publishedtTweets);
    setState(() {
      user = userDataLists!.user;
    });
  }

  void setTweetsList(EListTweetsSection state) {
    if (userDataLists == null) return;

    setState(() {
      tweetsList = state == EListTweetsSection.publishedtTweets
          ? userDataLists!.postedTweets
          : userDataLists!.likedTweets;
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
      user: user,
      loggedUserId: loggedUserId,
    );

    setState(() {
      user = newUser;
      buttonText = user.following ? "Deixar de seguir" : "Seguir";
    });
  }

  void unfollowUser() async {
    UserModel newUser = await userService.unfollowUser(
      user: user,
      loggedUserId: loggedUserId,
    );

    setState(() {
      user = newUser;
      buttonText = user.following ? "Deixar de seguir" : "Seguir";
    });
  }

  bool listsIsLoaded() {
    return userDataLists != null;
  }

  @override
  void initState() {
    if (!listsIsLoaded()) initLists();

    user = widget.user;
    isMyAccount = user.id == loggedUserId;

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
                disabled: !listsIsLoaded(),
              ),
              Expanded(
                child: !listsIsLoaded()
                    ? const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: CircularProgressIndicator(
                            color: ColorConsts.primaryColor,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            key: Key("user-tweet-${tweetsList[index].id}"),
                            onTap: () => widget
                                .goToTweetDetailsScreen(tweetsList[index]),
                            child: TweetWidget(
                              tweet: tweetsList[index],
                              hasComments: true,
                              onLikedTweet: ({required liked}) =>
                                  tweetController.onLikedTweet(
                                loggedUserId: loggedUserId,
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
