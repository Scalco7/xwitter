import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';

class TweetAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const TweetAppBarWidget({super.key});

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: IconButton(
        alignment: Alignment.center,
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(
          Icons.chevron_left_rounded,
          color: ColorConsts.primaryColor,
          size: 25,
        ),
      ),
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 17,
        fontWeight: FontWeight.w900,
      ),
      title: const Padding(
        padding: EdgeInsets.only(top: 15, bottom: 5),
        child: Text(
          "Tweet",
        ),
      ),
    );
  }
}
