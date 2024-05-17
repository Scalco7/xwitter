import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: ColorConsts.primaryColor,
        ),
      ),
    );
  }
}
