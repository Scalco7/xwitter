import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  static const InputBorder inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(50)),
    borderSide: BorderSide(
      color: Colors.transparent,
      width: 0,
    ),
  );

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/icons/xwitter_logo.png",
              width: 60,
              fit: BoxFit.contain,
            ),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Apelido / E-mail"),
                TextField(
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: ColorConsts.backgroundColor,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    disabledBorder: inputBorder,
                    border: inputBorder,
                    errorBorder: inputBorder,
                    enabledBorder: inputBorder,
                    focusedBorder: inputBorder,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
