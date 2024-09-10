import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';

class AuthButtonWidget extends StatelessWidget {
  const AuthButtonWidget({
    super.key,
    required this.isLoading,
    required this.text,
    required this.onPressed,
  });
  final bool isLoading;
  final String text;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : () => onPressed(),
      style: ButtonStyle(
        minimumSize: MaterialStatePropertyAll<Size>(
            Size(MediaQuery.of(context).size.width * 0.7, 40)),
        elevation: const MaterialStatePropertyAll<double>(0),
        backgroundColor: const MaterialStatePropertyAll(Colors.white),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
              side: const BorderSide(
                width: 2,
                color: ColorConsts.primaryColor,
              ),
              borderRadius: BorderRadius.circular(20)),
        ),
        padding: const MaterialStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 15, vertical: 2),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: ColorConsts.primaryColor,
              ),
            )
          : Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: ColorConsts.primaryColor,
              ),
            ),
    );
  }
}
