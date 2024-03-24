import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xwitter/common/consts/style.consts.dart';
import 'package:xwitter/common/models/tweet.model.dart';
import 'package:xwitter/common/models/user.model.dart';
import 'package:xwitter/common/widgets/bottom_navigation_bar.widget.dart';
import 'package:xwitter/common/widgets/create_tweet_button.widget.dart';
import 'package:xwitter/common/widgets/tweet.widget.dart';
import 'package:xwitter/features/xwitter/screens/create_tweet/screens/create_tweet.screen.dart';
import 'package:xwitter/features/xwitter/screens/home/screens/home.screen.dart';
import 'package:xwitter/features/xwitter/screens/home/widgets/home_app_bar.widget.dart';
import 'package:xwitter/features/xwitter/screens/search/screens/search.screen.dart';
import 'package:xwitter/features/xwitter/screens/user/screens/user.screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static UserModel user = UserModel(
    id: "001",
    name: "Felipe Scalco",
    nickname: "Scalco",
    avatarPath: "../",
    bio: "Olá eu sou o felipe",
    numberOfFollowers: 209,
    numberOfFollowings: 10,
  );
  static UserModel user2 = UserModel(
    id: "002",
    name: "Raphael Dias",
    nickname: "rapha",
    avatarPath: "../",
    bio: "Olá eu sou o Rapha",
    numberOfFollowers: 209,
    numberOfFollowings: 10,
  );
  static UserModel user3 = UserModel(
    id: "003",
    name: "Victor da Silva",
    nickname: "Japones",
    avatarPath: "../",
    bio: "Olá eu sou o Victor",
    numberOfFollowers: 209,
    numberOfFollowings: 10,
  );

  static TweetModel tweet = TweetModel(
    id: "001",
    user: user,
    tweet:
        "UXR/UX: You can only bring one item to a remote island to assist your research of native use of tools and usability. What do you bring? #TellMeAboutYou",
    likes: 2069,
    liked: true,
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

  static List<TweetModel> tweets = [
    tweet,
    tweet2,
    tweet3,
    tweet,
    tweet2,
    tweet,
    tweet2,
    tweet3
  ];
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ColorConsts.primaryColor),
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: "/home",
      routes: {
        "/home": (context) => HomeScreen(tweets: tweets),
        "/search": (context) => const SearchScreen(),
        "/user": (context) => const UserScreen(),
        "/create-tweet": (context) => const CreateTweetScreen(),
      },
    );
  }
}

class MyTestPage extends StatelessWidget {
  const MyTestPage({super.key});

  static UserModel user = UserModel(
    id: "001",
    name: "Felipe Scalco",
    nickname: "Scalco",
    avatarPath: "../",
    bio: "Olá eu sou o felipe",
    numberOfFollowers: 209,
    numberOfFollowings: 10,
  );
  static UserModel user2 = UserModel(
    id: "002",
    name: "Raphael Dias",
    nickname: "rapha",
    avatarPath: "../",
    bio: "Olá eu sou o Rapha",
    numberOfFollowers: 209,
    numberOfFollowings: 10,
  );
  static UserModel user3 = UserModel(
    id: "003",
    name: "Victor da Silva",
    nickname: "Japones",
    avatarPath: "../",
    bio: "Olá eu sou o Victor",
    numberOfFollowers: 209,
    numberOfFollowings: 10,
  );

  static TweetModel tweet = TweetModel(
    id: "001",
    user: user,
    tweet:
        "UXR/UX: You can only bring one item to a remote island to assist your research of native use of tools and usability. What do you bring? #TellMeAboutYou",
    likes: 2069,
    liked: true,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBarWidget(),
      body: Column(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(color: ColorConsts.secondaryColor),
              ),
            ),
            child: TweetWidget(tweet: tweet),
          ),
        ],
      ),
      floatingActionButton: const CreateTweetButtonWidget(),
      bottomNavigationBar: const BottomNavigationBarWidget(currentIndex: 1),
    );
  }
}
