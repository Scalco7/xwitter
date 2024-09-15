import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/services/location.service.dart';
import 'package:xwitter/app/common/widgets/search.widget.dart';
import 'package:xwitter/app/screens/search_location/widgets/city.widget.dart';

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
  List<String>? listLocations;

  void search(String searchText) async {
    List<String> newLocations =
        await LocationService().listLocations(searchText: searchText);

    setState(() {
      listLocations = newLocations;
    });
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
  void initState() {
    search('');
    super.initState();
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
            const Divider(),
            listLocations == null
                ? const Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: CircularProgressIndicator(
                        color: ColorConsts.primaryColor,
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          key: Key("search-location-$index"),
                          onTap: () => onClick(listLocations![index]),
                          child: CityWidget(
                            text: listLocations![index],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      itemCount: listLocations!.length,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
