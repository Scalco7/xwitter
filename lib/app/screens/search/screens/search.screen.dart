import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/common/widgets/bottom_navigation_bar.widget.dart';
import 'package:xwitter/app/common/widgets/create_tweet_button.widget.dart';
import 'package:xwitter/app/screens/search/widgets/search.widget.dart';
import 'package:xwitter/app/common/widgets/user.widget.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({
    super.key,
    required this.goToUserScreen,
    required this.bottomNavigationRoutes,
  });
  final void Function(String userId) goToUserScreen;
  final BottomNavigationRoutesModel bottomNavigationRoutes;

  static UserModel searchUser = UserModel(
    id: "002",
    name: "Raphael Dias",
    email: "",
    nickname: "rapha",
    avatarPath: "assets/avatars/man_1.png",
    bio: "Olá eu sou o Rapha",
    numberOfFollowers: 209,
    numberOfFollowings: 10,
  );

  static List<UserModel> listUsers = [
    searchUser,
    searchUser,
    searchUser,
    searchUser,
    searchUser,
    searchUser,
    searchUser,
    searchUser,
    searchUser,
    searchUser,
    searchUser,
    searchUser
  ];

  void searchFunction(String searchText) {
    print("pesquisando - $searchText");
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    void onClickUser(String acessedUserId) {
      print(
          "indo para a pagina de usuário do (passar usuário, dai n tem q pesquisar na api || a lista daqui só buscar o avatar path o nome e o @, dai o get de la pegar tds os dados) - $acessedUserId");

      goToUserScreen(acessedUserId);
    }

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
        bottomNavigationRoutes: bottomNavigationRoutes,
      ),
    );
  }
}
