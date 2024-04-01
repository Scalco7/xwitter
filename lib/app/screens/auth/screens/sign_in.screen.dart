import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/screens/auth/widgets/auth_button.widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String nickname = "";
  String password = "";

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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: Text("Apelido / E-mail"),
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
                      TextButton(
                        onPressed: () =>
                            Navigator.of(context).pushNamed("/sign-up"),
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
                    onPressed: () =>
                        Navigator.of(context).pushReplacementNamed("/home"),
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
