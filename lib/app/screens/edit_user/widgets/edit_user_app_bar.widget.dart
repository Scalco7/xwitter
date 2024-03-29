import 'package:flutter/material.dart';

class EditUserAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const EditUserAppBarWidget({
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
      leading: IconButton(
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
    );
  }
}
