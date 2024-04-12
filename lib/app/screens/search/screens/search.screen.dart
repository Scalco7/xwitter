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
    required this.user,
    required this.goToUserScreen,
    required this.bottomNavigationRoutes,
  });
  final UserModel user;
  final void Function(UserModel user) goToUserScreen;
  final BottomNavigationRoutesModel bottomNavigationRoutes;

  static UserModel searchUser = UserModel(
    id: "002",
    name: "Raphael Dias",
    nickname: "rapha",
    avatarPath: "assets/avatars/man_1.png",
    bio: "Olá eu sou o Rapha",
    numberOfFollowers: 209,
    numberOfFollowings: 10,
  );

  void searchFunction(String searchText) {
    print("pesquisando - $searchText");
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    void onClickUser(UserModel acessedUser) {
      print(
          "indo para a pagina de usuário do (passar usuário, dai n tem q pesquisar na api || a lista daqui só buscar o avatar path o nome e o @, dai o get de la pegar tds os dados) - ${acessedUser.name}");

      goToUserScreen(acessedUser);
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
            GestureDetector(
              onTap: () => onClickUser(searchUser),
              child: UserWidget(user: searchUser),
            ),
          ],
        ),
      ),
      floatingActionButton: const CreateTweetButtonWidget(),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: 0,
        user: user,
        bottomNavigationRoutes: bottomNavigationRoutes,
      ),
    );
  }
}
