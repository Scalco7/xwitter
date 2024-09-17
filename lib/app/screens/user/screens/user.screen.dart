import 'package:flutter/material.dart';
import 'package:xwitter/app/common/controllers/route.controller.dart';
import 'package:xwitter/app/common/controllers/user.controller.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/common/models/user_data.model.dart';
import 'package:xwitter/app/common/services/user.service.dart';
import 'package:xwitter/app/common/widgets/bottom_navigation_bar.widget.dart';
import 'package:xwitter/app/common/widgets/create_tweet_button.widget.dart';
import 'package:xwitter/app/common/widgets/user_app_bar.widget.dart';
import 'package:xwitter/app/screens/user/widgets/change_section_button.widget.dart';
import 'package:xwitter/app/screens/user/widgets/user_data.widget.dart';
import 'package:xwitter/app/screens/user/widgets/user_lists_widget.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({
    super.key,
    required this.user,
  });
  final UserModel user;

  @override
  State<UserScreen> createState() => _UserScreen();
}

class _UserScreen extends State<UserScreen> {
  static final RouteController routeController = RouteController();
  static final IUserController userController = UserController();
  static final IUserService userService = UserService();

  final loggedUserId = UserController().loggedUser!.id;

  static const double appBarHeight = 64;
  static const double headerHeight = 16;
  static const double avatarHeight = 70;

  UserData? userDataLists;
  List<TweetModel> tweetsList = [];

  EListTweetsSection actualListState = EListTweetsSection.publishedtTweets;

  late String buttonText;
  late UserModel user;
  late bool isMyAccount;

  void reloadPage() {
    setState(() {});
  }

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
      actualListState = state;
      tweetsList = actualListState == EListTweetsSection.publishedtTweets
          ? userDataLists!.postedTweets
          : userDataLists!.likedTweets;
    });
  }

  void onClickButton() {
    if (isMyAccount) {
      routeController.goToEditUserScreen(context);
    } else {
      if (user.following) {
        unfollowUser();
      } else {
        followUser();
      }
    }
  }

  void followUser() async {
    UserModel newUser = await userService.followUser(user: user);

    setState(() {
      user = newUser;
      buttonText = user.following ? "Deixar de seguir" : "Seguir";
    });
  }

  void unfollowUser() async {
    UserModel newUser = await userService.unfollowUser(user: user);

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

    return Scaffold(
      appBar: UserAppBarWidget(
        text: "@${user.username}",
        height: appBarHeight,
        showActions: isMyAccount && routeController.indexNavBar == 2,
        routePop: () => routeController.routePop(context),
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
              UserListsWidget(
                tweetsList: tweetsList,
                actualListState: actualListState,
                setTweetsList: setTweetsList,
                userDataLists: userDataLists,
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: const CreateTweetButtonWidget(),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: routeController.indexNavBar,
      ),
    );
  }
}
