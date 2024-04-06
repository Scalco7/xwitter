import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/models/user.model.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({
    super.key,
    required this.currentIndex,
    required this.user,
  });
  final int currentIndex;
  final UserModel user;

  void onChangeTab(BuildContext context, int index) {
    if (index == currentIndex) {
      return;
    }

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, "/search");
        break;
      case 1:
        Navigator.pushReplacementNamed(context, "/home");
        break;
      case 2:
        Navigator.pushReplacementNamed(
          context,
          "/user",
          arguments: user,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: ColorConsts.secondaryColor),
        ),
      ),
      child: BottomNavigationBar(
        elevation: 0,
        onTap: (index) => onChangeTab(context, index),
        currentIndex: currentIndex,
        selectedFontSize: 0,
        selectedItemColor: ColorConsts.primaryColor,
        unselectedItemColor: ColorConsts.secondaryColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: "",
          ),
        ],
      ),
    );
  }
}
