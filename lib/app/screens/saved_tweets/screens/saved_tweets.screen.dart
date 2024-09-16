import 'package:flutter/material.dart';
import 'package:xwitter/app/common/widgets/bottom_navigation_bar.widget.dart';
import 'package:xwitter/app/common/widgets/user_app_bar.widget.dart';
import 'package:xwitter/app/screens/saved_tweets/widgets/saved_tweets_list.widget.dart';

class SavedTweetsScreen extends StatelessWidget {
  const SavedTweetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double appBarHeight = 64;

    return const Scaffold(
      appBar: UserAppBarWidget(
        text: "Tweets Salvos",
        height: appBarHeight,
        showActions: false,
      ),
      body: SavedTweetsListWidget(),
      bottomNavigationBar: BottomNavigationBarWidget(currentIndex: 2),
    );
  }
}
