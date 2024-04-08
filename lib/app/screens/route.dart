import 'package:flutter/material.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/screens/auth/screens/sign_in.screen.dart';
import 'package:xwitter/app/screens/auth/screens/sign_up.screen.dart';
import 'package:xwitter/app/screens/create_tweet/screens/create_tweet.screen.dart';
import 'package:xwitter/app/screens/edit_user/screens/edit_user.screen.dart';
import 'package:xwitter/app/screens/home/screens/home.screen.dart';
import 'package:xwitter/app/screens/search/screens/search.screen.dart';
import 'package:xwitter/app/screens/tweet/screens/tweet.screen.dart';
import 'package:xwitter/app/screens/user/screens/user.screen.dart';

class XWitterRoute extends StatelessWidget {
  const XWitterRoute({super.key});

  //tirar depois #################################################################################################

  static UserModel user = UserModel(
    id: "001",
    name: "Felipe Scalco",
    nickname: "Scalco",
    avatarPath: "assets/avatars/batman.png",
    bio: "Olá eu sou o felipe",
    numberOfFollowers: 209,
    numberOfFollowings: 10,
  );
  static UserModel user2 = UserModel(
    id: "002",
    name: "Raphael Dias",
    nickname: "rapha",
    avatarPath: "assets/avatars/man_1.png",
    bio: "Olá eu sou o Rapha",
    numberOfFollowers: 209,
    numberOfFollowings: 10,
  );
  static UserModel user3 = UserModel(
    id: "003",
    name: "Victor da Silva",
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
    return Navigator(
      initialRoute: "/sign-in",
      onGenerateRoute: (settings) {
        if (settings.name == "/sign-in") {
          return MaterialPageRoute(
            builder: (context) => const SignInScreen(),
          );
        }
        if (settings.name == "/sign-up") {
          return MaterialPageRoute(
            builder: (context) => const SignUpScreen(),
          );
        }
        if (settings.name == "/home") {
          return MaterialPageRoute(
            builder: (context) => HomeScreen(
              tweets: tweets,
              user: user,
            ),
          );
        }
        if (settings.name == "/search") {
          return MaterialPageRoute(
            builder: (context) => SearchScreen(user: user),
          );
        }
        if (settings.name == "/user") {
          //mexer
          return MaterialPageRoute(
            builder: (context) {
              UserModel navigationUser = settings.arguments as UserModel;
              int indexNavBar = 0;

              EUserInteraction accountOption =
                  EUserInteraction.common; //pgar se segue o cara pela api

              if (user == navigationUser) {
                accountOption = EUserInteraction.myAccount;
                indexNavBar = 2;
              }

              return UserScreen(
                user: navigationUser,
                indexNavBar: indexNavBar,
                postTweets: tweets
                    .where((t) => t.user.id == navigationUser.id)
                    .toList(),
                likedTweets:
                    tweets.where((t) => t.liked).toList(), //trocar isso
                accountOption: accountOption,
              );
            },
          );
        }
        if (settings.name == "/edit-user") {
          return MaterialPageRoute(
            builder: (context) => EditUserScreen(user: user),
          );
        }
        if (settings.name == "/create-tweet") {
          return MaterialPageRoute(
            builder: (context) => const CreateTweetScreen(),
          );
        }
        if (settings.name == "/tweet") {
          return MaterialPageRoute(
            builder: (context) => TweetScreen(
              tweet: settings.arguments as TweetModel,
            ),
          );
        }
      },
    );
  }
}
