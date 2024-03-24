import 'package:flutter/material.dart';
import 'package:xwitter/common/consts/style.consts.dart';

class HomeAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBarWidget({super.key});
  static AppBar appBar = AppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: ColorConsts.secondaryColor, width: 1),
        ),
      ),
      child: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Image.asset(
            "assets/icons/xwitter_logo.png",
            width: 27,
            fit: BoxFit.contain,
          ),
        ),
        centerTitle: true,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
