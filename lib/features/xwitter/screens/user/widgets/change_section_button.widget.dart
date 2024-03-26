import 'package:flutter/material.dart';
import 'package:xwitter/common/consts/style.consts.dart';

enum EListTweetsSection {
  publishedtTweets,
  likedTweets,
}

class ChangeSectionButtonWidget extends StatefulWidget {
  const ChangeSectionButtonWidget({
    super.key,
    required this.onChange,
  });
  final Function(EListTweetsSection list) onChange;

  @override
  State<ChangeSectionButtonWidget> createState() =>
      _ChangeSectionButtonWidgetState();
}

class _ChangeSectionButtonWidgetState extends State<ChangeSectionButtonWidget> {
  late EListTweetsSection selectedSection;

  void changeSelectedSection(EListTweetsSection state) {
    setState(() {
      selectedSection = state;
      widget.onChange(selectedSection);
    });
  }

  @override
  void initState() {
    selectedSection = EListTweetsSection.publishedtTweets;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            onTap: () =>
                changeSelectedSection(EListTweetsSection.publishedtTweets),
            child: Container(
              width: double.maxFinite,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: selectedSection == EListTweetsSection.publishedtTweets
                      ? const BorderSide(
                          width: 2,
                          color: ColorConsts.primaryColor,
                        )
                      : const BorderSide(
                          width: 1,
                          color: ColorConsts.secondaryColor,
                        ),
                ),
              ),
              child: Text(
                "Tweets",
                style: TextStyle(
                  color: selectedSection == EListTweetsSection.publishedtTweets
                      ? ColorConsts.primaryColor
                      : ColorConsts.secondaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => changeSelectedSection(EListTweetsSection.likedTweets),
            child: Container(
              width: double.maxFinite,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: selectedSection == EListTweetsSection.likedTweets
                      ? const BorderSide(
                          width: 2,
                          color: ColorConsts.primaryColor,
                        )
                      : const BorderSide(
                          width: 1,
                          color: ColorConsts.secondaryColor,
                        ),
                ),
              ),
              child: Text(
                "Likes",
                style: TextStyle(
                  color: selectedSection == EListTweetsSection.likedTweets
                      ? ColorConsts.primaryColor
                      : ColorConsts.secondaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
