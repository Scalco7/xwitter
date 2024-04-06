import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/screens/route.dart';

class Xwitter extends StatelessWidget {
  const Xwitter({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ColorConsts.primaryColor),
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const XWitterRoute(),
    );
  }
}
