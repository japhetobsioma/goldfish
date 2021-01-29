import 'package:flutter/material.dart';

import '../../model/CustomCard.dart';
import '../../constants.dart';
import 'Features.dart';

class FeaturesList extends StatefulWidget {
  const FeaturesList();

  @override
  _FeaturesListState createState() => _FeaturesListState();
}

class _FeaturesListState extends State<FeaturesList> {
  List<Container> indicators = [];
  int currentPage = 0;

  Widget updateIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: welcomeScreenCards.map((customCard) {
        var index = welcomeScreenCards.indexOf(customCard);
        return Container(
          width: 7.0,
          height: 7.0,
          margin: const EdgeInsets.symmetric(
            horizontal: 6.0,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentPage == index ? Color(0xFF0971FE) : Color(0xFFA6AEBD),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Features',
          style: kTitle2Style,
        ),
        const SizedBox(
          height: 12.0,
        ),
        Container(
          height: 335.0,
          width: double.infinity,
          child: PageView.builder(
            itemBuilder: (context, index) {
              return Opacity(
                opacity: currentPage == index ? 1.0 : 0.5,
                child: Features(
                  customCard: welcomeScreenCards[index],
                ),
              );
            },
            itemCount: welcomeScreenCards.length,
            controller: PageController(
              initialPage: 0,
              viewportFraction: 0.75,
            ),
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
          ),
        ),
        updateIndicators(),
      ],
    );
  }
}
