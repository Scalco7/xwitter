import 'package:flutter/material.dart';

class SettingsAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const SettingsAppBarWidget({super.key});
  static AppBar appBar = AppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black, width: 0.7),
        ),
      ),
      child: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 65,
        centerTitle: true,
        title: const Text(
          "Configurações",
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Image.asset(
              "assets/icons/xwitter_logo.png",
              width: 27,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
