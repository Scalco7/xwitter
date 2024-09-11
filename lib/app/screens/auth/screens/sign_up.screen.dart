import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/controllers/user.controller.dart';
import 'package:xwitter/app/screens/auth/widgets/auth_button.widget.dart';
import 'package:xwitter/app/screens/auth/widgets/input.widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
    required this.routePop,
    required this.goToHomeScreen,
  });

  final void Function() routePop;
  final void Function() goToHomeScreen;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final IUserController userController = UserController();

  TextEditingController nicknameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool isLoading = false;

  void setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  void disableKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void signUp() async {
    String nickname = nicknameController.text;
    String email = emailController.text;
    String name = nameController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    setLoading(true);
    bool success = await userController.signUp(
      nickname: nickname,
      email: email,
      name: name,
      password: password,
      confirmPassword: confirmPassword,
    );
    setLoading(false);

    if (success) {
      widget.goToHomeScreen();
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
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InputWidget(
                        controller: nicknameController,
                        hintText: "felipe",
                        keyboardType: TextInputType.name,
                        labelText: "Apelido",
                        isPassword: false,
                      ),
                      const SizedBox(height: 10),
                      InputWidget(
                        controller: emailController,
                        hintText: "felipe@gmail.com",
                        keyboardType: TextInputType.emailAddress,
                        labelText: "E-mail",
                        isPassword: false,
                      ),
                      const SizedBox(height: 10),
                      InputWidget(
                        controller: nameController,
                        hintText: "Felipe da Silva",
                        keyboardType: TextInputType.name,
                        labelText: "Nome completo",
                        isPassword: false,
                      ),
                      const SizedBox(height: 10),
                      InputWidget(
                        controller: passwordController,
                        hintText: "",
                        keyboardType: TextInputType.visiblePassword,
                        labelText: "Senha",
                        isPassword: true,
                      ),
                      const SizedBox(height: 10),
                      InputWidget(
                        controller: confirmPasswordController,
                        hintText: "",
                        keyboardType: TextInputType.visiblePassword,
                        labelText: "Confirmar senha",
                        isPassword: true,
                      ),
                      TextButton(
                        onPressed: widget.routePop,
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: "Já",
                                style: TextStyle(
                                  color: ColorConsts.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(text: " tenho uma conta"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  AuthButtonWidget(
                    isLoading: isLoading,
                    onPressed: () => signUp(),
                    text: "Criar conta",
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
