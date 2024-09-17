import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';

class CanRetweetWidget extends StatelessWidget {
  const CanRetweetWidget({
    super.key,
    required this.setCanRetweet,
    required this.canRetweet,
  });

  final void Function(bool value) setCanRetweet;
  final bool canRetweet;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () => setCanRetweet(!canRetweet),
          child: const Row(
            children: <Widget>[
              Icon(
                Icons.repeat,
                color: ColorConsts.primaryColor,
                size: 30,
              ),
              SizedBox(width: 7),
              Text(
                "Pode retweetar",
                style: TextStyle(
                  fontSize: 18,
                  color: ColorConsts.secondaryColor,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 35,
          height: 35,
          child: Switch(
            activeColor: ColorConsts.primaryColor,
            value: canRetweet,
            onChanged: (bool value) => setCanRetweet(value),
          ),
        ),
      ],
    );
  }
}
