import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';

class CityWidget extends StatelessWidget {
  const CityWidget({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Text(
        text,
        style: const TextStyle(
          color: ColorConsts.secondaryColor,
          fontSize: 20,
        ),
      ),
    );
  }
}
