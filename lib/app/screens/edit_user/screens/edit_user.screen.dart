import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/avatars_path.consts.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/common/widgets/bottom_navigation_bar.widget.dart';
import 'package:xwitter/app/common/widgets/primary_button.widget.dart';
import 'package:xwitter/app/common/widgets/user_app_bar.widget.dart';
import 'package:xwitter/app/screens/edit_user/widgets/avatar_carousel.widget.dart';

class EditUserScreen extends StatefulWidget {
  const EditUserScreen({
    super.key,
    required this.user,
    required this.routePop,
    required this.onSaveUser,
    required this.bottomNavigationRoutes,
  });
  final UserModel user;
  final void Function() routePop;
  final void Function({
    required String name,
    required String bio,
    required String avatarPath,
  }) onSaveUser;
  final BottomNavigationRoutesModel bottomNavigationRoutes;

  @override
  State<StatefulWidget> createState() => _EditUserScreen();
}

class _EditUserScreen extends State<EditUserScreen> {
  late TextEditingController nameController;
  late TextEditingController bioController;
  late String avatarPathController;

  @override
  void initState() {
    nameController = TextEditingController(text: widget.user.name);
    bioController = TextEditingController(text: widget.user.bio);
    avatarPathController = widget.user.avatarPath;
    super.initState();
  }

  void onSave() {
    String name = nameController.text;
    String bio = bioController.text;

    widget.onSaveUser(name: name, bio: bio, avatarPath: avatarPathController);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    const double headerHeight = 80;

    const InputBorder inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      borderSide: BorderSide(
        color: Colors.black,
        width: 1,
      ),
    );

    void disableKeyboard() {
      FocusScope.of(context).requestFocus(FocusNode());
    }

    void setAvatarPathSelected(int index) {
      avatarPathController = AvatarPathConsts.avatarPaths[index];
    }

    return Scaffold(
      appBar: UserAppBarWidget(
        height: headerHeight,
        nickname: widget.user.nickname,
        routePop: widget.routePop,
      ),
      body: SizedBox(
        width: screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AvatarCarouselWidget(
              changeSelected: setAvatarPathSelected,
              list: AvatarPathConsts.avatarPaths,
              initialPage: AvatarPathConsts.avatarPaths
                  .indexWhere((ap) => ap == avatarPathController),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(5),
                    child: Text("Nome: "),
                  ),
                  SizedBox(
                    height: 55,
                    child: TextField(
                      onTapOutside: (event) => disableKeyboard(),
                      controller: nameController,
                      maxLines: 1,
                      maxLength: 30,
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        disabledBorder: inputBorder,
                        border: inputBorder,
                        errorBorder: inputBorder,
                        enabledBorder: inputBorder,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(5),
                    child: Text("Bio: "),
                  ),
                  SizedBox(
                    height: 200,
                    child: TextField(
                      onTapOutside: (event) => disableKeyboard(),
                      controller: bioController,
                      maxLines: 4,
                      maxLength: 100,
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        disabledBorder: inputBorder,
                        border: inputBorder,
                        errorBorder: inputBorder,
                        enabledBorder: inputBorder,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  PrimaryButtonWidget(
                    text: "Save",
                    onPressed: onSave,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: 2,
        bottomNavigationRoutes: widget.bottomNavigationRoutes,
      ),
    );
  }
}
