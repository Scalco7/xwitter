import 'package:flutter/widgets.dart';
import 'package:xwitter/app/common/controllers/user.controller.dart';
import 'package:xwitter/app/common/error/failure.dart';
import 'package:xwitter/app/common/widgets/loading.widget.dart';
import 'package:xwitter/app/screens/auth/screens/sign_in.screen.dart';

class SignInContainer extends StatelessWidget {
  const SignInContainer({
    super.key,
    required this.userController,
    required this.goToSignUpScreen,
    required this.goToHomeScreen,
  });
  final void Function() goToSignUpScreen;
  final void Function() goToHomeScreen;
  final IUserController userController;

  Future<void> signInFromLocalData() async {
    bool success = await userController.signInFromLocalData();
    if (success) {
      goToHomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: signInFromLocalData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        }
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return SignInScreen(
            goToSignUpScreen: goToSignUpScreen,
            goToHomeScreen: goToHomeScreen,
            userController: userController,
          );
        }
        if (snapshot.hasError) {
          return ErrorWidget((snapshot.error as Failure).message!);
        }

        return Container();
      },
    );
  }
}
