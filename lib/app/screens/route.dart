import 'package:flutter/material.dart';
import 'package:xwitter/app/common/controllers/user.controller.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/common/services/tweet.service.dart';
import 'package:xwitter/app/common/widgets/bottom_navigation_bar.widget.dart';
import 'package:xwitter/app/screens/auth/screens/sign_in.screen.dart';
import 'package:xwitter/app/screens/auth/screens/sign_up.screen.dart';
import 'package:xwitter/app/screens/create_tweet/screens/create_tweet.screen.dart';
import 'package:xwitter/app/screens/edit_user/screens/edit_user.screen.dart';
import 'package:xwitter/app/screens/home/container/home.container.dart';
import 'package:xwitter/app/screens/search/screens/search.screen.dart';
import 'package:xwitter/app/screens/tweet/container/tweet.container.dart';
import 'package:xwitter/app/screens/user/container/user.container.dart';

class XWitterRoute extends StatelessWidget {
  const XWitterRoute({super.key});
  //tirar depois #################################################################################################

  static UserModel user = UserModel(
    id: "001",
    name: "Felipe Scalco",
    email: "fefe@gmail",
    nickname: "Scalco",
    avatarPath: "assets/avatars/batman.png",
    bio: "Olá eu sou o felipe",
    numberOfFollowers: 209,
    numberOfFollowings: 10,
  );
  static UserModel user2 = UserModel(
    id: "002",
    name: "Raphael Dias",
    email: "fefe@gmail",
    nickname: "rapha",
    avatarPath: "assets/avatars/man_1.png",
    bio: "Olá eu sou o Rapha",
    numberOfFollowers: 209,
    numberOfFollowings: 10,
  );
  static UserModel user3 = UserModel(
    id: "003",
    name: "Victor da Silva",
    email: "fefe@gmail",
    nickname: "Japones",
    avatarPath: "assets/avatars/man_2.png",
    bio: "Olá eu sou o Victor",
    numberOfFollowers: 209,
    numberOfFollowings: 10,
  );
  static TweetModel comment01 = TweetModel(
      id: "01",
      user: user2,
      tweet: "I prefer UX(I am Gay)",
      likes: 07,
      liked: false);
  static TweetModel comment02 = TweetModel(
      id: "02", user: user3, tweet: "I Hate gays", likes: 999, liked: true);
  static TweetModel comment03 = TweetModel(
      id: "03", user: user2, tweet: "Fuck You", likes: 1, liked: false);
  static TweetModel tweet1 = TweetModel(
    id: "001",
    user: user,
    tweet:
        "UXR/UX: You can only bring one item to a remote island to assist your research of native use of tools and usability. What do you bring? #TellMeAboutYou",
    likes: 2069,
    liked: true,
    comments: [
      comment01,
      comment02,
      comment03,
      comment01,
      comment02,
      comment03,
      comment01,
      comment02,
      comment03
    ],
  );
  static TweetModel tweet2 = TweetModel(
    id: "002",
    user: user2,
    tweet:
        "Kobe's passing is really sticking w/ me in a way I didn't expect. He was an icon, the kind of person who wouldn't die this way. My wife compared it to Princess Di's accident. But the end can happen for anyone at any time, & I can't help but think of anything else lately.",
    likes: 746,
    liked: true,
  );
  static TweetModel tweet3 = TweetModel(
    id: "003",
    user: user3,
    tweet:
        "Name a show where the lead character is the worst character on the show I'll get Sabrina Spellman",
    likes: 20,
    liked: true,
  );
  static TweetModel tweet4 = TweetModel(
    id: "004",
    user: user2,
    tweet:
        "Interesting Nicola that not one reply or tag on this #UX talent shout out in the 24hrs since your tweet here......🤔",
    likes: 1010,
    liked: true,
  );
  static TweetModel tweet5 = TweetModel(
    id: "005",
    user: user,
    tweet:
        "Quickly create a low-fi wireframe version of your web projects with ready-to-use layouts of Scheme Constructor.",
    likes: 0,
    liked: true,
  );
  static TweetModel tweet6 = TweetModel(
    id: "006",
    user: user3,
    tweet:
        "When we first launched Vector Mockups, I had wrote that in 2018 our free product downloads was 28K+ and we had set a goal to double this figure by the end of 2019. Today our team and I are glad to announce tgat we aave easily hit our goals with 47k+ downloads in 2019.",
    likes: 859,
    liked: true,
  );

  static List<TweetModel> tweets = [
    tweet1,
    tweet2,
    tweet3,
    tweet4,
    tweet5,
    tweet6
  ];

  //######################################################################################################

  @override
  Widget build(BuildContext context) {
    final ITweetService tweetService = TweetService();
    final IUserController userController = UserController();

    int indexNavBar = 1;

    final BottomNavigationRoutesModel bottomNavigationRoutes =
        BottomNavigationRoutesModel(
      goToSearchScreen: (BuildContext context) {
        indexNavBar = 0;
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/search", (route) => false);
      },
      goToHomeScreen: (BuildContext context) {
        indexNavBar = 1;
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/home", (route) => false);
      },
      goToUserScreen: (BuildContext context) {
        indexNavBar = 2;
        Navigator.of(context).pushNamedAndRemoveUntil(
          "/user",
          (route) => false,
          arguments: userController.loggedUser!.id,
        );
      },
    );

    void routePop(BuildContext context) => Navigator.of(context).pop();

    void goToUserScreen(BuildContext context, String userId) =>
        Navigator.of(context).pushNamed("/user", arguments: userId);

    void goToTweetDetailsScreen(BuildContext context, TweetModel tweet) =>
        Navigator.of(context).pushNamed("/tweet", arguments: tweet);

    void goToHomeScreen(BuildContext context) => Navigator.of(context)
        .pushNamedAndRemoveUntil("/home", (route) => false);

    void updateTweetScreen(BuildContext context, TweetModel tweet) =>
        Navigator.of(context).pushReplacementNamed("/tweet", arguments: tweet);

    void updateUserScreenAfterEdit(BuildContext context, String userId) =>
        Navigator.of(context).pushNamedAndRemoveUntil("/user", (route) => false,
            arguments: userId);

    return Navigator(
      initialRoute: "/sign-in",
      // ignore: body_might_complete_normally_nullable
      onGenerateRoute: (settings) {
        if (userController.loggedUser == null) {
          if (settings.name == "/sign-in") {
            return MaterialPageRoute(
              builder: (context) => SignInScreen(
                goToSignUpScreen: () =>
                    Navigator.of(context).pushNamed("/sign-up"),
                goToHomeScreen: () => goToHomeScreen(context),
                userController: userController,
              ),
            );
          }
          if (settings.name == "/sign-up") {
            return MaterialPageRoute(
              builder: (context) => SignUpScreen(
                routePop: () => routePop(context),
                goToHomeScreen: () => goToHomeScreen(context),
                userController: userController,
              ),
            );
          }
        } else {
          if (settings.name == "/home") {
            return MaterialPageRoute(
              builder: (context) {
                return HomeContainer(
                  service: tweetService,
                  loggedUserId: userController.loggedUser!.id,
                  goToTweetDetailsScreen: (tweet) =>
                      goToTweetDetailsScreen(context, tweet),
                  bottomNavigationRoutes: bottomNavigationRoutes,
                );
              },
            );
          }
          if (settings.name == "/search") {
            return MaterialPageRoute(
              builder: (context) => SearchScreen(
                goToUserScreen: (userId) => goToUserScreen(context, userId),
                bottomNavigationRoutes: bottomNavigationRoutes,
              ),
            );
          }
          if (settings.name == "/user") {
            //mexer
            return MaterialPageRoute(
              builder: (context) {
                return UserContainer(
                  userController: userController,
                  userId: settings.arguments as String,
                  indexNavBar: indexNavBar,
                  goToTweetDetailsScreen: (tweet) =>
                      goToTweetDetailsScreen(context, tweet),
                  goToEditUserScreen: () =>
                      Navigator.of(context).pushNamed("/edit-user"),
                  routePop: () => routePop(context),
                  bottomNavigationRoutes: bottomNavigationRoutes,
                );
              },
            );
          }
          if (settings.name == "/edit-user") {
            return MaterialPageRoute(
              builder: (context) => EditUserScreen(
                user: userController.loggedUser!,
                userController: userController,
                routePop: () => routePop(context),
                updateUserScreen: (userId) =>
                    updateUserScreenAfterEdit(context, userId),
                bottomNavigationRoutes: bottomNavigationRoutes,
              ),
            );
          }
          if (settings.name == "/create-tweet") {
            return MaterialPageRoute(
              builder: (context) => CreateTweetScreen(
                loggedUser: userController.loggedUser!,
                routePop: () => routePop(context),
                goToHomeScreen: () => goToHomeScreen(context),
              ),
            );
          }
          if (settings.name == "/tweet") {
            return MaterialPageRoute(
              builder: (context) => TweetContainer(
                service: tweetService,
                loggedUserId: userController.loggedUser!.id,
                tweet: settings.arguments as TweetModel,
                indexNavBar: indexNavBar,
                goToUserScreen: (userId) => goToUserScreen(context, userId),
                routePop: () => routePop(context),
                updateTweetScreen: ({required tweet}) =>
                    updateTweetScreen(context, tweet),
                bottomNavigationRoutes: bottomNavigationRoutes,
              ),
            );
          }
        }
      },
    );
  }
}
