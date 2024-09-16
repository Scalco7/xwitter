import 'package:flutter/material.dart';
import 'package:xwitter/app/common/controllers/user.controller.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/common/widgets/bottom_navigation_bar.widget.dart';

class RouteController {
  static final RouteController _singleton = RouteController._internal();
  static final IUserController userController = UserController();

  RouteController._internal();

  factory RouteController() {
    return _singleton;
  }

  static int _indexNavBar = 1;
  final BottomNavigationRoutesModel bottomNavigationRoutes =
      BottomNavigationRoutesModel(
    goToSearchScreen: (BuildContext context) {
      _indexNavBar = 0;
      Navigator.of(context)
          .pushNamedAndRemoveUntil("/search", (route) => false);
    },
    goToHomeScreen: (BuildContext context) {
      _indexNavBar = 1;
      Navigator.of(context).pushNamedAndRemoveUntil("/home", (route) => false);
    },
    goToUserScreen: (BuildContext context) {
      _indexNavBar = 2;
      Navigator.of(context).pushNamedAndRemoveUntil(
        "/user",
        (route) => false,
        arguments: userController.loggedUser!,
      );
    },
  );

  int get indexNavBar => _indexNavBar;

  String actualRouteName = "sign-in";
  String lastRouteName = "";

  void routePop(BuildContext context) => Navigator.of(context).pop();

  void goToUserScreen(BuildContext context, UserModel user) =>
      Navigator.of(context).pushNamed("/user", arguments: user);

  // void routePopFromTweetDetails

  void goToTweetDetailsScreen(
      BuildContext context, /*String actualRouteName,*/ TweetModel tweet) {
    Navigator.of(context).pushNamed("/tweet", arguments: tweet);
  }

  void goToSearchLocationScreen(
    BuildContext context,
    void Function(String? location) setLocation,
  ) =>
      Navigator.of(context)
          .pushNamed("/search-location", arguments: setLocation);

  void goToSettingsScreen(BuildContext context) =>
      Navigator.of(context).pushNamed("/settings");

  void goToSavedTweetsScreen(BuildContext context) =>
      Navigator.of(context).pushNamed("/saved-tweets");

  void goToHomeScreen(BuildContext context) =>
      Navigator.of(context).pushNamedAndRemoveUntil("/home", (route) => false);

  void goToUserScreenAndReload(BuildContext context, UserModel user) =>
      Navigator.of(context)
          .pushNamedAndRemoveUntil("/user", (route) => false, arguments: user);

  void goToSignInScreen(BuildContext context) => Navigator.of(context)
      .pushNamedAndRemoveUntil("/sign-in", (route) => false);

  void goToEditUserScreen(BuildContext context) =>
      Navigator.of(context).pushNamed("/edit-user");

  void goToSignUpScreen(BuildContext context) =>
      Navigator.of(context).pushNamed("/sign-up");
}
