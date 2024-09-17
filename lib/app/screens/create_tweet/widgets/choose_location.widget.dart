import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/controllers/route.controller.dart';

class ChooseLocationWidget extends StatelessWidget {
  const ChooseLocationWidget({
    super.key,
    required this.setTweetLocation,
    this.tweetLocation,
  });

  final void Function(String? location) setTweetLocation;
  final String? tweetLocation;

  static final RouteController routeController = RouteController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          routeController.goToSearchLocationScreen(context, setTweetLocation),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.location_on_rounded,
                color: ColorConsts.primaryColor,
                size: 30,
              ),
              const SizedBox(width: 7),
              Text(
                tweetLocation ?? "Adiconar localização",
                style: TextStyle(
                  fontSize: 18,
                  color: tweetLocation != null
                      ? Colors.black
                      : ColorConsts.secondaryColor,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => tweetLocation != null
                ? setTweetLocation(null)
                : routeController.goToSearchLocationScreen(
                    context, setTweetLocation),
            child: Icon(
              tweetLocation != null
                  ? Icons.close
                  : Icons.chevron_right_outlined,
              color: ColorConsts.secondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
