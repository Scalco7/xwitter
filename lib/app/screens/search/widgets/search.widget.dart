import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key, required this.onSubmitted});

  final Function(String text) onSubmitted;

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  InputBorder inputBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(50)),
    borderSide: BorderSide(
      color: Colors.transparent,
      width: 0,
    ),
  );
  String textSearch = "";
  bool inputFocus = false;
  late bool showSearchButton;

  void toogleShowSearch() {
    bool show = inputFocus || textSearch.isNotEmpty;

    if (show != showSearchButton) {
      setState(() {
        showSearchButton = show;
      });
    }
  }

  @override
  void initState() {
    showSearchButton = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 70,
      decoration: const BoxDecoration(color: Colors.white),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 25, left: 20, right: 20, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: TextField(
                textInputAction: TextInputAction.search,
                onSubmitted: (value) => widget.onSubmitted(textSearch),
                onChanged: (value) {
                  textSearch = value;
                  toogleShowSearch();
                },
                onTap: () {
                  inputFocus = true;
                  toogleShowSearch();
                },
                onTapOutside: (event) {
                  inputFocus = false;
                  toogleShowSearch();
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                textAlign: showSearchButton ? TextAlign.left : TextAlign.center,
                textAlignVertical: TextAlignVertical.bottom,
                style: const TextStyle(
                  color: ColorConsts.secondaryColor,
                  fontSize: 17,
                ),
                decoration: InputDecoration(
                  prefixIconColor: ColorConsts.secondaryColor,
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    size: 18,
                  ),
                  suffixIconColor: Colors.transparent,
                  suffixIcon: const Icon(
                    Icons.search_rounded,
                    size: 17,
                  ),
                  hintText: "Search user",
                  filled: true,
                  fillColor: ColorConsts.backgroundColor,
                  enabledBorder: inputBorder,
                  focusedBorder: inputBorder,
                  border: inputBorder,
                ),
              ),
            ),
            Visibility(
              visible: showSearchButton,
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: TextButton(
                  onPressed: () => widget.onSubmitted(textSearch),
                  style: const ButtonStyle(alignment: Alignment.center),
                  child: const Text(
                    "Search",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorConsts.primaryColor,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
