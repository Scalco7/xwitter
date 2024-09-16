import 'package:flutter/material.dart';
import 'package:xwitter/app/common/widgets/bottom_navigation_bar.widget.dart';
import 'package:xwitter/app/common/widgets/create_tweet_button.widget.dart';
import 'package:xwitter/app/screens/home/widgets/home_app_bar.widget.dart';
import 'package:xwitter/app/screens/home/widgets/tweets_list.widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HomeAppBarWidget(),
      body: TweetsListWidget(),
      floatingActionButton: CreateTweetButtonWidget(),
      bottomNavigationBar: BottomNavigationBarWidget(currentIndex: 1),
    );
  }
}
