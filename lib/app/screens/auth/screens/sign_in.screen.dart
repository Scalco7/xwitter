import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/controllers/route.controller.dart';
import 'package:xwitter/app/common/controllers/user.controller.dart';
import 'package:xwitter/app/screens/auth/widgets/auth_button.widget.dart';
import 'package:xwitter/app/screens/auth/widgets/input.widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  static final IUserController userController = UserController();
  static final RouteController routeController = RouteController();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  void setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  void goToHomeScreen() {
    routeController.goToHomeScreen(context);
  }

  void disableKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void onSignIn() async {
    String email = emailController.text;
    String password = passwordController.text;

    setLoading(true);
    bool success =
        await userController.signIn(email: email, password: password);
    setLoading(false);

    if (success) {
      goToHomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.asset(
              "assets/icons/xwitter_logo.png",
              width: 60,
              fit: BoxFit.contain,
            ),
            SizedBox(
              height: 280,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InputWidget(
                        controller: emailController,
                        hintText: "felipe@gmail.com",
                        keyboardType: TextInputType.emailAddress,
                        labelText: 'E-mail',
                        isPassword: false,
                      ),
                      const SizedBox(height: 10),
                      InputWidget(
                        controller: passwordController,
                        hintText: '',
                        keyboardType: TextInputType.visiblePassword,
                        labelText: 'Senha',
                        isPassword: true,
                      ),
                      TextButton(
                        onPressed: () =>
                            routeController.goToSignUpScreen(context),
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: "Criar",
                                style: TextStyle(
                                  color: ColorConsts.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(text: " conta")
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  AuthButtonWidget(
                    isLoading: isLoading,
                    onPressed: () => onSignIn(),
                    text: "Entrar",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
