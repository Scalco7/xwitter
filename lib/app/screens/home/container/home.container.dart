import 'package:flutter/widgets.dart';
import 'package:xwitter/app/common/error/failure.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/services/dataBase.service.dart';
import 'package:xwitter/app/common/widgets/bottom_navigation_bar.widget.dart';
import 'package:xwitter/app/common/widgets/loading.widget.dart';
import 'package:xwitter/app/screens/home/screens/home.screen.dart';

class HomeContainer extends StatelessWidget {
  const HomeContainer({
    super.key,
    required this.service,
    required this.userId,
    required this.goToTweetDetailsScreen,
    required this.bottomNavigationRoutes,
  });
  final IDataBaseService service;
  final String userId;
  final void Function(TweetModel tweet) goToTweetDetailsScreen;
  final BottomNavigationRoutesModel bottomNavigationRoutes;

  @override
  Widget build(BuildContext context) {
    IDataBaseService service = DataBaseService();

    return FutureBuilder<List<TweetModel>>(
        future: service.listTweets(userId: userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          }
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return HomeScreen(
                tweets: snapshot.data!,
                goToTweetDetailsScreen: goToTweetDetailsScreen,
                bottomNavigationRoutes: bottomNavigationRoutes);
          }
          if (snapshot.hasError) {
            return ErrorWidget((snapshot.error as Failure).message!);
          }
          return Container();
        });
  }
}
