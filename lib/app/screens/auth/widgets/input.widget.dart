import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';

class InputWidget extends StatefulWidget {
  const InputWidget({
    super.key,
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    required this.labelText,
    required this.isPassword,
  });

  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final String hintText;
  final String labelText;

  @override
  State<InputWidget> createState() => _InputWidtgetState();
}

class _InputWidtgetState extends State<InputWidget> {
  bool showText = false;

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
  void initState() {
    showText = !widget.isPassword;
    super.initState();
  }

  void toogleShowText() {
    setState(() {
      showText = !showText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Text(widget.labelText),
        ),
        Stack(
          children: <Widget>[
            TextField(
              onTapOutside: (event) => disableKeyboard(),
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              style: const TextStyle(fontSize: 14),
              obscureText: !showText,
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                hintText: widget.hintText,
                fillColor: ColorConsts.backgroundColor,
                contentPadding: EdgeInsets.only(
                  right: widget.isPassword ? 35 : 15,
                  top: 8,
                  bottom: 8,
                  left: 15,
                ),
                disabledBorder: inputBorder,
                border: inputBorder,
                errorBorder: inputBorder,
                enabledBorder: inputBorder,
                focusedBorder: inputBorder,
              ),
            ),
            Visibility(
              visible: widget.isPassword,
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: IconButton(
                        padding: const EdgeInsets.all(0),
                        iconSize: 20,
                        onPressed: () => toogleShowText(),
                        icon: Icon(
                          showText ? Icons.visibility_off : Icons.visibility,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
