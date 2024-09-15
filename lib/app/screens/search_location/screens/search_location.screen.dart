import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/widgets/search.widget.dart';

class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({
    super.key,
    required this.routePop,
    required this.setLocation,
  });
  final void Function() routePop;
  final void Function(String? location) setLocation;

  @override
  State<StatefulWidget> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  List<String> listLocations = [];

  void search(String searchText) async {
    // List<UserModel> newList =
    //     await userService.listUsersByText(text: searchText);

    // setState(() {
    //   listUsers = newList;
    // });
  }

  void goBack() {
    widget.setLocation(null);
    widget.routePop();
  }

  void onClick(String? location) {
    widget.setLocation(location);
    widget.routePop();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 0,
      ),
      body: Container(
        width: screenWidth,
        decoration: const BoxDecoration(color: ColorConsts.backgroundColor),
        child: Column(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: IconButton(
                      alignment: Alignment.bottomCenter,
                      onPressed: widget.routePop,
                      splashRadius: 1,
                      icon: const Icon(
                        Icons.close,
                        color: ColorConsts.secondaryColor,
                        size: 25,
                      ),
                    ),
                  ),
                  SearchWidget(
                    onSubmitted: search,
                    paddingHorizontal: 5,
                    width: screenWidth - 50,
                    hintText: "Buscar localização",
                  ),
                ],
              ),
            ),
            SizedBox(
              width: screenWidth,
              height: 50,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Text(
                  "Locais",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: ColorConsts.secondaryColor,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
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
