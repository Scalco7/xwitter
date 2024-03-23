import 'package:flutter/material.dart';

class HomeAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBarWidget({super.key});
  static AppBar appBar = AppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      shadowColor: Colors.blueGrey,
      title: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Image.asset(
          "assets/icons/xwitter_logo.png",
          width: 27,
          fit: BoxFit.contain,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
