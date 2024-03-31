import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/avatars_path.consts.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/common/widgets/bottom_navigation_bar.widget.dart';
import 'package:xwitter/app/common/widgets/create_tweet_button.widget.dart';
import 'package:xwitter/app/common/widgets/primary_button.widget.dart';
import 'package:xwitter/app/screens/edit_user/widgets/avatar_carousel.widget.dart';
import 'package:xwitter/app/screens/edit_user/widgets/edit_user_app_bar.widget.dart';

class EditUserScreen extends StatefulWidget {
  EditUserScreen({super.key, required this.user});
  final UserModel user;

  @override
  State<StatefulWidget> createState() => _EditUserScreen();
}

class _EditUserScreen extends State<EditUserScreen> {
  late TextEditingController nameField;
  late TextEditingController bioField;

  @override
  void initState() {
    nameField = TextEditingController(text: widget.user.name);
    bioField = TextEditingController(text: widget.user.bio);

    super.initState();
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

    void onSave() {
      print("salvando");
    }

    return Scaffold(
      appBar: EditUserAppBarWidget(
        height: headerHeight,
        nickname: widget.user.nickname,
      ),
      body: SizedBox(
        width: screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AvatarCarouselWidget(
              list: AvatarPathConsts.avatarPaths,
              initialPage: AvatarPathConsts.avatarPaths
                  .indexWhere((ap) => ap == widget.user.avatarPath),
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
                      controller: nameField,
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
                      controller: bioField,
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
      floatingActionButton: const CreateTweetButtonWidget(),
      bottomNavigationBar: const BottomNavigationBarWidget(currentIndex: 2),
    );
  }
}
