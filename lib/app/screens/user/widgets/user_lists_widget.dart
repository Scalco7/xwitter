import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/controllers/route.controller.dart';
import 'package:xwitter/app/common/controllers/tweet.controller.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/models/user_data.model.dart';
import 'package:xwitter/app/common/widgets/tweet.widget.dart';
import 'package:xwitter/app/screens/user/widgets/change_section_button.widget.dart';

class UserListsWidget extends StatefulWidget {
  const UserListsWidget({
    super.key,
    required this.tweetsList,
    required this.actualListState,
    required this.setTweetsList,
    this.userDataLists,
  });

  final List<TweetModel> tweetsList;
  final EListTweetsSection actualListState;
  final UserData? userDataLists;
  final void Function(EListTweetsSection state) setTweetsList;

  @override
  State<UserListsWidget> createState() => _UserListsWidgetState();
}

class _UserListsWidgetState extends State<UserListsWidget> {
  static final ITweetController tweetController = TweetController();
  static final RouteController routeController = RouteController();

  Offset _tapPosition = Offset.zero;

  void reloadPage() {
    setState(() {});
  }

  void handleTweetLongPress(BuildContext context, TweetModel tweet) {
    if (tweet.isPinned ||
        widget.userDataLists!.postedTweets.every((t) => !t.isPinned)) {
      showContextMenu(context, tweet);
    }
  }

  void getTapPosition(LongPressDownDetails tapPosition) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    _tapPosition = renderBox.globalToLocal(tapPosition.globalPosition);
  }

  void showContextMenu(BuildContext context, TweetModel tweet) async {
    String text = tweet.isPinned ? "Desfixar" : "Fixar";
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();

    await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 10, 10),
        Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
            overlay.paintBounds.size.height),
      ),
      items: [
        PopupMenuItem(
          value: 'Fix',
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          height: 10,
          onTap: () => tooglePinTweet(tweet),
          child: Text(
            text,
            style: const TextStyle(
              color: ColorConsts.primaryColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        )
      ],
    );
  }

  void tooglePinTweet(TweetModel tweet) async {
    List<TweetModel> postedTweets =
        await tweetController.tooglePinTweet(tweet: tweet);
    widget.userDataLists!.postedTweets = postedTweets;

    widget.setTweetsList(EListTweetsSection.publishedtTweets);
  }

  bool listsIsLoaded() {
    return widget.userDataLists != null;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: !listsIsLoaded()
          ? const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: CircularProgressIndicator(
                  color: ColorConsts.primaryColor,
                ),
              ),
            )
          : widget.tweetsList.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      widget.actualListState ==
                              EListTweetsSection.publishedtTweets
                          ? "Você não postou nenhum Tweet ainda"
                          : "Você não curtiu nenhum tweet ainda",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: ColorConsts.secondaryColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.actualListState ==
                              EListTweetsSection.publishedtTweets
                          ? "Poste seu primeiro tweet clicando no botão azul no canto inferior direito"
                          : "Curta seu primeiro tweet clicando no coração em baixo de algum tweet",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: ColorConsts.secondaryColor,
                      ),
                    ),
                  ],
                )
              : ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    TweetModel tweet = widget.tweetsList[index];
                    return GestureDetector(
                      key: Key("user-tweet-${tweet.id}"),
                      onTap: () => routeController.goToTweetDetailsScreen(
                        context,
                        tweet,
                        reloadPage,
                      ),
                      onLongPress: () => handleTweetLongPress(context, tweet),
                      onLongPressDown: (position) => getTapPosition(position),
                      child: TweetWidget(
                        tweet: tweet,
                        isComment: false,
                        onLikedTweet: ({required liked}) =>
                            tweetController.onLikedTweet(
                          tweet: tweet,
                          liked: liked,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  itemCount: widget.tweetsList.length,
                ),
    );
  }
}
