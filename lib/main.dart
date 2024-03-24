import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xwitter/common/consts/style.consts.dart';
import 'package:xwitter/common/models/tweet.model.dart';
import 'package:xwitter/common/models/user.model.dart';
import 'package:xwitter/common/widgets/bottom_navigation_bar.widget.dart';
import 'package:xwitter/common/widgets/create_tweet_button.widget.dart';
import 'package:xwitter/common/widgets/tweet.widget.dart';
import 'package:xwitter/features/xwitter/screens/home/widgets/home_app_bar.widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: const MyTestPage(),
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
  static TweetModel tweet = TweetModel(
      id: "001",
      user: user,
      tweet:
          "UXR/UX: You can only bring one item to a remote island to assist your research of native use of tools and usability. What do you bring? #TellMeAboutYou",
      likes: 2069,
      liked: true);

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
