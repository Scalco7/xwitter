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
    this.user,
    this.userId,
  });
  final UserModel? user;
  final String? userId;

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

  UserModel? user;
  String buttonText = "";
  bool isMyAccount = false;

  Future<void> initData(bool doSetState) async {
    userDataLists = await userController.getUserData(
        userId: (widget.user?.id ?? widget.userId)!);
    if (userDataLists == null) return;

    setTweetsList(EListTweetsSection.publishedtTweets);

    if (!doSetState) {
      user = userDataLists!.user;
      return;
    }

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
      if (user!.following) {
        unfollowUser();
      } else {
        followUser();
      }
    }
  }

  void followUser() async {
    UserModel newUser = await userService.followUser(user: user!);

    setState(() {
      user = newUser;
      buttonText = user!.following ? "Deixar de seguir" : "Seguir";
    });
  }

  void unfollowUser() async {
    UserModel newUser = await userService.unfollowUser(user: user!);

    setState(() {
      user = newUser;
      buttonText = user!.following ? "Deixar de seguir" : "Seguir";
    });
  }

  bool dataIsLoaded() {
    return userDataLists != null;
  }

  void setScreenData() async {
    if (widget.user == null) {
      await initData(false);
    } else if (!dataIsLoaded()) {
      user = widget.user;
      initData(true);
    }

    String followButtonText = user!.id == loggedUserId
        ? "Editar"
        : user!.following
            ? "Deixar de seguir"
            : "Seguir";

    print("************************************************");
    print(followButtonText);
    print(user!.id);

    bool newIsMyAccount = user!.id == loggedUserId;

    setState(() {
      user = user!;
      isMyAccount = newIsMyAccount;
      buttonText = followButtonText;
    });
  }

  @override
  void initState() {
    setScreenData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: UserAppBarWidget(
        text: "@${user?.username ?? ""}",
        height: appBarHeight,
        showActions: user == null
            ? false
            : isMyAccount && routeController.indexNavBar == 2,
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
              user == null
                  ? SizedBox(
                      width: screenWidth,
                      height: 230,
                    )
                  : UserDataWidget(
                      user: user!,
                      avatarHeight: avatarHeight,
                      editUser: onClickButton,
                      buttonText: buttonText,
                    ),
              const SizedBox(height: 20),
              ChangeSectionButtonWidget(
                onChange: setTweetsList,
                disabled: !dataIsLoaded(),
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
