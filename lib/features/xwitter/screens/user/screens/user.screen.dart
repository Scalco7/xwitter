import 'package:flutter/material.dart';
import 'package:xwitter/common/consts/style.consts.dart';
import 'package:xwitter/common/models/tweet.model.dart';
import 'package:xwitter/common/models/user.model.dart';
import 'package:xwitter/common/widgets/bottom_navigation_bar.widget.dart';
import 'package:xwitter/common/widgets/create_tweet_button.widget.dart';
import 'package:xwitter/common/widgets/tweet.widget.dart';
import 'package:xwitter/features/xwitter/screens/user/widgets/user_data.widget.dart';

enum ESection { tweets, likes }

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
  late ESection selectedSection;

  void changeSelectedSection(ESection state) {
    setState(() {
      selectedSection = state;
    });
  }

  @override
  void initState() {
    selectedSection = ESection.tweets;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    const double headerHeight = 80;
    const double avatarHeight = 70;

    List<TweetModel> tweetsList = selectedSection == ESection.tweets
        ? widget.postTweets
        : widget.likedTweets;

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () => changeSelectedSection(ESection.tweets),
                        child: Container(
                          width: double.maxFinite,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: selectedSection == ESection.tweets
                                  ? const BorderSide(
                                      width: 2,
                                      color: ColorConsts.primaryColor,
                                    )
                                  : const BorderSide(
                                      width: 1,
                                      color: ColorConsts.secondaryColor,
                                    ),
                            ),
                          ),
                          child: Text(
                            "Tweets",
                            style: TextStyle(
                              color: selectedSection == ESection.tweets
                                  ? ColorConsts.primaryColor
                                  : ColorConsts.secondaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => changeSelectedSection(ESection.likes),
                        child: Container(
                          width: double.maxFinite,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: selectedSection == ESection.likes
                                  ? const BorderSide(
                                      width: 2,
                                      color: ColorConsts.primaryColor,
                                    )
                                  : const BorderSide(
                                      width: 1,
                                      color: ColorConsts.secondaryColor,
                                    ),
                            ),
                          ),
                          child: Text(
                            "Likes",
                            style: TextStyle(
                              color: selectedSection == ESection.likes
                                  ? ColorConsts.primaryColor
                                  : ColorConsts.secondaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
