import 'package:flutter/widgets.dart';
import 'package:xwitter/app/common/controllers/route.controller.dart';
import 'package:xwitter/app/common/controllers/user.controller.dart';
import 'package:xwitter/app/common/error/failure.dart';
import 'package:xwitter/app/common/widgets/bt_error.widget.dart';
import 'package:xwitter/app/common/widgets/loading.widget.dart';
import 'package:xwitter/app/screens/auth/screens/sign_in.screen.dart';

class SignInContainer extends StatelessWidget {
  const SignInContainer({
    super.key,
    required this.goToSignUpScreen,
  });

  static final IUserController userController = UserController();
  static final RouteController routeController = RouteController();
  final void Function() goToSignUpScreen;

  @override
  Widget build(BuildContext context) {
    void goToHomeScreen() {
      routeController.goToHomeScreen(context);
    }

    Future<void> signInFromLocalData() async {
      bool success = await userController.signInFromLocalData();
      if (success) {
        goToHomeScreen();
      }
    }

    return FutureBuilder<void>(
      future: signInFromLocalData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return SignInScreen(
            goToSignUpScreen: goToSignUpScreen,
          );
        }
        if (snapshot.hasError) {
          return BTErrorWidget(error: (snapshot.error as Failure).message!);
        }

        return Container();
      },
    );
  }
}
