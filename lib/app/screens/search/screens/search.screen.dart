import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/widgets/bottom_navigation_bar.widget.dart';
import 'package:xwitter/app/common/widgets/create_tweet_button.widget.dart';
import 'package:xwitter/app/screens/search/widgets/search.widget.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  void searchFunction(String searchText) {
    print("pesquisando - $searchText");
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 0,
      ),
      body: Container(
        width: screenWidth,
        decoration: const BoxDecoration(color: ColorConsts.backgroundColor),
        child: Column(
          children: <Widget>[
            SearchWidget(onSubmitted: searchFunction),
          ],
        ),
      ),
      floatingActionButton: const CreateTweetButtonWidget(),
      bottomNavigationBar: const BottomNavigationBarWidget(currentIndex: 0),
    );
  }
}
