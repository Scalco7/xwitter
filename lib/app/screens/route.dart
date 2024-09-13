import 'package:flutter/material.dart';
import 'package:xwitter/app/common/controllers/user.controller.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/common/widgets/bottom_navigation_bar.widget.dart';
import 'package:xwitter/app/screens/auth/container/sign_in.container.dart';
import 'package:xwitter/app/screens/auth/screens/sign_up.screen.dart';
import 'package:xwitter/app/screens/create_tweet/screens/create_tweet.screen.dart';
import 'package:xwitter/app/screens/edit_user/screens/edit_user.screen.dart';
import 'package:xwitter/app/screens/home/screens/home.screen.dart';
import 'package:xwitter/app/screens/search/screens/search.screen.dart';
import 'package:xwitter/app/screens/settings/screens/settings.screen.dart';
import 'package:xwitter/app/screens/tweet/screens/tweet.screen.dart';
import 'package:xwitter/app/screens/user/screens/user.screen.dart';

class BigTalkRoute extends StatelessWidget {
  const BigTalkRoute({super.key});

  @override
  Widget build(BuildContext context) {
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
          arguments: userController.loggedUser!,
        );
      },
    );

    void routePop(BuildContext context) => Navigator.of(context).pop();

    void goToUserScreen(BuildContext context, UserModel user) =>
        Navigator.of(context).pushNamed("/user", arguments: user);

    void goToTweetDetailsScreen(BuildContext context, TweetModel tweet) =>
        Navigator.of(context).pushNamed("/tweet", arguments: tweet);

    void goToSettingsScreen(BuildContext context) =>
        Navigator.of(context).pushNamed("/settings");

    void goToHomeScreen(BuildContext context) => Navigator.of(context)
        .pushNamedAndRemoveUntil("/home", (route) => false);

    void updateUserScreenAfterEdit(BuildContext context, UserModel user) =>
        Navigator.of(context).pushNamedAndRemoveUntil("/user", (route) => false,
            arguments: user);

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
              ),
            );
          }
          if (settings.name == "/sign-up") {
            return MaterialPageRoute(
              builder: (context) => SignUpScreen(
                routePop: () => routePop(context),
                goToHomeScreen: () => goToHomeScreen(context),
              ),
            );
          }
        } else {
          if (settings.name == "/home") {
            return MaterialPageRoute(
              builder: (context) {
                return HomeScreen(
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
                goToUserScreen: (user) => goToUserScreen(context, user),
                bottomNavigationRoutes: bottomNavigationRoutes,
              ),
            );
          }
          if (settings.name == "/user") {
            return MaterialPageRoute(
              builder: (context) {
                return UserScreen(
                  user: settings.arguments as UserModel,
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
                routePop: () => routePop(context),
                updateUserScreen: (user) =>
                    updateUserScreenAfterEdit(context, user),
                bottomNavigationRoutes: bottomNavigationRoutes,
              ),
            );
          }
          if (settings.name == "/create-tweet") {
            return MaterialPageRoute(
              builder: (context) => CreateTweetScreen(
                routePop: () => routePop(context),
                goToHomeScreen: () => goToHomeScreen(context),
              ),
            );
          }
          if (settings.name == "/tweet") {
            TweetModel tweet = settings.arguments as TweetModel;

            return MaterialPageRoute(
              builder: (context) => TweetScreen(
                tweet: tweet,
                indexNavBar: indexNavBar,
                goToUserScreen: (user) => goToUserScreen(context, user),
                routePop: () => routePop(context),
                bottomNavigationRoutes: bottomNavigationRoutes,
              ),
            );
          }
          if (settings.name == "/settings") {
            return MaterialPageRoute(
              builder: (context) {
                return SettingsScreen(
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
