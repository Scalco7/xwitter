import 'package:flutter/material.dart';
import 'package:xwitter/common/consts/style.consts.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({super.key, required this.currentIndex});
  final int currentIndex;
  static const Color defaultColor = Color.fromRGBO(104, 118, 132, 1);

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
        Navigator.pushReplacementNamed(context, "/user");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) => onChangeTab(context, index),
      currentIndex: currentIndex,
      selectedFontSize: 0,
      selectedItemColor: ColorConsts.primaryColor,
      unselectedItemColor: defaultColor,
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
    );
  }
}
