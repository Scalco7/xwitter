import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/common/widgets/bottom_navigation_bar.widget.dart';
import 'package:xwitter/app/common/widgets/create_tweet_button.widget.dart';
import 'package:xwitter/app/screens/search/widgets/search.widget.dart';
import 'package:xwitter/app/screens/search/widgets/user.widget.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  static UserModel user = UserModel(
    id: "001",
    name: "Felipe Scalco",
    nickname: "Scalco",
    avatarPath: "assets/avatars/batman.png",
    bio: "Olá eu sou o felipe",
    numberOfFollowers: 209,
    numberOfFollowings: 10,
  );

  void searchFunction(String searchText) {
    print("pesquisando - $searchText");
  }

  void goToUserScreen(UserModel user) {
    print("indo para a conta do - ${user.name}");
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
            SizedBox(
              width: screenWidth,
              height: 50,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Text(
                  "Search",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: ColorConsts.secondaryColor,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            UserWidget(user: user, onTapUser: goToUserScreen)
          ],
        ),
      ),
      floatingActionButton: const CreateTweetButtonWidget(),
      bottomNavigationBar: const BottomNavigationBarWidget(currentIndex: 0),
    );
  }
}
