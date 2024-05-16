import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class AvatarCarouselWidget extends StatefulWidget {
  const AvatarCarouselWidget({
    super.key,
    required this.list,
    required this.initialPage,
    required this.changeSelected,
  });
  final List<String> list;
  final int initialPage;
  final void Function(int index) changeSelected;

  @override
  State<StatefulWidget> createState() => _AvatarCarouselWidget();
}

class _AvatarCarouselWidget extends State<AvatarCarouselWidget> {
  late int selectedIndex;

  void setSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.changeSelected(index);
  }

  @override
  void initState() {
    selectedIndex = widget.initialPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: CarouselSlider.builder(
        itemCount: widget.list.length,
        itemBuilder: (context, itemIndex, pageViewIndex) {
          return Container(
            key: Key(widget.list[itemIndex]),
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              border: selectedIndex == itemIndex
                  ? Border.all(
                      width: 3,
                      color: Colors.blueAccent.shade400,
                    )
                  : null,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Image.asset(
              widget.list[itemIndex],
              fit: BoxFit.cover,
            ),
          );
        },
        options: CarouselOptions(
          height: 70,
          initialPage: widget.initialPage,
          enlargeCenterPage: true,
          enlargeStrategy: CenterPageEnlargeStrategy.zoom,
          viewportFraction: 0.2,
          onPageChanged: (index, reason) => setSelected(index),
        ),
      ),
    );
  }
}
