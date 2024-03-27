import 'package:flutter/material.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/common/widgets/bottom_navigation_bar.widget.dart';
import 'package:xwitter/app/common/widgets/create_tweet_button.widget.dart';
import 'package:xwitter/app/common/widgets/tweet.widget.dart';
import 'package:xwitter/app/screens/user/widgets/change_section_button.widget.dart';
import 'package:xwitter/app/screens/user/widgets/user_data.widget.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({
    super.key,
    required this.user,
    required this.postTweets,
    required this.likedTweets,
  });
  final UserModel user;
  final List<TweetModel> postTweets;
  final List<TweetModel> likedTweets;

  void editUser() {
    print("ta editando");
  }

  @override
  State<UserScreen> createState() => _UserScreen();
}

class _UserScreen extends State<UserScreen> {
  late List<TweetModel> tweetsList;

  void setTweetsList(EListTweetsSection state) {
    setState(() {
      tweetsList = state == EListTweetsSection.publishedtTweets
          ? widget.postTweets
          : widget.likedTweets;
    });
  }

  @override
  void initState() {
    tweetsList = widget.postTweets;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    const double headerHeight = 80;
    const double avatarHeight = 70;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 0,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            width: screenWidth,
            height: headerHeight,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: Colors.black),
            child: Text(
              "@${widget.user.nickname}",
              style: TextStyle(
                color: Colors.blueGrey.shade50,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: headerHeight - (avatarHeight / 3),
            ),
            child: Column(
              children: <Widget>[
                UserDataWidget(
                  user: widget.user,
                  avatarHeight: avatarHeight,
                  editUser: widget.editUser,
                ),
                const SizedBox(height: 20),
                ChangeSectionButtonWidget(
                  onChange: setTweetsList,
                ),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      return TweetWidget(tweet: tweetsList[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                    itemCount: tweetsList.length,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: const CreateTweetButtonWidget(),
      bottomNavigationBar: const BottomNavigationBarWidget(currentIndex: 2),
    );
  }
}
