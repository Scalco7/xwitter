import 'package:flutter/material.dart';
import 'package:xwitter/app/common/controllers/user.controller.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/screens/auth/container/sign_in.container.dart';
import 'package:xwitter/app/screens/auth/screens/sign_up.screen.dart';
import 'package:xwitter/app/screens/create_tweet/screens/create_tweet.screen.dart';
import 'package:xwitter/app/screens/edit_user/screens/edit_user.screen.dart';
import 'package:xwitter/app/screens/home/screens/home.screen.dart';
import 'package:xwitter/app/screens/saved_tweets/screens/saved_tweets.screen.dart';
import 'package:xwitter/app/screens/search/screens/search.screen.dart';
import 'package:xwitter/app/screens/search_location/screens/search_location.screen.dart';
import 'package:xwitter/app/screens/settings/screens/settings.screen.dart';
import 'package:xwitter/app/screens/tweet/screens/tweet.screen.dart';
import 'package:xwitter/app/screens/user/screens/user.screen.dart';

class BigTalkRoute extends StatelessWidget {
  const BigTalkRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final IUserController userController = UserController();

    return Navigator(
      initialRoute: "/sign-in",
      // ignore: body_might_complete_normally_nullable
      onGenerateRoute: (settings) {
        if (userController.loggedUser == null) {
          if (settings.name == "/sign-in") {
            return MaterialPageRoute(
              builder: (context) => const SignInContainer(),
            );
          }
          if (settings.name == "/sign-up") {
            return MaterialPageRoute(
              builder: (context) => const SignUpScreen(),
            );
          }
        } else {
          if (settings.name == "/home") {
            return MaterialPageRoute(
              builder: (context) {
                return const HomeScreen();
              },
            );
          }
          if (settings.name == "/search") {
            return MaterialPageRoute(
              builder: (context) => const SearchScreen(),
            );
          }
          if (settings.name == "/search-location") {
            return MaterialPageRoute(
              builder: (context) => SearchLocationScreen(
                setLocation:
                    settings.arguments as void Function(String? location),
              ),
            );
          }
          if (settings.name == "/user") {
            return MaterialPageRoute(
              builder: (context) {
                UserModel? user = settings.arguments.runtimeType == UserModel
                    ? settings.arguments as UserModel
                    : null;
                String? userId = settings.arguments.runtimeType == String
                    ? settings.arguments as String
                    : null;

                return UserScreen(
                  user: user,
                  userId: userId,
                );
              },
            );
          }
          if (settings.name == "/edit-user") {
            return MaterialPageRoute(
              builder: (context) => const EditUserScreen(),
            );
          }
          if (settings.name == "/create-tweet") {
            return MaterialPageRoute(
              builder: (context) => const CreateTweetScreen(),
            );
          }
          if (settings.name == "/tweet") {
            TweetModel tweet = settings.arguments as TweetModel;

            return MaterialPageRoute(
              builder: (context) => TweetScreen(tweet: tweet),
            );
          }
          if (settings.name == "/settings") {
            return MaterialPageRoute(
              builder: (context) {
                return const SettingsScreen();
              },
            );
          }
          if (settings.name == "/saved-tweets") {
            return MaterialPageRoute(
              builder: (context) {
                return const SavedTweetsScreen();
              },
            );
          }
        }
      },
    );
  }
}
