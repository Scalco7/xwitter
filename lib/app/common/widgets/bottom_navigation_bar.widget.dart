import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';

class BottomNavigationRoutesModel {
  final void Function(BuildContext context) goToSearchScreen;
  final void Function(BuildContext context) goToHomeScreen;
  final void Function(BuildContext context) goToUserScreen;

  const BottomNavigationRoutesModel({
    required this.goToSearchScreen,
    required this.goToHomeScreen,
    required this.goToUserScreen,
  });
}

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({
    super.key,
    required this.currentIndex,
    required this.bottomNavigationRoutes,
  });
  final int currentIndex;
  final BottomNavigationRoutesModel bottomNavigationRoutes;

  void onChangeTab(BuildContext context, int index) {
    switch (index) {
      case 0:
        bottomNavigationRoutes.goToSearchScreen(context);
        break;
      case 1:
        bottomNavigationRoutes.goToHomeScreen(context);
        break;
      case 2:
        bottomNavigationRoutes.goToUserScreen(context);
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
