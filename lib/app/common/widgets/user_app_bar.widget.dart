import 'package:flutter/material.dart';
import 'package:xwitter/app/common/controllers/route.controller.dart';

class UserAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const UserAppBarWidget({
    super.key,
    required this.height,
    required this.text,
    required this.showActions,
  });
  final double height;
  final String text;
  final bool showActions;

  static final RouteController routeController = RouteController();

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromRGBO(31, 31, 31, 1),
      toolbarHeight: height,
      centerTitle: true,
      title: Text(
        text,
        style: TextStyle(
          color: Colors.blueGrey.shade50,
          fontSize: 21,
          fontWeight: FontWeight.w800,
        ),
      ),
      actions: <Widget>[
        Visibility(
          visible: showActions,
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () => routeController.goToSavedTweetsScreen(context),
                icon: const Icon(
                  Icons.bookmark,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () => routeController.goToSettingsScreen(context),
                icon: const Icon(
                  Icons.settings_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
      leading: Visibility(
        visible: Navigator.of(context).canPop(),
        child: IconButton(
          alignment: Alignment.center,
          onPressed: () => routeController.routePop(context),
          icon: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.chevron_left_rounded,
              color: Colors.white,
              size: 25,
            ),
          ),
        ),
      ),
    );
  }
}
