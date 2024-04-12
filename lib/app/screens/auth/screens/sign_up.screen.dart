import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/screens/auth/widgets/auth_button.widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
    required this.routePop,
    required this.onSignUp,
  });
  final void Function() routePop;
  final void Function(UserModel user) onSignUp;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  static UserModel user = UserModel(
    id: "001",
    name: "Felipe Scalco",
    nickname: "Scalco",
    avatarPath: "assets/avatars/batman.png",
    bio: "Olá eu sou o felipe",
    numberOfFollowers: 209,
    numberOfFollowings: 10,
  );

  String nickname = "";
  String email = "";
  String name = "";
  String password = "";
  String confirmPassword = "";

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
                            onTapOutside: (event) => disableKeyboard(),
                            onChanged: (value) => nickname = value,
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
                            onTapOutside: (event) => disableKeyboard(),
                            onChanged: (value) => email = value,
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
                            onTapOutside: (event) => disableKeyboard(),
                            onChanged: (value) => name = value,
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
                            onTapOutside: (event) => disableKeyboard(),
                            onChanged: (value) => password = value,
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
                            onTapOutside: (event) => disableKeyboard(),
                            onChanged: (value) => confirmPassword = value,
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
                    onPressed: () => widget.onSignUp(user),
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
