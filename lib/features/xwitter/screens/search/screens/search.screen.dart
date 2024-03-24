import 'package:flutter/material.dart';
import 'package:xwitter/common/widgets/bottom_navigation_bar.widget.dart';
import 'package:xwitter/common/widgets/create_tweet_button.widget.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text("Search Screen"),
      ),
      floatingActionButton: const CreateTweetButtonWidget(),
      bottomNavigationBar: const BottomNavigationBarWidget(currentIndex: 0),
    );
  }
}
