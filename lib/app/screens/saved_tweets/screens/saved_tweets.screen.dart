import 'package:flutter/material.dart';
import 'package:xwitter/app/common/controllers/route.controller.dart';
import 'package:xwitter/app/common/controllers/user.controller.dart';
import 'package:xwitter/app/common/widgets/bottom_navigation_bar.widget.dart';
import 'package:xwitter/app/common/widgets/user_app_bar.widget.dart';
import 'package:xwitter/app/screens/saved_tweets/widgets/saved_tweets_list.widget.dart';

class SavedTweetsScreen extends StatelessWidget {
  const SavedTweetsScreen({super.key});

  static final RouteController routeController = RouteController();
  static final UserController userController = UserController();

  @override
  Widget build(BuildContext context) {
    const double appBarHeight = 64;

    return Scaffold(
      appBar: UserAppBarWidget(
        text: "Tweets Salvos",
        height: appBarHeight,
        showActions: false,
        routePop: () => routeController.goToUserScreenAndReload(
          context,
          userController.loggedUser!,
        ),
      ),
      body: const SavedTweetsListWidget(),
      bottomNavigationBar: const BottomNavigationBarWidget(currentIndex: 2),
    );
  }
}
