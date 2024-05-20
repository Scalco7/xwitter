import 'package:flutter/material.dart';
import 'package:xwitter/app/common/controllers/user.controller.dart';
import 'package:xwitter/app/common/error/failure.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/models/userData.interface.dart';
import 'package:xwitter/app/common/widgets/bottom_navigation_bar.widget.dart';
import 'package:xwitter/app/common/widgets/loading.widget.dart';
import 'package:xwitter/app/screens/user/screens/user.screen.dart';

class UserContainer extends StatelessWidget {
  const UserContainer({
    super.key,
    required this.userController,
    required this.userId,
    required this.indexNavBar,
    required this.goToTweetDetailsScreen,
    required this.goToEditUserScreen,
    required this.goToSettingsScreen,
    required this.routePop,
    required this.bottomNavigationRoutes,
  });

  final IUserController userController;
  final String userId;
  final int indexNavBar;
  final void Function(TweetModel tweet) goToTweetDetailsScreen;
  final void Function() goToEditUserScreen;
  final void Function() goToSettingsScreen;
  final void Function() routePop;
  final BottomNavigationRoutesModel bottomNavigationRoutes;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userController.getUserData(userId: userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        }
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          UserData userData = snapshot.data!;

          return UserScreen(
            loggedUserId: userController.loggedUser!.id,
            user: userData.user,
            postTweets: userData.postedTweets,
            indexNavBar: indexNavBar,
            likedTweets: userData.likedTweets,
            goToTweetDetailsScreen: goToTweetDetailsScreen,
            goToEditUserScreen: goToEditUserScreen,
            goToSettingsScreen: goToSettingsScreen,
            routePop: routePop,
            bottomNavigationRoutes: bottomNavigationRoutes,
          );
        }
        if (snapshot.hasError) {
          return ErrorWidget((snapshot.error as Failure).message!);
        }
        return Container();
      },
    );
  }
}
