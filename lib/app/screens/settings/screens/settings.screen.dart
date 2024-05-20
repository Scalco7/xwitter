import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/controllers/user.controller.dart';
import 'package:xwitter/app/screens/settings/widgets/settings_app_bar.widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.userController,
    required this.goToSignInScreen,
  });
  final IUserController userController;
  final void Function() goToSignInScreen;

  void logout() async {
    bool success = await userController.logout();

    if (success) {
      goToSignInScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SettingsAppBarWidget(),
      backgroundColor: ColorConsts.backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 70,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(width: 2, color: Colors.black)),
              color: Colors.white,
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: logout,
                child: const Text(
                  "Sair da conta",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: ColorConsts.errorColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
