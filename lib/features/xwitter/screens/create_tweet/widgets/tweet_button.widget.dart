import 'package:flutter/material.dart';
import 'package:xwitter/common/consts/style.consts.dart';

class TweetButtonWidget extends StatelessWidget {
  const TweetButtonWidget({
    super.key,
    required this.disabled,
    required this.onPressButton,
  });
  final bool disabled;
  final Function() onPressButton;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (disabled) {
              return ColorConsts.buttonNonActive;
            }
            if (states.contains(MaterialState.pressed)) {
              return Theme.of(context).colorScheme.primary.withOpacity(0.5);
            }
            return ColorConsts.primaryColor;
          },
        ),
        padding: const MaterialStatePropertyAll<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        ),
      ),
      onPressed: () => disabled ? null : onPressButton(),
      child: const Text(
        "Tweet",
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
    );
  }
}
