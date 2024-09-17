import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';

class TweetTextWidget extends StatelessWidget {
  const TweetTextWidget({
    super.key,
    required this.text,
    required this.mentionsIds,
    required this.fontSize,
  });

  final String text;
  final List<String> mentionsIds;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    List<String> textList = text.split(RegExp(r'(@:\S+)'));
    List<String> mentionsNames = RegExp(r'(@:\S+)')
        .allMatches(text, 0)
        .map((e) => e[0]!.replaceFirst(":", ""))
        .toList();

    TextStyle textStyle = TextStyle(
      color: ColorConsts.tweetTextColor,
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
    );
    TextStyle mentionStyle = const TextStyle(color: ColorConsts.primaryColor);
    List<InlineSpan> spanText = [];

    for (int i = 0; i < textList.length; i++) {
      spanText.add(TextSpan(text: textList[i]));
      spanText.add(TextSpan(
        text: i < mentionsNames.length ? mentionsNames[i] : '',
        style: mentionStyle,
      ));
    }

    return RichText(
      overflow: TextOverflow.clip,
      softWrap: true,
      text: TextSpan(
        style: textStyle,
        children: spanText,
      ),
    );
  }
}
