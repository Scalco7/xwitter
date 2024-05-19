import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/controllers/user.controller.dart';
import 'package:xwitter/app/screens/auth/widgets/auth_button.widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
    required this.routePop,
    required this.goToHomeScreen,
    required this.userController,
  });
  final void Function() routePop;
  final void Function() goToHomeScreen;
  final IUserController userController;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nicknameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  static const InputBorder inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(50)),
    borderSide: BorderSide(
      color: Colors.transparent,
      width: 0,
    ),
  );

  void disableKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void signUp() async {
    String nickname = nicknameController.text;
    String email = emailController.text;
    String name = nameController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    bool success = await widget.userController.signUp(
      nickname: nickname,
      email: email,
      name: name,
      password: password,
      confirmPassword: confirmPassword,
    );

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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: Text("Apelido"),
                          ),
                          TextField(
                            controller: nicknameController,
                            onTapOutside: (event) => disableKeyboard(),
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                              isDense: true,
                              filled: true,
                              hintText: "felipe",
                              fillColor: ColorConsts.backgroundColor,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              disabledBorder: inputBorder,
                              border: inputBorder,
                              errorBorder: inputBorder,
                              enabledBorder: inputBorder,
                              focusedBorder: inputBorder,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: Text("E-mail"),
                          ),
                          TextField(
                            controller: emailController,
                            onTapOutside: (event) => disableKeyboard(),
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                              isDense: true,
                              filled: true,
                              hintText: "felipe@gmail.com",
                              fillColor: ColorConsts.backgroundColor,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              disabledBorder: inputBorder,
                              border: inputBorder,
                              errorBorder: inputBorder,
                              enabledBorder: inputBorder,
                              focusedBorder: inputBorder,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: Text("Nome completo"),
                          ),
                          TextField(
                            controller: nameController,
                            onTapOutside: (event) => disableKeyboard(),
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                              isDense: true,
                              filled: true,
                              hintText: "Felipe da Silva",
                              fillColor: ColorConsts.backgroundColor,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              disabledBorder: inputBorder,
                              border: inputBorder,
                              errorBorder: inputBorder,
                              enabledBorder: inputBorder,
                              focusedBorder: inputBorder,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: Text("Senha"),
                          ),
                          TextField(
                            controller: passwordController,
                            onTapOutside: (event) => disableKeyboard(),
                            style: const TextStyle(fontSize: 14),
                            obscureText: true,
                            decoration: const InputDecoration(
                              isDense: true,
                              filled: true,
                              fillColor: ColorConsts.backgroundColor,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              disabledBorder: inputBorder,
                              border: inputBorder,
                              errorBorder: inputBorder,
                              enabledBorder: inputBorder,
                              focusedBorder: inputBorder,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: Text("Confirmar senha"),
                          ),
                          TextField(
                            controller: confirmPasswordController,
                            onTapOutside: (event) => disableKeyboard(),
                            style: const TextStyle(fontSize: 14),
                            obscureText: true,
                            decoration: const InputDecoration(
                              isDense: true,
                              filled: true,
                              fillColor: ColorConsts.backgroundColor,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              disabledBorder: inputBorder,
                              border: inputBorder,
                              errorBorder: inputBorder,
                              enabledBorder: inputBorder,
                              focusedBorder: inputBorder,
                            ),
                          ),
                        ],
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
