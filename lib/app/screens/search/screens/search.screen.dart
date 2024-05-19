import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/common/services/user.service.dart';
import 'package:xwitter/app/common/widgets/bottom_navigation_bar.widget.dart';
import 'package:xwitter/app/common/widgets/create_tweet_button.widget.dart';
import 'package:xwitter/app/screens/search/widgets/search.widget.dart';
import 'package:xwitter/app/common/widgets/user.widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    required this.goToUserScreen,
    required this.bottomNavigationRoutes,
  });
  final void Function(String userId) goToUserScreen;
  final BottomNavigationRoutesModel bottomNavigationRoutes;

  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  IUserService userService = UserService();
  List<UserModel> listUsers = [];

  void search(String searchText) async {
    List<UserModel> newList =
        await userService.listUsersByText(text: searchText);

    setState(() {
      listUsers = newList;
    });
  }

  void onClickUser(String acessedUserId) {
    widget.goToUserScreen(acessedUserId);
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
            SearchWidget(onSubmitted: search),
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
            Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    key: Key("search-user-${listUsers[index].id}"),
                    onTap: () => onClickUser(listUsers[index].id),
                    child: UserWidget(user: listUsers[index]),
                  );
                },
                itemCount: listUsers.length,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const CreateTweetButtonWidget(),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: 0,
        bottomNavigationRoutes: widget.bottomNavigationRoutes,
      ),
    );
  }
}
