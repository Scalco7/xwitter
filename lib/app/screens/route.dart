import 'package:flutter/material.dart';
import 'package:xwitter/app/common/controllers/user.controller.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/services/tweet.service.dart';
import 'package:xwitter/app/common/widgets/bottom_navigation_bar.widget.dart';
import 'package:xwitter/app/screens/auth/container/sign_in.container.dart';
import 'package:xwitter/app/screens/auth/screens/sign_up.screen.dart';
import 'package:xwitter/app/screens/create_tweet/screens/create_tweet.screen.dart';
import 'package:xwitter/app/screens/edit_user/screens/edit_user.screen.dart';
import 'package:xwitter/app/screens/home/container/home.container.dart';
import 'package:xwitter/app/screens/search/screens/search.screen.dart';
import 'package:xwitter/app/screens/settings/screens/settings.screen.dart';
import 'package:xwitter/app/screens/tweet/container/tweet.container.dart';
import 'package:xwitter/app/screens/user/container/user.container.dart';

class BigTalkRoute extends StatelessWidget {
  const BigTalkRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final ITweetService tweetService = TweetService();
    final IUserController userController = UserController();

    int indexNavBar = 1;

    final BottomNavigationRoutesModel bottomNavigationRoutes =
        BottomNavigationRoutesModel(
      goToSearchScreen: (BuildContext context) {
        indexNavBar = 0;
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/search", (route) => false);
      },
      goToHomeScreen: (BuildContext context) {
        indexNavBar = 1;
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/home", (route) => false);
      },
      goToUserScreen: (BuildContext context) {
        indexNavBar = 2;
        Navigator.of(context).pushNamedAndRemoveUntil(
          "/user",
          (route) => false,
          arguments: userController.loggedUser!.id,
        );
      },
    );

    void routePop(BuildContext context) => Navigator.of(context).pop();

    void goToUserScreen(BuildContext context, String userId) =>
        Navigator.of(context).pushNamed("/user", arguments: userId);

    void goToTweetDetailsScreen(BuildContext context, TweetModel tweet) =>
        Navigator.of(context).pushNamed("/tweet", arguments: tweet);

    void goToSettingsScreen(BuildContext context) =>
        Navigator.of(context).pushNamed("/settings");

    void goToHomeScreen(BuildContext context) => Navigator.of(context)
        .pushNamedAndRemoveUntil("/home", (route) => false);

    void updateTweetScreen(BuildContext context, TweetModel tweet) =>
        Navigator.of(context).pushReplacementNamed("/tweet", arguments: tweet);

    void updateUserScreenAfterEdit(BuildContext context, String userId) =>
        Navigator.of(context).pushNamedAndRemoveUntil("/user", (route) => false,
            arguments: userId);

    void goToSignInScreen(BuildContext context) => Navigator.of(context)
        .pushNamedAndRemoveUntil("/sign-in", (route) => false);

    return Navigator(
      initialRoute: "/sign-in",
      // ignore: body_might_complete_normally_nullable
      onGenerateRoute: (settings) {
        if (userController.loggedUser == null) {
          if (settings.name == "/sign-in") {
            return MaterialPageRoute(
              builder: (context) => SignInContainer(
                goToSignUpScreen: () =>
                    Navigator.of(context).pushNamed("/sign-up"),
                goToHomeScreen: () => goToHomeScreen(context),
                userController: userController,
              ),
            );
          }
          if (settings.name == "/sign-up") {
            return MaterialPageRoute(
              builder: (context) => SignUpScreen(
                routePop: () => routePop(context),
                goToHomeScreen: () => goToHomeScreen(context),
                userController: userController,
              ),
            );
          }
        } else {
          if (settings.name == "/home") {
            return MaterialPageRoute(
              builder: (context) {
                return HomeContainer(
                  service: tweetService,
                  loggedUserId: userController.loggedUser!.id,
                  goToTweetDetailsScreen: (tweet) =>
                      goToTweetDetailsScreen(context, tweet),
                  bottomNavigationRoutes: bottomNavigationRoutes,
                );
              },
            );
          }
          if (settings.name == "/search") {
            return MaterialPageRoute(
              builder: (context) => SearchScreen(
                goToUserScreen: (userId) => goToUserScreen(context, userId),
                bottomNavigationRoutes: bottomNavigationRoutes,
              ),
            );
          }
          if (settings.name == "/user") {
            return MaterialPageRoute(
              builder: (context) {
                return UserContainer(
                  userController: userController,
                  userId: settings.arguments as String,
                  indexNavBar: indexNavBar,
                  goToTweetDetailsScreen: (tweet) =>
                      goToTweetDetailsScreen(context, tweet),
                  goToEditUserScreen: () =>
                      Navigator.of(context).pushNamed("/edit-user"),
                  goToSettingsScreen: () => goToSettingsScreen(context),
                  routePop: () => routePop(context),
                  bottomNavigationRoutes: bottomNavigationRoutes,
                );
              },
            );
          }
          if (settings.name == "/edit-user") {
            return MaterialPageRoute(
              builder: (context) => EditUserScreen(
                user: userController.loggedUser!,
                userController: userController,
                routePop: () => routePop(context),
                updateUserScreen: (userId) =>
                    updateUserScreenAfterEdit(context, userId),
                bottomNavigationRoutes: bottomNavigationRoutes,
              ),
            );
          }
          if (settings.name == "/create-tweet") {
            return MaterialPageRoute(
              builder: (context) => CreateTweetScreen(
                loggedUser: userController.loggedUser!,
                routePop: () => routePop(context),
                goToHomeScreen: () => goToHomeScreen(context),
              ),
            );
          }
          if (settings.name == "/tweet") {
            return MaterialPageRoute(
              builder: (context) => TweetContainer(
                service: tweetService,
                loggedUserId: userController.loggedUser!.id,
                tweet: settings.arguments as TweetModel,
                indexNavBar: indexNavBar,
                goToUserScreen: (userId) => goToUserScreen(context, userId),
                routePop: () => routePop(context),
                updateTweetScreen: ({required tweet}) =>
                    updateTweetScreen(context, tweet),
                bottomNavigationRoutes: bottomNavigationRoutes,
              ),
            );
          }
          if (settings.name == "/settings") {
            return MaterialPageRoute(
              builder: (context) {
                return SettingsScreen(
                  userController: userController,
                  goToSignInScreen: () => goToSignInScreen(context),
                );
              },
            );
          }
        }
      },
    );
  }
}
