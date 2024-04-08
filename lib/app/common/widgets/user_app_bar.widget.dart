import 'package:flutter/material.dart';

class UserAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const UserAppBarWidget({
    super.key,
    required this.height,
    required this.nickname,
  });
  final double height;
  final String nickname;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromRGBO(31, 31, 31, 1),
      toolbarHeight: height,
      centerTitle: true,
      title: Text(
        "@$nickname",
        style: TextStyle(
          color: Colors.blueGrey.shade50,
          fontSize: 21,
          fontWeight: FontWeight.w800,
        ),
      ),
      leading: Visibility(
        visible: Navigator.of(context).canPop(),
        child: IconButton(
          alignment: Alignment.center,
          onPressed: () => Navigator.of(context).pop(),
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
